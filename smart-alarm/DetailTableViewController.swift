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
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = .clearColor()
        
        timePicker.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        
    }
    
    // Style section header
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let title = UILabel()
        title.font = UIFont(name: "Futura", size: 12)!
        title.textColor = UIColor.whiteColor()
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font=title.font
        header.textLabel?.textColor=title.textColor
        header.textLabel?.textAlignment = NSTextAlignment.Center
    }
    
    // Style section footer
    override func tableView(tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        let title = UILabel()
        title.font = UIFont(name: "Futura", size: 12)!
        title.textColor = UIColor.whiteColor()
        title.textAlignment = NSTextAlignment.Center
        
        let footer = view as! UITableViewHeaderFooterView
        footer.textLabel?.font=title.font
        footer.textLabel?.textColor=title.textColor
        footer.textLabel?.textAlignment = NSTextAlignment.Center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "BGmobile2"))
        tableView.contentMode = .ScaleAspectFill
        
        self.clearsSelectionOnViewWillAppear = true
        
        // Fix iOS 9 bug in mildy hacky way...
        timePicker.datePickerMode = .DateAndTime
        timePicker.datePickerMode = .Time
        
        // Data model
        timePicker.setDate(alarm.arrival, animated: true)
        routineLabel.text = "\(alarm.routine.getTotalTime()) minutes"
        locationLabel.text = "\(alarm.destination.name)"
        updateTimeLabels(timePicker)
        
        //Fonts
        routineLabel.font = UIFont(name: "Futura", size: 16)!
        locationLabel.font = UIFont(name: "Futura", size: 16)!

    }
    
    override func viewWillAppear(animated: Bool) {
        if alarm.destination.name == "" {
            self.saveButton.enabled = false
        } else {
            self.saveButton.enabled = true
        }
        if let selected = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRowAtIndexPath(selected, animated: true)
        }
    }
    
    /* FUNCTIONS */
    
    @IBAction func timeChanged(sender: UIDatePicker) {
        updateTimeLabels(sender)
    }

    func updateTimeLabels (sender: UIDatePicker) {
        alarm.setArrival(sender.date)
        alarm.setWakeup(alarm.calculateWakeup())
        travelTime.text = "Your estimated travel time is \(alarm.etaMinutes) minutes."
        routineLabel.text = "\(alarm.routine.getTotalTime()) minutes"
        wakeupLabel.text = alarm.getWakeupString()
        
        bedtimeLabel.text = alarm.getBedtimeString()
    }
    
    /* NAVIGATION */

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Update model and pass routine to destination controller
        if (segue.identifier == "addRoutine") {
            let routineTVC = segue.destinationViewController as! RoutineTableViewController
            routineTVC.routine = self.alarm.routine.copy()
        }
    }
    
    /* UNWIND SEGUES */

    @IBAction func saveLocation (segue:UIStoryboardSegue) {
        let locationVC = segue.sourceViewController as! LocationViewController
        let location = locationVC.searchBar.text!
        if location != "" &&  locationVC.isValidDest {
            locationLabel.text = location
            alarm.setETA(Int(round(locationVC.etaMinutes)))
            alarm.setDestination(locationVC.destination!)
            switch (locationVC.transportationType.selectedSegmentIndex) {
                case 0:
                    alarm.setTransportation(.Automobile)
                    break
                case 1:
                    alarm.setTransportation(.Transit)
                    break
                default:
                    break
            }
            updateTimeLabels(timePicker)
        }
    }
    
    @IBAction func cancelLocation (segue:UIStoryboardSegue) {
        // Do nothing!
    }
    
    @IBAction func saveRoutine (segue:UIStoryboardSegue) {
        let routineTVC = segue.sourceViewController as! RoutineTableViewController
        self.alarm.setRoutine(routineTVC.routine)
        updateTimeLabels(timePicker)
        
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        
    }
    
    @IBAction func cancelRoutine (segue:UIStoryboardSegue) {
        // Do nothing!
    }
}
