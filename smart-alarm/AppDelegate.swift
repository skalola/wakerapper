//
//  AppDelegate.swift
//  smart-alarm
//
//  Created by Shiv Kalola on 9/30/16.
//  Copyright © 2016 Nobel Apps. All rights reserved.
//

import UIKit
import CoreData
import Fabric
import Crashlytics
import AVFoundation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let ALARMS_KEY = "alarmItems"
    let POST_URL = "https://wakerapper.herokuapp.com/user_history_records.json"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        //        /* Fix button tint */
        //        UINavigationBar.appearance().tintAdjustmentMode = UIViewTintAdjustmentMode.Normal
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        UITabBar.appearance().barTintColor = UIColor.clear
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
        
        // Sets background to a blank/empty image
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        // Sets shadow (line below the bar) to a blank image
        UINavigationBar.appearance().shadowImage = UIImage()
        // Sets the translucent background color
        UINavigationBar.appearance().backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        // Set translucent. (Default value is already true, so this can be removed if desired.)
        UINavigationBar.appearance().isTranslucent = true
        
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        /* REGISTER NOTIFICATION ACTIONS */
        
        // AWAKE ACTION
        let awakeAction = UIMutableUserNotificationAction()
        awakeAction.identifier = "AWAKE_ACTION" // the unique identifier for this action
        awakeAction.title = "Ok, I'm up!" // title for the action button
        awakeAction.activationMode = .background // UIUserNotificationActivationMode.Background - don't bring app to foreground
        awakeAction.isAuthenticationRequired = false // don't require unlocking before performing action
        awakeAction.isDestructive = true // display action in red
        
        // ALARM CATEGORY
        let alarmCategory = UIMutableUserNotificationCategory()
        alarmCategory.identifier = "ALARM_CATEGORY"
        alarmCategory.setActions([awakeAction], for: .default)
        alarmCategory.setActions([awakeAction], for: .minimal)
        
        // ARRIVE ACTION
        let arriveAction = UIMutableUserNotificationAction()
        //        arriveAction.identifier = "ARRIVE_ACTION"
        //        arriveAction.title = "Yes! I've arrived."
        //        arriveAction.activationMode = .Background
        //        arriveAction.authenticationRequired = false
        //        arriveAction.destructive = false
        
        // LATE ACTION
        let lateAction = UIMutableUserNotificationAction()
        //        lateAction.identifier = "LATE_ACTION"
        //        lateAction.title = "No, I'm late"
        //        lateAction.activationMode = .Background
        //        lateAction.authenticationRequired = false
        //        lateAction.destructive = true
        
        // FOLLOWUP CATEGORY
        let followupCategory = UIMutableUserNotificationCategory()
        followupCategory.identifier = "FOLLOWUP_CATEGORY"
        followupCategory.setActions([arriveAction, lateAction], for: .default)
        followupCategory.setActions([arriveAction, lateAction], for: .minimal)
        
        // REGISTER NOTIFICATIONS
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: [alarmCategory, followupCategory]))
                
        return true
    }
    
    /* HANDLE NOTIFICATION ACTIONS */
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        switch (identifier!) {
        case "AWAKE_ACTION":
            print("APP DELEGATE: AWAKE_ACTION")
            break
        case "ARRIVE_ACTION":
            print("APP DELEGATE: ARRIVE_ACTION")
            
            // Format NSDate before POST
            let arrivalTime = notification.fireDate!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let formattedArrival = dateFormatter.string(from: arrivalTime)
            
            let dataDictionary: NSDictionary = [
                "uuid": UIDevice.current.identifierForVendor!.uuidString,
                "arrival": formattedArrival,
                "on_time": true
            ]
            
            let http = HTTP()
            let dataJSON = http.toJSON(dict: dataDictionary)
            http.POST(url: POST_URL, requestJSON: dataJSON!, postComplete: { (success: Bool, msg: String) -> () in
                if success {
                    print("HTTP REQUEST SUCCESS")
                    print(msg)
                } else {
                    print("HTTP REQUEST FAILED")
                    print(msg)
                }
            })
            break
        case "LATE_ACTION":
            print("APP DELEGATE: LATE_ACTION")
            
            // Format NSDate before POST
            let arrivalTime = notification.fireDate!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let formattedArrival = dateFormatter.string(from: arrivalTime)
            
            let dataDictionary: NSDictionary = [
                "uuid": UIDevice.current.identifierForVendor!.uuidString,
                "arrival": formattedArrival,
                "on_time": false
            ]
            
            let http = HTTP()
            let dataJSON = http.toJSON(dict: dataDictionary)
            http.POST(url: POST_URL, requestJSON: dataJSON!, postComplete: { (success: Bool, msg: String) -> () in
                if success {
                    print("HTTP REQUEST SUCCESS")
                    print(msg)
                } else {
                    print("HTTP REQUEST FAILED")
                    print(msg)
                }
            })
            break
        default:
            print("ERROR HANDLING NOTIFICATION ACTIONS")
        }
        completionHandler() // per developer documentation, app will terminate if we fail to call this
    }
    
    /* BACKGROUND FETCH */
    
    func application(application: UIApplication, performFetchWithCompletionHandler completionHandler:
        (UIBackgroundFetchResult) -> Void) {
        print("Fetch called.")
        if let navController = window?.rootViewController as! UINavigationController? {
            let viewControllers = navController.viewControllers as [UIViewController]
            for viewController in viewControllers {
                if let atvc = viewController as? AlarmTableViewController {
                    atvc.fetch(completionHandler: {
                        atvc.backgroundFetchDone()
                        completionHandler(.newData)
                    })
                }
            }
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "edu.cs5356.smart_alarm" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "smart_alarm", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
            
        }
        
        return coordinator
    }()
    
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
}

