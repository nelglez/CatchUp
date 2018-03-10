//
//  NotificationService.swift
//  CatchUp
//
//  Created by Ryan Token on 3/4/18.
//  Copyright © 2018 Token Solutions. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationService: NSObject, UNUserNotificationCenterDelegate {
    
    private override init() {}
    static let shared = NotificationService() //this is a singleton apparently. allows for security by not allowing someone to create a new NotificationService object. You have to use the pre-made shared singleton
    
    let notification = UNUserNotificationCenter.current()
    
    func authorize() {
        
        let options: UNAuthorizationOptions = [.alert, .badge, .sound, .carPlay]
        notification.requestAuthorization(options: options) { (granted, error) in
            print(error ?? "No UN authorization error")
            
            guard granted else {
                
                //code if they deny access, add on to this
                print("USER DENIED ACCESS")
                return
                
            }
            self.configure() //below
        }
    }
    
    func configure () {
        
        notification.delegate = self
        
    }
    
    func getAttachment() -> UNNotificationAttachment? {
        
        return nil
        
    }
    
    func removeActiveNotifications(identifier: String) {
        
        notification.removePendingNotificationRequests(withIdentifiers: [identifier])
        
    }
    
    //TimeInterval is just a double
    //timer push notification
    func timerRequest(with interval: TimeInterval, contactName: String, identifier: String) {
        
        let content = UNMutableNotificationContent()
        content.title = "👋 Time to CatchUp with \(contactName)!"
        content.body = "Now you can be best buddies again"
        content.sound = .default()
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notification.add(request)
        
    }
    
    //date push notification
    func dateRequest(with components: DateComponents, contactName: String, identifier: String) {
        
        let content = UNMutableNotificationContent()
        content.title = "👋 Time to CatchUp with \(contactName)!"
        content.body = "Now you can be best buddies again"
        content.sound = .default()
        content.badge = 1
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notification.add(request)
        
    }
    
    //anniversary push notification
    func anniversaryRequest(with components: DateComponents, contactName: String, identifier: String) {
        
        let content = UNMutableNotificationContent()
        content.title = "😍 Your anniversary with \(contactName) is coming up soon!"
        content.body = "The specific date is stored in CatchUp. Don't worry, there's still time to plan something amazing."
        content.sound = .default()
        content.badge = 1
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notification.add(request)
        
    }
    
    //birthday push notification
    func birthdayRequest(with components: DateComponents, contactName: String, identifier: String) {
        
        let content = UNMutableNotificationContent()
        content.title = "🎂 \(contactName)'s birthday is almost here!"
        content.body = "The specific date is stored in CatchUp. Now you can be the first friend to wish them a happy one!"
        content.sound = .default()
        content.badge = 1
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notification.add(request)
        
    }
    
    /*
     func locationRequest() {
     
     
     
     }
     */
    
    //responds when user interacts with notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("UN did receive response")
        
        completionHandler()
        
    }
    
    //responds immediately if app is in the foreground when notification comes in
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("UN will present in foreground")
        
        let options: UNNotificationPresentationOptions = [.alert, .sound]
        completionHandler(options)
        
    }
 
}




