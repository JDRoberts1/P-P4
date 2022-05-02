//
//  TimerExtension.swift
//  GetFocused
//
//  Created by Nai Roberts on 4/25/22.
//

import UIKit
import Foundation
import WatchConnectivity

extension TimerViewController{
    
    // Req. WCSession Delegate Protocol methods
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let currentSession = self.session, currentSession.isReachable{
            let data : [String: TimeInterval] = ["phoneTimer": interval]
            currentSession.sendMessage(data, replyHandler: nil)
        }
        
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    // MARK: - Timer Function
    
    @objc func timerDisplay(){
        
        // Format the time to (HH:MM:SS) before displaying to user
        formatTime()
        
        interval -= 0.1
        
        timerLabel.text = timeDisplay
        
        if interval <= 0{
            
            timer.invalidate()
            timer = nil
            
            // Alert user time is complete
            // Alert message is based on button seletion
            alerts(alertType: 1)
            displayPicker()
            
        }
        
        
    }
    
    // MARK: Stopwatch Function
    @objc func stopwatchDisplay(){
        
        stopWatchCount += 1.0
        
        interval = stopWatchCount
        
        formatTime()
        
        timerLabel.text = timeDisplay
    }
    
    // MARK: Helper Methods
    
    func formatTime(){
        
        let timeFormat = DateComponentsFormatter()
        timeFormat.unitsStyle = .abbreviated
        timeFormat.allowedUnits = [.hour, .minute, .second]
        timeFormat.zeroFormattingBehavior = .pad
        
        timeDisplay = timeFormat.string(from: interval)
        
    }
    
    func displayPicker(){
        if tag == 1 {
            timePicker.isHidden = false
        }
    }
    
    func hidePicker(){
        timePicker.isHidden = true
    }
    
    // Memory warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
