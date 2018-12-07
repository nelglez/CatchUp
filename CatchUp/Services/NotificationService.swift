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
    
    var storedContacts = UserDefaults.standard.object(forKey: "selectedContacts") as! [String:[String]]
    
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
    /*not using this one anymore
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
    */
    
    //date push notification
    func dateRequest(with components: DateComponents, contactName: String, identifier: String) {
        
        let randomNumberZeroToNine = Int(arc4random_uniform(10))
        
        let content = UNMutableNotificationContent()
        content.title = "👋 CatchUp with \(contactName)!"
        switch randomNumberZeroToNine {
            
        case 0:
            content.body = "Now you can be best buddies again"
        case 1:
            content.body = "A little birdy told me they really miss you"
        case 2:
            content.body = "It's time to check back in"
        case 3:
            content.body = "You're a good friend. Go you. Tell this person to get CatchUp too so it's not always you"
        case 4:
            content.body = "Today is the perfect day to get back in touch"
        case 5:
            content.body = "Remember to keep in touch with the people that matter most"
        case 6:
            content.body = "You know what they say: 'A CatchUp message a day keeps the needy friends at bay'"
        case 7:
            content.body = "Have you written a physical letter in a while? Give that a try this time, people like that"
        case 8:
            content.body = "Here's that reminder you set to check in with someone important. Maybe you'll make their day"
        case 9:
            content.body = "Once a good person, always a good person (you are a good person, and probably so is the person you want to be reminded to CatchUp with)"
        default:
            content.body = "Keep in touch"
            
        }
        content.sound = .default
        content.badge = 1
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notification.add(request)
        
    }
    
    //anniversary push notification
    func anniversaryRequest(with components: DateComponents, contactName: String, identifier: String) {
        
        let content = UNMutableNotificationContent()
        content.title = "😍 Anniversary detected!"
        content.body = "Your anniversary with \(contactName) is coming up soon. The date is stored in CatchUp. Don't worry, there's still time to plan something amazing."
        content.sound = .default
        content.badge = 1
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notification.add(request)
        
    }
    
    //birthday push notification
    func birthdayRequest(with components: DateComponents, contactName: String, identifier: String) {
        
        let content = UNMutableNotificationContent()
        content.title = "🎂 It's almost \(contactName)'s birthday!"
        content.body = "Their birthday is stored in CatchUp. Now you can be the first friend to wish them a happy one!"
        content.sound = .default
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




