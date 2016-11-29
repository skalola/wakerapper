//
//  DetailTableViewController.swift
//  wakerapper
//
//  Created by Shiv Kalola on 10/16/16.
//  Copyright © 2016 Nobel Apps. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {

    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var routineLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var travelTime: UILabel!
    @IBOutlet weak var wakeupLabel: UILabel!
    @IBOutlet weak var bedtimeLabel: UILabel!
    
    var alarm = Alarm()
    
    // Style cells
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        
        timePicker.setValue(UIColor.white, forKeyPath: "textColor")
    }
    
    // Style section header
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let title = UILabel()
        title.font = UIFont(name: "Futura", size: 12)!
        title.textColor = UIColor.white
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font=title.font
        header.textLabel?.textColor=title.textColor
        header.textLabel?.textAlignment = NSTextAlignment.center
    }
    
    // Style section footer
    override func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let title = UILabel()
        title.font = UIFont(name: "Futura", size: 12)!
        title.textColor = UIColor.white
        title.textAlignment = NSTextAlignment.center
        
        let footer = view as! UITableViewHeaderFooterView
        footer.textLabel?.font=title.font
        footer.textLabel?.textColor=title.textColor
        footer.textLabel?.textAlignment = NSTextAlignment.center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "BGmobile2"))
        tableView.contentMode = .scaleAspectFill
        
        self.clearsSelectionOnViewWillAppear = true
        
        // Fix iOS 9 bug in mildy hacky way...
        timePicker.datePickerMode = .dateAndTime
        timePicker.datePickerMode = .time
        
        // Data model
        timePicker.setDate(alarm.arrival as Date, animated: true)
        routineLabel.text = "\(alarm.routine.getTotalTime()) minutes"
        locationLabel.text = "\(alarm.destination.name)"
        updateTimeLabels(sender: timePicker)
        
        //Fonts
        routineLabel.font = UIFont(name: "Futura", size: 16)!
        locationLabel.font = UIFont(name: "Futura", size: 16)!

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if alarm.destination.name == "" {
            self.saveButton.isEnabled = false
        } else {
            self.saveButton.isEnabled = true
        }
        if let selected = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selected, animated: true)
        }
    }
    
    /* FUNCTIONS */
    
    @IBAction func timeChanged(_ sender: UIDatePicker) {
        updateTimeLabels(sender: sender)
    }

    func updateTimeLabels (sender: UIDatePicker) {
        alarm.setArrival(arrival: sender.date as NSDate)
        alarm.setWakeup(wakeup: alarm.calculateWakeup())
        travelTime.text = "Your estimated travel time is \(alarm.etaMinutes) minutes."
        routineLabel.text = "\(alarm.routine.getTotalTime()) minutes"
        wakeupLabel.text = alarm.getWakeupString()
        
        bedtimeLabel.text = alarm.getBedtimeString()
    }
    
    /* NAVIGATION */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "addRoutine") {
            let routineTVC = segue.destination as! RoutineTableViewController
            routineTVC.routine = self.alarm.routine.copy()
        }
    }
    
    /* UNWIND SEGUES */

    @IBAction func saveLocation(segue: UIStoryboardSegue) {
        let locationVC = segue.source as! LocationViewController
        let location = locationVC.searchBar.text!
        if location != "" &&  locationVC.isValidDest {
            locationLabel.text = location
            alarm.setETA(etaMinutes: Int(round(locationVC.etaMinutes)))
            alarm.setDestination(mapItem: locationVC.destination!)
            switch (locationVC.transportationType.selectedSegmentIndex) {
                case 0:
                    alarm.setTransportation(transportation: .Automobile)
                    break
                case 1:
                    alarm.setTransportation(transportation: .Transit)
                    break
                default:
                    break
            }
            updateTimeLabels(sender: timePicker)
        }
    }
    


    @IBAction func cancelLocation(segue: UIStoryboardSegue) {
        // Do nothing!
    }
    
    @IBAction func saveRoutine(segue: UIStoryboardSegue) {
        let routineTVC = segue.source as! RoutineTableViewController
        self.alarm.setRoutine(routine: routineTVC.routine)
        updateTimeLabels(sender: timePicker)
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
    }
    
    @IBAction func cancelRoutine(segue: UIStoryboardSegue) {
        // Do nothing!
    }
}
