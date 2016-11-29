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

    let nsDefaults = UserDefaults.standard
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.alarmToggle.addTarget(self, action: #selector(switchPressed(_:)), for: UIControlEvents.valueChanged)
                
        self.alarmToggle.isOn = self.nsDefaults.bool(forKey: "stateChanged:")
        
    }
    
    @IBAction func switchPressed(_ sender: UISwitch) {
        self.nsDefaults.set(self.alarmToggle.isOn, forKey: "stateChanged:")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func stateChanged(switchState: UISwitch) {
        if switchState.isOn {
            alarmTime.textColor = UIColor.white
            alarmDestination.textColor = UIColor.white
            
        } else {
            alarmTime.textColor = UIColor.lightGray
            alarmDestination.textColor = UIColor.lightGray
        }
    }
    
}
