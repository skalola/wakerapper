//
//  RoutineTableViewController.swift
//  wakerapper
//
//  Created by Shiv Kalola on 10/17/16.
//  Copyright © 2016 Nobel Apps. All rights reserved.
//

import UIKit

class RoutineTableViewController: UITableViewController {
    
    var routine = Routine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = UIImageView(image: UIImage(named: "BGmobile2"))
        tableView.tableFooterView = UIView()
    }
    
    /* CONFIGURE ROWS AND SECTIONS */
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routine.activities.count
    }
    
    /* CONFIGURE CELL */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath as IndexPath)
        let activities = routine.activities
        let name = activities[indexPath.row].name
        let time = activities[indexPath.row].time
        cell.textLabel!.text = name
        cell.detailTextLabel!.text = "\(time) minutes"
        cell.backgroundColor = .clear
        return cell
    }
    
    /* ENABLE EDITING */
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            routine.removeActivity(index: indexPath.row)
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
        }
    }
    
    /* UNWIND SEGUES */
    
    @IBAction func cancelActivity (segue:UIStoryboardSegue) {
        // Do nothing!
    }
    
    @IBAction func saveActivity (segue:UIStoryboardSegue) {
        let activityTVC = segue.source as! ActivityTableViewController
        if activityTVC.activityName.text != "" && activityTVC.activityTime.text != "" {
            let name = activityTVC.activityName.text!
            let time = activityTVC.activityTime.text!
            let indexPath = NSIndexPath(row: routine.activities.count, section: 0)
            let newActivity = Activity(name: name, time: Int(time)!)
            routine.addActivity(newActivity: newActivity)
            
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [indexPath as IndexPath], with: .fade)
            self.tableView.endUpdates()
        }
    }
    
}
