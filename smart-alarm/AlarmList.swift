//
//  AlarmList.swift
//  wakerapper
//
//  Created by Shiv Kalola on 4/29/16.
//  Copyright © 2016 Nobel Apps. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import AVFoundation

class AlarmList {
    
    private let ALARMS_KEY = "alarmItems"
    
    /* SINGLETON CONSTRUCTOR */
    
    class var sharedInstance: AlarmList {
        struct Static {
            static let instance: AlarmList = AlarmList()
        }
        return Static.instance
    }
    
    /* ALARM FUNCTIONS */
    
    func allAlarms () -> [Alarm] {
        let alarmDictionary = UserDefaults.standard.dictionary(forKey: ALARMS_KEY) ?? Dictionary()
        var alarmItems:[Alarm] = []
        
        for data in alarmDictionary.values {
            let dict = data as! NSDictionary
            let alarm = Alarm()
            alarm.fromDictionary(dict: dict)
            alarmItems.append(alarm)
        }
        return alarmItems
    }
    
    func addAlarm (newAlarm: Alarm) {
        // Create persistent dictionary of data
        var alarmDictionary = UserDefaults.standard.dictionary(forKey: ALARMS_KEY) ?? Dictionary()
        
        // Copy alarm object into persistent data
        alarmDictionary[newAlarm.UUID] = newAlarm.toDictionary()
        
        // Save or overwrite data
        UserDefaults.standard.set(alarmDictionary, forKey: ALARMS_KEY)
        
        // Schedule notifications
        scheduleNotification(alarm: newAlarm, category: "ALARM_CATEGORY")
        scheduleNotification(alarm: newAlarm, category: "FOLLOWUP_CATEGORY")
    }
    
    func removeAlarm (alarmToRemove: Alarm) {
        // Remove alarm notifications
        cancelNotification(alarm: alarmToRemove, category: "ALARM_CATEGORY")
        cancelNotification(alarm: alarmToRemove, category: "FOLLOWUP_CATEGORY")
        
        // Remove alarm from persistent data
        if var alarmDictionary = UserDefaults.standard.dictionary(forKey: ALARMS_KEY) {
            alarmDictionary.removeValue(forKey: alarmToRemove.UUID as String)
            UserDefaults.standard.set(alarmDictionary, forKey: ALARMS_KEY)
        }
    }
    
    func updateAlarm (alarmToUpdate: Alarm) {
        // Remove old alarm
        removeAlarm(alarmToRemove: alarmToUpdate)
        
        // Create new unique IDs
        let newUUID = NSUUID().uuidString
        let newFollowupID = NSUUID().uuidString
        
        // Associate with the alarm by updating IDs
        alarmToUpdate.setUUID(newID: newUUID)
        alarmToUpdate.setFollowupID(newID: newFollowupID)
        
        // Reschedule new alarm
        addAlarm(newAlarm: alarmToUpdate)
        
    }
    
    /* NOTIFICATION FUNCTIONS */
    func scheduleNotification (alarm: Alarm, category: String) {
        let notification = UILocalNotification()
        notification.category = category
        notification.repeatInterval = NSCalendar.Unit.day
        
        switch category {
        case "ALARM_CATEGORY":
            notification.userInfo = ["UUID": alarm.UUID]
            notification.alertBody = "Time to wake up!"
            notification.fireDate = alarm.wakeup as Date
            notification.soundName = "loud_alarm.caf"
            break
        case "FOLLOWUP_CATEGORY":
            notification.userInfo = ["UUID": alarm.followupID]
            notification.alertBody = "Time to wake up soon..."
            notification.fireDate = alarm.wakeup.addingTimeInterval(-5 * 60) as Date
            notification.soundName = UILocalNotificationDefaultSoundName
            break
        default:
            print("ERROR SCHEDULING NOTIFICATION")
            return
        }
        
        // Play sound
//        func playSound() {
//            var player: AVAudioPlayer = AVAudioPlayer()
//            let audioPath = NSBundle.mainBundle().pathForResource("loud_alarm", ofType: "caf")!
//            do {
//                try player = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: audioPath))
//                player.play()
//            } catch {
//            }
//        }
        
        // Vibrate
//        func startVibration() {
//            for _ in 1...20 {
//                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
//                sleep(5)
//            }
//        }
        
        // For debugging purposes
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        let yourtime = dateFormatter.string(from: notification.fireDate!)
//        print("ALARM SCHEDULED FOR :", yourtime)
        
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    func cancelNotification (alarm: Alarm, category: String) {
        var ID: String
        switch category {
        case "ALARM_CATEGORY":
            ID = alarm.UUID
            break
        case "FOLLOWUP_CATEGORY":
            ID = alarm.followupID
            break
        default:
            print("ERROR CANCELLING NOTIFICATION")
            return
        }
        
        for event in UIApplication.shared.scheduledLocalNotifications! {
            let notification = event as UILocalNotification
            if (notification.userInfo!["UUID"] as! String == ID) {
                UIApplication.shared.cancelLocalNotification(notification)
                break
            }
        }
    }
}
