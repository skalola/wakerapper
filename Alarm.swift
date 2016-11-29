//
//  Alarm.swift
//  wakerapper
//
//  Created by Shiv Kalola on 4/29/16.
//  Copyright © 2016 Nobel Apps. All rights reserved.
//

import Foundation
import MapKit

class Alarm {
    
    /* FIELDS */
    
    private(set) var UUID: String
    private(set) var followupID: String
    private(set) var isActive: Bool
    private(set) var arrival: NSDate
    private(set) var routine: Routine
    private(set) var etaMinutes: Int
    private(set) var transportation: Transportation
    private(set) var destination: Destination
    private(set) var wakeup: NSDate
        
    enum Transportation: String {
        case Automobile = "Automobile"
        case Transit = "Transit"
    }
    
    /* CONSTRUCTORS */
    
    init () {
        self.UUID = NSUUID().uuidString
        self.followupID = NSUUID().uuidString
        self.isActive = true
        self.arrival = NSDate()
        self.routine = Routine()
        self.etaMinutes = 0
        self.transportation = .Automobile
        self.destination = Destination()
        self.wakeup = NSDate()
        self.wakeup = calculateWakeup()
    }
    
    init (UUID: String = NSUUID().uuidString, followupID: String = NSUUID().uuidString, arrival: NSDate, routine: Routine, transportation: Transportation, destination: Destination) {
        self.UUID = UUID
        self.followupID = followupID
        self.isActive = true
        self.arrival = arrival
        self.routine = routine
        self.etaMinutes = 0
        self.transportation = transportation
        self.destination = destination
        self.wakeup = NSDate()
        self.wakeup = calculateWakeup()
    }
    
    init (copiedAlarm: Alarm) {
        self.UUID = copiedAlarm.UUID
        self.followupID = copiedAlarm.followupID
        self.isActive = copiedAlarm.isActive
        self.arrival = copiedAlarm.arrival
        self.routine = copiedAlarm.routine.copy()
        self.etaMinutes = copiedAlarm.etaMinutes
        self.transportation = copiedAlarm.transportation
        self.destination = copiedAlarm.destination.copy()
        self.wakeup = copiedAlarm.wakeup
    }
    
    /* METHODS */
    
    func copy() -> Alarm {
        return Alarm(copiedAlarm: self)
    }
    
    func turnOn () {
        self.isActive = true
    }
    
    func turnOff () {
        self.isActive = false
    }
    
    func getWakeupString () -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        self.wakeup = calculateWakeup()
        
        return dateFormatter.string(from: self.wakeup as Date)
    }
    
    func getBedtimeString () -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        self.wakeup = calculateWakeup()
        
        let getBedtime1 = dateFormatter.string(from: self.wakeup.addingTimeInterval(-9 * 3600) as Date)
        let getBedtime2 = dateFormatter.string(from: self.wakeup.addingTimeInterval(-7.5 * 3600) as Date)
        let getBedtime3 = dateFormatter.string(from: self.wakeup.addingTimeInterval(-6 * 3600) as Date)
        let getBedtime4 = dateFormatter.string(from: self.wakeup.addingTimeInterval(-4.5 * 3600) as Date)
        
        let bedTimes = getBedtime1 + ", " + getBedtime2 + ", " + getBedtime3 + ", " + getBedtime4
        
        return bedTimes
    }
    
    func getTransportString () -> String {
        return (self.transportation.rawValue)
    }
    
    func calculateWakeup() -> NSDate {
        let components: NSDateComponents = NSDateComponents()
        let combinedTime = self.routine.getTotalTime() + self.etaMinutes
        components.setValue(combinedTime*(-1), forComponent: NSCalendar.Unit.minute);
        
        let result = Calendar.current.date(byAdding: components as DateComponents, to: self.arrival as Date)
//        let result = Calendar.current.dateByAddingComponents(components, toDate: self.arrival, options: NSCalendar.Options(rawValue: 0))
        
        return result! as NSDate
    }
    
    
    
    /* ACCESS CONTROL METHODS */
    
    func setUUID (newID: String) {
        self.UUID = newID
    }
    
    func setFollowupID (newID: String) {
        self.followupID = newID
    }
    
    func setArrival (arrival: NSDate) {
        self.arrival = arrival
    }
    
    func setRoutine (routine: Routine) {
        self.routine = routine
    }
    
    func setETA (etaMinutes: Int) {
        self.etaMinutes = etaMinutes
    }
    
    func setTransportation (transportation: Transportation) {
        self.transportation = transportation
    }
    
    func setDestination(mapItem: MKMapItem) {
        self.destination = Destination(mapItem: mapItem)
    }
    
    func setWakeup (wakeup: NSDate) {
        self.wakeup = wakeup
    }
    
    /* SERIALIZATION */
    
    func toDictionary () -> NSDictionary {
        let dict: NSDictionary = [
            "UUID": self.UUID,
            "followupID": self.followupID,
            "isActive": self.isActive,
            "arrival": self.arrival,
            "routine": self.routine.toArray(),
            "etaMinutes": self.etaMinutes,
            "transportation": self.transportation.rawValue,
            "destination": self.destination.toDictionary(),
            "wakeup": self.wakeup
        ]
        return dict
    }
    
    func fromDictionary (dict: NSDictionary) {
        self.UUID = dict.value(forKey: "UUID") as! String
        self.followupID = dict.value(forKey: "followupID") as! String
        self.isActive = dict.value(forKey: "isActive") as! Bool
        self.arrival = dict.value(forKey: "arrival") as! NSDate
        self.routine.fromArray(array: dict.value(forKey: "routine") as! NSArray)
        self.etaMinutes = dict.value(forKey: "etaMinutes") as! Int
        self.transportation = Transportation(rawValue: dict.value(forKey: "transportation") as! String)!
        self.destination.fromDictionary(dict: dict.value(forKey: "destination") as! NSDictionary)
        self.wakeup = dict.value(forKey: "wakeup") as! NSDate
    }
}
