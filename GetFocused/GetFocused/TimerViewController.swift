//
//  TimerViewController.swift
//  RobertsJeanai_GetFocusedWatch
//
//  Created by Nai Roberts on 4/23/22.
//

import Foundation
import UIKit
import AVFoundation
import WatchConnectivity

class TimerViewController: UIViewController, WCSessionDelegate{
    
    // Constants & Variables
    var tag: Int!
    var timer: Timer!
    var stopWatchCount = 0.00
    var savedTime : TimeInterval!
    var pauseButtonTapped = false
    var startTime : String!
    var interval : TimeInterval!
    var timeDisplay : String!
    var player: AVAudioPlayer!
    var songDuration: Double!
    var selectedSongTitle: String!
    var session: WCSession!
    
    // Outlets
    @IBOutlet weak var focusLabel: UILabel!
    @IBOutlet weak var instructLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var startButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        focusLabel.text = "Begin Focus"
        focusLabel.textColor = UIColor.tintColor
        timerLabel.textColor = UIColor.tintColor
        
        
        
        setUpDisplay()
        
        if timeDisplay != nil{
            startTime = timeDisplay
            savedTime = interval
        }
        
        
    }
    
    // MARK: IBAction Methods
    @IBAction func cancelTimer(_ sender: Any) {
        if timer != nil{
            timer.invalidate()
            timer = nil
            stopWatchCount = 0
            
            if startTime != nil{
                timerLabel.text = startTime
                
            }
            else{
                timerLabel.text = "00:00:00"
            }
            
            interval = savedTime
            
        }
        
        startButton.setTitle("Start", for: .normal)
        pauseButtonTapped = false
        
        focusLabel.text = "Begin Focus"
        focusLabel.textColor = UIColor.tintColor
        timerLabel.textColor = UIColor.tintColor
        
        instructLabel.isHidden = true
        
    }
    
    @IBAction func startPauseTimer(_ sender: Any) {
        
        if pauseButtonTapped == false{
            startTimer()
            startButton.setTitle("Pause", for: .normal)
            
            pauseButtonTapped = true
            
            focusLabel.text = "Focusing . . ."
            focusLabel.textColor = UIColor.green
            timerLabel.textColor = UIColor.green
            
            instructLabel.isHidden = true
            
        } else{
            timer.invalidate()
            pauseButtonTapped = false
            startButton.setTitle("Start", for: .normal)
            
            focusLabel.text = "Focus Interrupted"
            focusLabel.textColor = UIColor.red
            timerLabel.textColor = UIColor.red
            
            instructLabel.text = "Press Start to resume"
            instructLabel.isHidden = false
            
            pauseAlertsToWatch()
        }
        
    }
    
    
    
    // MARK: Unwind Method
    @IBAction func unwindToTimer(unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source as! MusicViewController
        
        // Use data from the view controller which initiated the unwind segue
        if let songTitle = sourceViewController.selectedSong{
            selectedSongTitle = songTitle
            let duration : Double = sourceViewController.elapsedTime
            print(duration)
            
            if selectedSongTitle != nil{
                
                // Only play music if music was playing on prev screen
                if sourceViewController.isPlaying == true{
                    if let url = Bundle.main.url(forResource: selectedSongTitle, withExtension: ".mp3"){
                        player = try! AVAudioPlayer(contentsOf: url)
                        player.play()
                        
                    }
                    else{
                        print("doesnt work")
                    }
                }
                
            }
            
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? MusicViewController{
            if selectedSongTitle != nil{
                destination.selectedSong = selectedSongTitle
            }
        }
        
        
    }
    
    // MARK: setUpDisplay Method
    // Set Up timer UI based on tag
    // Check whether Apple watch is supported on current phone
    func setUpDisplay(){
        
        // Switch for Display elements
        // Predetermined intervals should be set for Pomodoro options
        let instructString = "Press Start to begin "
        hidePicker()
        
        switch tag{
        case 0:
            instructLabel.text = instructString + "stopwatch"
        case 1:
            displayPicker()
            instructLabel.text = "Select a duration and " + instructString + "timer"
        case 2:
            instructLabel.text = instructString + "timer"
            interval = 25 * 60
            formatTime()
            timerLabel.text = timeDisplay
            
        case 3:
            instructLabel.text = instructString + "timer"
            interval = 5 * 60
            
            formatTime()
            timerLabel.text = timeDisplay
        case 4:
            instructLabel.text = instructString + "timer"
            interval = 15 * 60
            
            formatTime()
            timerLabel.text = timeDisplay
            
            
        default:
            print("ERROR: You should not be here")
        }
        
        // Apple watch check
        if WCSession.isSupported() {
            session = WCSession.default
            session.delegate = self
            session.activate()
            print("active")
        }
        
    }
    
    
    // MARK: Start timer method
    func startTimer(){
        
        
        if tag == 0{
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(stopwatchDisplay), userInfo: nil, repeats: true)
            
            
        }
        else if tag == 1{
            
            interval = timePicker.countDownDuration
            savedTime = timePicker.countDownDuration
            
            
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerDisplay), userInfo: nil, repeats: true)
            
            
        }
        else if tag <= 4{
            
            hidePicker()
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerDisplay), userInfo: nil, repeats: true)
            
        }
        
        startAlertsToWatch()
        
    }
    
    
    // MARK: - Timer Alert
    func alerts(alertType: Int){
        
        switch alertType {
        case 1:
            let alert = UIAlertController(title: "Timer Complete", message: nil , preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
            
            endAlertsToWatch()
            
        default:
            print("You should not get here")
        }
        
    }
    
    // Alert the user via Watch about the start of timers and stopwatch
    func startAlertsToWatch(){
        
        if tag == 0 {
            if let currentSession = self.session, currentSession.isReachable{
                let data : [String: String] = ["startAlert": "Stopwatch"]
                currentSession.sendMessage(data, replyHandler: nil)
            }
        }
        else{
            if let currentSession = self.session, currentSession.isReachable{
                let data : [String: String] = ["startAlert": "Timer"]
                currentSession.sendMessage(data, replyHandler: nil)
            }
        }
    }
    
    // Send alert message to Watch
    func endAlertsToWatch(){
        
        // Alert user timer is complete
        if let currentSession = self.session, currentSession.isReachable{
            let data : [String: String] = ["endAlert": "Timer Complete"]
            currentSession.sendMessage(data, replyHandler: nil)
        }
    }
    
    func pauseAlertsToWatch(){
        if tag == 0 {
            if let currentSession = self.session, currentSession.isReachable{
                let data : [String: Any] = ["pauseAlert": "Stopwatch"]
                currentSession.sendMessage(data, replyHandler: nil)
            }
        }
        else{
            if let currentSession = self.session, currentSession.isReachable{
                let data : [String: Any] = ["pauseAlert": "Timer"]
                currentSession.sendMessage(data, replyHandler: nil)
            }
        }
    }
    
    
}
