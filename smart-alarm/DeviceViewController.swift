//
//  DeviceViewController.swift
//  wakerapper
//
//  Created by Shiv Kalola on 11/18/16.
//
//

import UIKit
import MetaWear

class DeviceViewController: UIViewController {
    @IBOutlet weak var deviceStatus: UILabel!
    
    var device: MBLMetaWear!
    
    @IBOutlet weak var buttonObj: UIButton!
    
    @IBAction func lightsOn(_ sender: Any) {
        
        self.device.led?.flashColorAsync(UIColor.red, withIntensity: 1.0, numberOfFlashes: 3)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        //Check Alarms
        // print("shiv23", UIApplication.shared.scheduledLocalNotifications)
        
        //Test connection
        device.addObserver(self, forKeyPath: "state", options: NSKeyValueObservingOptions.new, context: nil)
        device.connectAsync().success { _ in
//            self.device.led?.flashColorAsync(UIColor.green, withIntensity: 1.0, numberOfFlashes: 3)
            NSLog("We are connected")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        device.removeObserver(self, forKeyPath: "state")
        device.led?.flashColorAsync(UIColor.red, withIntensity: 1.0, numberOfFlashes: 3)
        device.disconnectAsync()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        OperationQueue.main.addOperation {
            switch (self.device.state) {
            case .connected:
                self.deviceStatus.text = "Connected";
            case .connecting:
                self.deviceStatus.text = "Connecting";
            case .disconnected:
                self.deviceStatus.text = "Disconnected";
            case .disconnecting:
                self.deviceStatus.text = "Disconnecting";
            case .discovery:
                self.deviceStatus.text = "Discovery";
            }
        }
    }
}
