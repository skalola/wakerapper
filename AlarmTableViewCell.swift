//
//  AlarmTableViewCell.swift
//  wakerapper
//
//  Created by Shiv Kalola on 4/26/16.
//  Copyright © 2016 Nobel Apps. All rights reserved.
//

import UIKit

class AlarmTableViewCell: UITableViewCell {
    
    @IBOutlet weak var alarmTime: UILabel!
    @IBOutlet weak var alarmDestination: UILabel!
    @IBOutlet weak var alarmToggle: UISwitch!

    let nsDefaults = NSUserDefaults.standardUserDefaults()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.alarmToggle.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
        self.alarmToggle.on = self.nsDefaults.boolForKey("stateChanged:")

    }
    
    @IBAction func switchPressed(sender: UISwitch) {
        self.nsDefaults.setBool(self.alarmToggle.on, forKey: "stateChanged:")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func stateChanged(switchState: UISwitch) {
        if switchState.on {
            alarmTime.textColor = UIColor.whiteColor()
            alarmDestination.textColor = UIColor.whiteColor()
        } else {
            alarmTime.textColor = UIColor.lightGrayColor()
            alarmDestination.textColor = UIColor.lightGrayColor()
        }
    }
    
    
}
