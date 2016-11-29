//
//  AlarmTableViewController.swift
//  wakerapper
//
//  Created by Shiv Kalola on 4/26/16.
//  Copyright © 2016 Nobel Apps. All rights reserved.
//

import UIKit
import MapKit

class AlarmTableViewController: UITableViewController, UINavigationBarDelegate, CLLocationManagerDelegate {
    
    var alarms:[Alarm] = []
    let locationManager = CLLocationManager()
    let noDataLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "BGmobile"))
        
        self.clearsSelectionOnViewWillAppear = true
        
        tableView.tableFooterView = UIView()
        
        self.tableView.reloadData()
        
        // Configure data source
        alarms = AlarmList.sharedInstance.allAlarms()
        
        // Check if empty
        noDataLabel.text = "No scheduled alarms"
        noDataLabel.font = UIFont(name: "Lato", size: 20)
        noDataLabel.textAlignment = NSTextAlignment.center
        noDataLabel.textColor = UIColor(hue: 0.5833, saturation: 0.44, brightness: 0.36, alpha: 1.0)
        noDataLabel.alpha = 0.0
        self.tableView.backgroundView = noDataLabel
        checkScheduledAlarms()
        
        // Enable edit button
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        
        // Manage selection during editing mode
        self.tableView.allowsSelection = false
        self.tableView.allowsSelectionDuringEditing = true
        
        // Set up the CLLocationManager, adjust location updates here
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        self.locationManager.distanceFilter = kCLLocationAccuracyKilometer
        
        // Helper Snippets
        // self.tableView.beginUpdates()
        // self.tableView.endUpdates()
        // print("shiv", UIApplication.shared.scheduledLocalNotifications)
        // print("shiv3", checkScheduledAlarms())
        // UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkScheduledAlarms()
        
        super.viewWillAppear(animated)
        
        // Add a background view to the table view
        tableView.backgroundView = UIImageView(image: UIImage(named: "BGmobile2"))
        tableView.contentMode = .scaleAspectFill
        
    }
    
    /* HANDLE EMPTY DATA SOURCE */
    
    func checkScheduledAlarms () {
        UIView.animate(withDuration: 0.25, animations: {
            if self.alarms.count == 0 {
                self.noDataLabel.alpha = 1.0
            } else {
                self.noDataLabel.alpha = 0.0
            }
        })
    }
    
    /* CONFIGURE ROWS AND SECTIONS */
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return alarms.count
    }
    
    /* CONFIGURE CELL */
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath as IndexPath) as! AlarmTableViewCell
        cell.alarmTime.text! = alarms[indexPath.row].getWakeupString()
        cell.alarmDestination!.text = ( "BEDTIMES:" + " " + alarms[indexPath.row].getBedtimeString())
        cell.alarmToggle.tag = indexPath.row
        cell.alarmToggle.addTarget(self, action: #selector(toggleAlarm(_:)), for: UIControlEvents.valueChanged)
        cell.accessoryView = cell.alarmToggle
        return cell
    }
    
    /* TOGGLE ALARM STATE */
    
    func toggleAlarm (_ switchState: UISwitch) {
        let index = switchState.tag
        
        if switchState.isOn {
            alarms[index].turnOn()
            AlarmList.sharedInstance.scheduleNotification(alarm: alarms[index], category: "ALARM_CATEGORY")
            AlarmList.sharedInstance.scheduleNotification(alarm: alarms[index], category: "FOLLOWUP_CATEGORY")
        } else {
            alarms[index].turnOff()
            AlarmList.sharedInstance.cancelNotification(alarm: alarms[index], category: "ALARM_CATEGORY")
            AlarmList.sharedInstance.cancelNotification(alarm: alarms[index], category: "FOLLOWUP_CATEGORY")
        }
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    /* ENABLE EDITING */
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            AlarmList.sharedInstance.removeAlarm(alarmToRemove: alarms[indexPath.row]) // remove from persistent data
            AlarmList.sharedInstance.cancelNotification(alarm: alarms[indexPath.row], category: "ALARM_CATEGORY")
            AlarmList.sharedInstance.cancelNotification(alarm: alarms[indexPath.row], category: "FOLLOWUP_CATEGORY")
            alarms.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
            
            // Update tags for alarm state
            var t = 0
            for cell in tableView.visibleCells as! [AlarmTableViewCell] {
                cell.alarmToggle.tag = t
                
                return t += 1
            }
            
            checkScheduledAlarms()
        }
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.isEditing == true) {
            performSegue(withIdentifier: "editAlarm", sender: self)
        }
    }
    
    /* NAVIGATION */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navVC = segue.destination as! UINavigationController
        let detailTVC = navVC.viewControllers.first as! DetailTableViewController
        
        if (segue.identifier == "editAlarm") {
            let indexPath = self.tableView.indexPathForSelectedRow!
            detailTVC.alarm = alarms[indexPath.row].copy()
            detailTVC.title = "Edit Alarm"
        } else {
            detailTVC.title = "Add Alarm"
        }
    }
    
    /* UNWIND SEGUES */
    
    @IBAction func saveAlarm (segue:UIStoryboardSegue) {
        let detailTVC = segue.source as! DetailTableViewController
        let newAlarm = detailTVC.alarm.copy()
        
        if (self.tableView.isEditing == false) {
            // TODO: FIX THIS!!!
            if (newAlarm.destination.name == "") {
                return
            }
            
            let indexPath = NSIndexPath(row: alarms.count, section: 0)
            alarms.append(newAlarm)
            AlarmList.sharedInstance.addAlarm(newAlarm: newAlarm)
            
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [indexPath as IndexPath], with: .fade)
            self.tableView.endUpdates()
        } else {
            if self.tableView.indexPathForSelectedRow != nil {
                let indexPath = self.tableView.indexPathForSelectedRow!
                
                self.alarms[indexPath.row] = detailTVC.alarm.copy()
                AlarmList.sharedInstance.updateAlarm(alarmToUpdate: self.alarms[indexPath.row])
                self.tableView.beginUpdates()
                self.tableView.reloadRows(at: [indexPath], with: .fade)
                self.tableView.endUpdates()
            }
        }
    }
    
    @IBAction func cancelAlarm (segue:UIStoryboardSegue) {
        // Do nothing!
    }
    
    
    /* BACKGROUND REFRESH */
    
    // TODO: FIX!!!
    
    private func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        //for alarm in self.alarms {
        for index in 0 ..< alarms.count {
            let alarm = alarms[index]
            
            if alarm.isActive {
                let request = MKDirectionsRequest()
                request.source = MKMapItem(placemark: MKPlacemark(coordinate: newLocation.coordinate, addressDictionary: nil))
                request.destination = alarm.destination.toMKMapItem()
                
                if alarm.transportation == .Transit {
                    request.transportType = .transit
                } else {
                    request.transportType = .automobile
                }
                
                request.requestsAlternateRoutes = false
                let direction = MKDirections(request: request)
                direction.calculateETA(completionHandler: {
                    (response, err) -> Void in
                    if response == nil {
                        //                        print("Inside didUpdateToLocation: Failed to get routes.")
                        self.tableView.reloadData()
                        return
                    }
                    let minutes = (response?.expectedTravelTime)! / 60.0
                    alarm.setETA(etaMinutes: Int(round(minutes)))
                    //                    print("Inside didUpdateToLocation: \(minutes)")
                    //                    print("The estimated time is: \(alarm.getWakeupString())")
                    AlarmList.sharedInstance.updateAlarm(alarmToUpdate: alarm)
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    func backgroundFetchDone() {
        print("Fetch completion handler called.")
//        locationManager.stopUpdatingLocation()
    }
    
    func fetch(completionHandler: () -> Void) {
        for index in 0 ..< alarms.count {
            let alarm = alarms[index]
            
            if alarm.isActive {
                let request = MKDirectionsRequest()
                let location = locationManager.location
                request.source = MKMapItem(placemark: MKPlacemark(coordinate: (location?.coordinate)!, addressDictionary: nil))
                request.destination = alarm.destination.toMKMapItem()
                
                if alarm.transportation == .Transit {
                    request.transportType = .transit
                } else {
                    request.transportType = .automobile
                }
                
                request.requestsAlternateRoutes = false
                let direction = MKDirections(request: request)
                direction.calculateETA(completionHandler: {
                    (response, err) -> Void in
                    if response == nil {
                        print("Inside fetch: Failed to get routes.")
                        self.tableView.reloadData()
                        return
                    }
                    let minutes = (response?.expectedTravelTime)! / 60.0
                    alarm.setETA(etaMinutes: Int(round(minutes)))
                    print("Inside fetch: \(minutes)")
                    print("The estimated time is: \(alarm.getWakeupString())")
                    AlarmList.sharedInstance.updateAlarm(alarmToUpdate: alarm)
                    self.tableView.reloadData()
                    
                })
            }
        }
        //Call completionHandler
        completionHandler()
    }
    
}
