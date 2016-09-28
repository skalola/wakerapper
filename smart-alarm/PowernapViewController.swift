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


class PowernapViewController: UIViewController {
    
    var timer = NSTimer()
    
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
    @IBAction func sleep10(sender: AnyObject) {
        
        time = 660
        
        napTypeLabel.text = "QUICK NAP"
        napDescriptionLabel.text = "A shorter power nap. Best for some quick rest before getting straight back to work."
        napTypeLabel.hidden = false
        napDescriptionLabel.hidden = false
    }
    
    
    @IBAction func sleep20(sender: AnyObject) {
        
        time = 1260
        
        napTypeLabel.text = "POWER NAP"
        napDescriptionLabel.text = "A short rest can be more useful than caffeine. Best for getting straight back to work."
        napTypeLabel.hidden = false
        napDescriptionLabel.hidden = false
    }
    
    
    @IBAction func sleep25(sender: AnyObject) {
        
        time = 1560
        
        napTypeLabel.text = "NASA NAP"
        napDescriptionLabel.text = "Improves alertness and performance. Best for a day you'll be working after hours."
        napTypeLabel.hidden = false
        napDescriptionLabel.hidden = false
        
    }
    
    
    @IBAction func sleep60(sender: AnyObject) {
        
        time = 3660
        
        napTypeLabel.text = "SLOW-WAVE NAP CYCLE"
        napDescriptionLabel.text = "Helps improve your cognitive memomory to process places, faces and facts. Best before an important meeting."
        napTypeLabel.hidden = false
        napDescriptionLabel.hidden = false
        
    }
    
    
    
    @IBAction func sleep90(sender: AnyObject) {
        
        time = 5460
        
        napTypeLabel.text = "FULL SLEEP CYCLE"
        napDescriptionLabel.text = "Helps creativity, improves emotional and procedural memory. Best before impending deadlines or a big day ahead."
        napTypeLabel.hidden = false
        napDescriptionLabel.hidden = false
    }
    
    
    @IBAction func play(sender: AnyObject) {
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("increaseTimer"), userInfo: nil, repeats: true)
       
            timerLabel.hidden = false
            playButton.hidden = true
            pauseButton.hidden = false
            clearButton.hidden = true
            option1Button.hidden = true
            option2Button.hidden = true
            option3Button.hidden = true
            option4Button.hidden = true
            option5Button.hidden = true
            napTypeLabel.hidden = true
            napDescriptionLabel.hidden = true
            screenLabel.hidden = true
        
    }
    
    @IBAction func pause(sender: AnyObject) {
        
        timer.invalidate()
        playButton.hidden = false
        pauseButton.hidden = true
        clearButton.hidden = false

    }
    
    @IBAction func reset(sender: AnyObject) {
        
        timer.invalidate()
        
        time = 0
        
        timerLabel.hidden = true
        clearButton.hidden = true
        
        option1Button.hidden = false
        option2Button.hidden = false
        option3Button.hidden = false
        option4Button.hidden = false
        option5Button.hidden = false
        screenLabel.hidden = false
        
    }
    
    func playSound() {
        let url = NSBundle.mainBundle().URLForResource("loud_alarm", withExtension: "caf")!
        
        do {
            player = try AVAudioPlayer(contentsOfURL: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error as NSError {
            print(error.description)
        }
    }
    
    func increaseTimer() {
        
        time--
        
        timerLabel.text = "\(time/60) min..."
        
        if time == 0 {
            timer.invalidate()
            pauseButton.hidden = false
            playButton.hidden = true
            clearButton.hidden = false
            timerLabel.text = "Time's up!"
            
            playSound()
        }
        
        //Animate Time
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.duration = 0.5
        pulseAnimation.fromValue = 0.5
        pulseAnimation.toValue = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = FLT_MAX
        timerLabel.layer.addAnimation(pulseAnimation, forKey: "animateOpacity")
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        backgroundImage.image = UIImage(named: "BGmobile2")
        self.view.insertSubview(backgroundImage, atIndex: 0)
        
        timerLabel.hidden = true
        pauseButton.hidden = true
        clearButton.hidden = true
        napTypeLabel.hidden = true
        napDescriptionLabel.hidden = true

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
