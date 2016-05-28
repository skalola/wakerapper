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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.alarmToggle.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func stateChanged(switchState: UISwitch) {
        if switchState.on {
            alarmTime.textColor = UIColor(hue: 0.5833, saturation: 0.44, brightness: 0.36, alpha: 1.0)
            alarmDestination.textColor = UIColor(hue: 0.5833, saturation: 0.44, brightness: 0.36, alpha: 1.0)
        } else {
            alarmTime.textColor = UIColor.lightGrayColor()
            alarmDestination.textColor = UIColor.lightGrayColor()
        }
    }
    
    

}
