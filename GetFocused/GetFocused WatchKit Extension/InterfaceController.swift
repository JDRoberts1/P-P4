//
//  InterfaceController.swift
//  GetFocused WatchKit Extension
//
//  Created by Nai Roberts on 4/24/22.
//

import WatchKit
import Foundation
import UserNotifications
import WatchConnectivity
import UIKit

class InterfaceController: WKInterfaceController, WCSessionDelegate, UNUserNotificationCenterDelegate {
    
    
    let session = WCSession.default
    @IBOutlet weak var showText: WKInterfaceLabel!
    
    
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        
        session.delegate = self
        session.activate()
        
    
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (success, error) in
            if success{
                print("Permission Granted")
                
                //ADDED FOR NOTIFICATIONS
                WKExtension.shared().registerForRemoteNotifications()
                UNUserNotificationCenter.current().delegate = self
                
                
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    //ADDED FOR NOTIFICATIONS
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        //If you need access to the notifiation contents you can use this
        //let content = notification.request.content
        
        // Process notification content
        completionHandler([.banner, .sound])
    }
    
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        let alertContent = UNMutableNotificationContent()
        
        alertContent.categoryIdentifier = "myCategory"
        
        let category = UNNotificationCategory(identifier: "myCategory", actions: [], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        
        if let startAlert = message["startAlert"] as? String{
            
            alertContent.title = "Focus Started"
            alertContent.subtitle = startAlert
            
            alertContent.sound = .default
            
            let request = UNNotificationRequest(identifier: "startAlert", content: alertContent, trigger: nil)
            UNUserNotificationCenter.current().add(request){ (error) in
                if let error = error{
                    print(error.localizedDescription)
                }
            }
            
        }
        
        if let endAlert = message["endAlert"] as? String{
            
            alertContent.title = "Focus Ended"
            alertContent.subtitle = endAlert
            alertContent.sound = .default
            
            let request = UNNotificationRequest(identifier: "endAlert", content: alertContent, trigger: nil)
            UNUserNotificationCenter.current().add(request){ (error) in
                if let error = error{
                    print(error.localizedDescription)
                }
            }
            
        }
        
        if let pauseAlert = message["pauseAlert"] as? String{
            
            alertContent.title = "Focus Interrupted"
            alertContent.subtitle = pauseAlert
            
            alertContent.sound = .default
            
            let request = UNNotificationRequest(identifier: "pauseAlert", content: alertContent, trigger: nil)
            UNUserNotificationCenter.current().add(request){ (error) in
                if let error = error{
                    print(error.localizedDescription)
                }
            }
            
        }
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
}
