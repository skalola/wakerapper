//
//  Routine.swift
//  wakerapper
//
//  Created by Shiv Kalola on 4/27/16.
//  Copyright © 2016 Nobel Apps. All rights reserved.
//

import Foundation

class Routine {
    
    private(set) var activities: [Activity]
    
    /* CONSTRUCTORS */
    
    init () {
        self.activities = []
    }
    
    init (newRoutine: Routine) {
        self.activities = []
        for a in newRoutine.activities {
            self.activities.append(a.copy())
        }
    } // copy constructor
    
    /* METHODS */
    
    func copy() -> Routine {
        return Routine(newRoutine: self)
    }
    
    func addActivity (newActivity: Activity) {
        self.activities.append(newActivity)
    }
    
    func removeActivity (index: Int) {
        self.activities.removeAtIndex(index)
    }
        
    func getTotalTime () -> Int {
        var total = 0
        for a in activities {
            total += a.time
        }
        return total
    }
    
    /* SERIALIZATION */
    
    func toArray () -> NSArray {
        var array = Array<NSDictionary>()
        for activity in self.activities {
            array.append(activity.toDictionary())
        }
        return array
    }
    
    func fromArray (array: NSArray) {
        for data in array {
            let name = data.valueForKey("name") as! String
            let time = data.valueForKey("time") as! Int
            let activity = Activity(name: name, time: time)
            self.addActivity(activity)
        }
    }
}