//
//  Activity.swift
//  wakerapper
//
//  Created by Shiv Kalola on 4/27/16.
//  Copyright © 2016 Nobel Apps. All rights reserved.
//

import Foundation

class Activity {
    private(set) var name: String
    private(set) var time: Int
    
    /* CONSTRUCTORS */
    
    init () {
        name = ""
        time = 0
    }
    
    init (name: String, time: Int) {
        self.name = name
        self.time = time
    }
    
    init (newActivity: Activity) {
        self.name = newActivity.name
        self.time = newActivity.time
    } // copy constructor
    
    /* METHODS */
    
    func copy() -> Activity {
        return Activity(newActivity: self)
    }
    
    /* SERIALIZATION */
    
    func toDictionary () -> NSDictionary {
        let dict: NSDictionary = [
            "name": self.name,
            "time": self.time
        ]
        return dict
    }
}
