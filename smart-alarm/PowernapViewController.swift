//
//  PowernapViewController.swift
//  wakerapper
//
//  Created by Shiv Kalola on 9/14/16.
//
//

import Foundation
import UIKit
import AVFoundation
import UserNotifications


class PowernapViewController: UIViewController {
    
    var timer = Timer()
    
    var time = 0
    
    var player: AVAudioPlayer?
    
    //Buttons and Labels
    
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet var timerLabel: UILabel!
    
    @IBOutlet weak var clearButton: UIButton!
    
    @IBOutlet weak var option1Button: UIButton!
    
    @IBOutlet weak var option2Button: UIButton!
    
    @IBOutlet weak var option3Button: UIButton!
    
    @IBOutlet weak var option4Button: UIButton!
    
    @IBOutlet weak var option5Button: UIButton!
    
    @IBOutlet weak var screenLabel: UILabel!
    
    @IBOutlet weak var napTypeLabel: UILabel!
    
    @IBOutlet weak var napDescriptionLabel: UILabel!
    
    
    
    //Actions
    func cleanNotifications() {
        let application = UIApplication.shared
        let scheduledNotifications = application.scheduledLocalNotifications!
        for notification in scheduledNotifications {
            if notification.category != "ALARM_CATEGORY" {
                UIApplication.shared.cancelAllLocalNotifications()
            }
            if notification.category != "FOLLOWUP_CATEGORY" {
                UIApplication.shared.cancelAllLocalNotifications()
            }
        }
    }
    
    @IBAction func sleep10(_ sender: AnyObject) {
        time = 660

        
        napTypeLabel.text = "QUICK NAP"
        napDescriptionLabel.text = "A shorter power nap. Best for some quick rest before getting straight back to work."
        napTypeLabel.isHidden = false
        napDescriptionLabel.isHidden = false
        
        cleanNotifications()
        
        let notification = UILocalNotification()
        notification.alertBody = "Time to wake up!"
        notification.fireDate = NSDate(timeIntervalSinceNow: 660) as Date
        notification.soundName = "loud_alarm.caf"

        UIApplication.shared.scheduleLocalNotification(notification)
        
    }
    
    
    @IBAction func sleep20(_ sender: AnyObject) {
        time = 1260
        
        napTypeLabel.text = "POWER NAP"
        napDescriptionLabel.text = "A short rest can be more useful than caffeine. Best for getting straight back to work."
        napTypeLabel.isHidden = false
        napDescriptionLabel.isHidden = false
        
        cleanNotifications()
        
        let notification = UILocalNotification()
        notification.alertBody = "Time to wake up!"
        notification.fireDate = NSDate(timeIntervalSinceNow: 1260) as Date
        notification.soundName = "loud_alarm.caf"

        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    
    @IBAction func sleep25(_ sender: AnyObject) {
        time = 1560
        
        napTypeLabel.text = "NASA NAP"
        napDescriptionLabel.text = "Improves alertness and performance. Best for a day you'll be working after hours."
        napTypeLabel.isHidden = false
        napDescriptionLabel.isHidden = false
        
        cleanNotifications()
        
        let notification = UILocalNotification()
        notification.alertBody = "Time to wake up!"
        notification.fireDate = NSDate(timeIntervalSinceNow: 1560) as Date
        notification.soundName = "loud_alarm.caf"
        
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    
    @IBAction func sleep60(_ sender: AnyObject) {
        time = 3660
        
        napTypeLabel.text = "SLOW-WAVE NAP CYCLE"
        napDescriptionLabel.text = "Helps improve your cognitive memomory to process places, faces and facts. Best before an important meeting."
        napTypeLabel.isHidden = false
        napDescriptionLabel.isHidden = false
        
        cleanNotifications()
        
        let notification = UILocalNotification()
        notification.alertBody = "Time to wake up!"
        notification.fireDate = NSDate(timeIntervalSinceNow: 3660) as Date
        notification.soundName = "loud_alarm.caf"
        
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    
    @IBAction func sleep90(_ sender: AnyObject) {
        time = 5460
        
        napTypeLabel.text = "FULL SLEEP CYCLE"
        napDescriptionLabel.text = "Helps creativity, improves emotional and procedural memory. Best before impending deadlines or a big day ahead."
        napTypeLabel.isHidden = false
        napDescriptionLabel.isHidden = false
        
        cleanNotifications()
        
        let notification = UILocalNotification()
        notification.alertBody = "Time to wake up!"
        notification.fireDate = NSDate(timeIntervalSinceNow: 5460) as Date
        notification.soundName = "loud_alarm.caf"
        
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    
    @IBAction func play(_ sender: AnyObject) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PowernapViewController.increaseTimer), userInfo: nil, repeats: true)
       
        timerLabel.isHidden = false
        playButton.isHidden = true
        pauseButton.isHidden = false
        clearButton.isHidden = true
        option1Button.isHidden = true
        option2Button.isHidden = true
        option3Button.isHidden = true
        option4Button.isHidden = true
        option5Button.isHidden = true
        napTypeLabel.isHidden = true
        napDescriptionLabel.isHidden = true
        screenLabel.isHidden = true
        
//        print("shiv", UIApplication.sharedApplication().scheduledLocalNotifications!.count)
//        print("shiv1", UIApplication.sharedApplication().scheduledLocalNotifications)
    }
    
    @IBAction func pause(_ sender: AnyObject) {
        timer.invalidate()
        playButton.isHidden = false
        pauseButton.isHidden = true
        clearButton.isHidden = false

    }
    

    @IBAction func reset(_ sender: AnyObject) { 
        timer.invalidate()
        
        time = 0
        
        timerLabel.isHidden = true
        clearButton.isHidden = true
        
        option1Button.isHidden = false
        option2Button.isHidden = false
        option3Button.isHidden = false
        option4Button.isHidden = false
        option5Button.isHidden = false
        screenLabel.isHidden = false
        
        cleanNotifications()
        
    }
    
    func playSound() {
        let url = Bundle.main.url(forResource: "loud_alarm", withExtension: "caf")!
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    func increaseTimer() {
        
        time -= 1
        
        timerLabel.text = "\(time/60) min..."
        
        //Set off alarm notification
        if time == 0 {
            timer.invalidate()
            pauseButton.isHidden = false
            playButton.isHidden = true
            clearButton.isHidden = false
            timerLabel.text = "Time's up!"
            
//            playSound()

        }
        
        //Animate Time
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.duration = 0.5
        pulseAnimation.fromValue = 0.5
        pulseAnimation.toValue = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = FLT_MAX
        timerLabel.layer.add(pulseAnimation, forKey: "animateOpacity")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "BGmobile2")
        self.view.insertSubview(backgroundImage, at: 0)
        
        timerLabel.isHidden = true
        pauseButton.isHidden = true
        clearButton.isHidden = true
        napTypeLabel.isHidden = true
        napDescriptionLabel.isHidden = true
        
        increaseTimer()

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
