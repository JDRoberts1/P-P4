//
//  WatchTimerController.swift
//  GetFocused WatchKit Extension
//
//  Created by Nai Roberts on 5/1/22.
//

import WatchKit
import Foundation
import UserNotifications
import WatchConnectivity
import UIKit
import AVFoundation

class WatchTimerController: WKInterfaceController, WCSessionDelegate {
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    let session = WCSession.default
    var bttnId: String!
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
    var time : Date!
    
    
    @IBOutlet weak var timerLabel: WKInterfaceLabel!
    @IBOutlet weak var timePicker: WKInterfacePicker!
    
    
    
    override func awake(withContext context: Any?) {
        
        session.delegate = self
        
        if let info = context as? [String: TimeInterval]{
            for (key, value) in info {
                bttnId = key
                interval = value
            }
        } else if let info = context as? String{
           bttnId = info
        }
        
       
        
        switch bttnId {
        case "stopwatch":
            hidePicker()
            
        case "newTimer":
            
            displayPicker()
        case "focusSession":
            hidePicker()
            interval = 25 * 60
            
            formatTime()
            timerLabel.setText(timeDisplay)
        case "shortBreak":
            hidePicker()
            interval = 5 * 60
            
            formatTime()
            timerLabel.setText(timeDisplay)
        case "longBreak":
            hidePicker()
            interval = 15 * 60
            
            formatTime()
            timerLabel.setText(timeDisplay)
        case "viewCurrent":
            hidePicker()
            displayTime()
        case "phoneTimer":
            hidePicker()
            startTimer()
        default:
            debugPrint("ERROR: you should not be here")
        }
    }
    
    @IBAction func stopTimer() {
        alerts(alertType: 1)
        
        if timer != nil{
            timer.invalidate()
            
            timer = nil
        }
        
    }
    
    
    
    @IBAction func playTimer() {
        
        debugPrint("start")
        startTimer()
        
    }
    
    @IBAction func pauseTimer() {
        
        if pauseButtonTapped == true{
            timer.invalidate()
            pauseButtonTapped = false
        }
    }
    
    
    // MARK: - Timer Function
    
    @objc func displayTime(){
        
        // Format the time to (HH:MM:SS) before displaying to user
        formatTime()
        
        interval -= 0.1
        
        timerLabel.setText(timeDisplay)
        
        if interval <= 0{
            
            timer.invalidate()
            timer = nil
            
            // Alert user time is complete
            // Alert message is based on button seletion
            alerts(alertType: 1)
            
        }
        
        
    }
    
    
    
    // MARK: Stopwatch Function
    @objc func stopwatchDisplay(){
        
        stopWatchCount += 1.0
        
        interval = stopWatchCount
        
        formatTime()
    }
    
    
    
    // MARK: Helper Methods
    
    func startTimer(){
        
        if pauseButtonTapped == false{
            
            switch bttnId {
            case "stopwatch":
                
                timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(stopwatchDisplay), userInfo: nil, repeats: true)
            case "newTimer":
                hidePicker()
                
                timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(displayTime), userInfo: nil, repeats: true)
            case "focusSession":
                
                timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(displayTime), userInfo: nil, repeats: true)
            case "shortBreak":
                
                timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(displayTime), userInfo: nil, repeats: true)
            case "longBreak":
                
                timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(displayTime), userInfo: nil, repeats: true)
            case "phoneTimer":
                
                timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(displayTime), userInfo: nil, repeats: true)
            default:
                debugPrint("ERROR:")
            }
            
            pauseButtonTapped = true
            
        }
        
    }
    
    func formatTime(){
        
        let timeFormat = DateComponentsFormatter()
        timeFormat.unitsStyle = .abbreviated
        timeFormat.allowedUnits = [.hour, .minute, .second]
        timeFormat.zeroFormattingBehavior = .pad
        
        timeDisplay = timeFormat.string(from: interval)
        
    }
    
    func alerts(alertType: Int){
        
        switch alertType {
        case 1:
            let alertContent = UNMutableNotificationContent()
            
            alertContent.categoryIdentifier = "myCategory"
            
            let category = UNNotificationCategory(identifier: "myCategory", actions: [], intentIdentifiers: [], options: [])
            UNUserNotificationCenter.current().setNotificationCategories([category])
            
            alertContent.title = "Focus Ended"
            alertContent.subtitle = "Focus time complete"
            
            alertContent.sound = .default
            
            let request = UNNotificationRequest(identifier: "endAlert", content: alertContent, trigger: nil)
            UNUserNotificationCenter.current().add(request){ (error) in
                if let error = error{
                    print(error.localizedDescription)
                }
            }
            
        default:
            print("You should not get here")
        }
        
    }
    
    func displayPicker(){
        timePicker.setEnabled(false)
    }
    
    func hidePicker(){
        
        timePicker.setEnabled(true)
    }
    
    
}
