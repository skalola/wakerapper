//
//  Alarm.swift
//  smart-alarm
//
//  Created by Shiv Kalola on 10/26/16.
//  Copyright © 2016 Nobel Apps. All rights reserved.
//

import Foundation

class Alarm {
    private var arrival: NSDate
    private var destination: String
    private var transportation: String
    private var routine: Int
    
    private static var alarms:[Alarm] = []
    
    init () {
        self.arrival = NSDate()
        self.destination = ""
        self.transportation = ""
        self.routine = 0
    } // default constructor
    
    init (arrival: NSDate, destination: String, transportation: String) {
        self.arrival = arrival
        self.destination = destination
        self.transportation = transportation
        self.routine = 0
    }
    
    init (arrival: NSDate, destination: String, transportation: String, routine: Int) {
        self.arrival = arrival
        self.destination = destination
        self.transportation = transportation
        self.routine = routine
    }
    
    static func getAlarms () -> [Alarm] {
        return alarms
    }
    
    static func addAlarm (a: Alarm) {
        alarms.append(a)
    }
    
    static func deleteAlarm (index: Int) {
        alarms.removeAtIndex(index)
    }
    
    static func update (updatedAlarms: [Alarm]) {
        alarms = updatedAlarms
    }

}