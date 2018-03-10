//
//  ReminderViewController.swift
//  CatchUp
//
//  Created by Ryan Token on 2/12/18.
//  Copyright © 2018 Token Solutions. All rights reserved.
//

import UIKit

class ReminderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var activeFriend = 0
    
    var feedbackGenerator : UISelectionFeedbackGenerator? = nil
    
    var dateString: String = ""
    
    var primaryPhone: String = ""
    var secondaryPhone: String = ""
    var primaryEmail: String = ""
    var secondaryEmail: String = ""
    var primaryAddress: String = ""
    var secondaryAddress: String = ""
    var birthday: String = ""
    var anniversary: String = ""
    var contactPicture: String = ""
    
    //set who we have stored
    var storedContacts = UserDefaults.standard.object(forKey: "selectedContacts") as! [String:[String]]
    
    @IBOutlet weak var preferenceTable: UITableView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "reminderCell")
        
        let key = storedContacts.index(storedContacts.startIndex, offsetBy: activeFriend)
        
        if indexPath.row == 0 {
            
            cell.textLabel?.text = "Every Day"
            
        } else if indexPath.row == 1 {
            
            cell.textLabel?.text = "Every Week"
            
        } else if indexPath.row == 2 {
            
            cell.textLabel?.text = "Every Month"
            
        } else if indexPath.row == 3 {
            
            cell.textLabel?.text = "Every Six Months"
            
        } else if indexPath.row == 4 {
            
            cell.textLabel?.text = "Every Year"
            
        } else if indexPath.row == 5 {
            
            cell.textLabel?.text = "Custom Reminder"
            
        }
        
        if storedContacts[key].value[8] == "Every Day" && indexPath.row == 0 {
            
            datePicker.isHidden = true
            cell.accessoryType = .checkmark
            
        } else if storedContacts[key].value[8] == "Every Week" && indexPath.row == 1 {
            
            datePicker.isHidden = true
            cell.accessoryType = .checkmark
            
        } else if storedContacts[key].value[8] == "Every Month" && indexPath.row == 2 {
            
            datePicker.isHidden = true
            cell.accessoryType = .checkmark
            
        } else if storedContacts[key].value[8] == "Every Six Months" && indexPath.row == 3 {
            
            datePicker.isHidden = true
            cell.accessoryType = .checkmark
            
        } else if storedContacts[key].value[8] == "Every Year" && indexPath.row == 4 {
            
            datePicker.isHidden = true
            cell.accessoryType = .checkmark
            
        } else if storedContacts[key].value[8] == "Custom" && indexPath.row == 5 {
            
            datePicker.isHidden = false
            cell.accessoryType = .checkmark
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            
            let key = storedContacts.index(storedContacts.startIndex, offsetBy: activeFriend)
            
            if cell.accessoryType == .checkmark {
                
                cell.accessoryType = .none
                
            } else {
                
                uncheckAllCells()
                cell.accessoryType = .checkmark
                
            }
            
            //removes any set reminders for this person, then sets the appropriate reminder
            if indexPath.row == 0 && cell.accessoryType == .checkmark {
                
                // Trigger selection feedback.
                feedbackGenerator?.selectionChanged()
                
                // Keep the generator in a prepared state.
                feedbackGenerator?.prepare()
                
                datePicker.isHidden = true
                
                dateString = "1"
                
                NotificationService.shared.notification.removePendingNotificationRequests(withIdentifiers: [storedContacts[key].value[10]])
                
                let notificationIdentifier = randomString(length: 60)
                
                storedContacts.updateValue([primaryPhone, secondaryPhone, primaryEmail, secondaryEmail, primaryAddress, secondaryAddress, birthday, anniversary, "Every Day", dateString, notificationIdentifier, contactPicture], forKey: storedContacts[key].key)
                
                var components = DateComponents()
                components.hour = 18 //every day at 6:00pm
                
                //timerRequest(with: 86400, contactName: storedContacts[key].key, identifier: storedContacts[key].value[10])
                NotificationService.shared.dateRequest(with: components, contactName: storedContacts[key].key, identifier: storedContacts[key].value[10])
                
                
                UserDefaults.standard.set(storedContacts, forKey: "selectedContacts")
                
                print(storedContacts[key].value[8])
                
                //removes the reminder that was set before and updates the dictionary
            } else if indexPath.row == 0 && cell.accessoryType == .none {
                
                datePicker.isHidden = true
                
                dateString = ""
                
                NotificationService.shared.notification.removePendingNotificationRequests(withIdentifiers: [storedContacts[key].value[10]])
                
                let notificationIdentifier = ""
                
                storedContacts.updateValue([primaryPhone, secondaryPhone, primaryEmail, secondaryEmail, primaryAddress, secondaryAddress, birthday, anniversary, "No Reminder Set", dateString, notificationIdentifier, contactPicture], forKey: storedContacts[key].key)
                
                UserDefaults.standard.set(storedContacts, forKey: "selectedContacts")
                
                print(storedContacts[key].value[8])
                
            } else if indexPath.row == 1 && cell.accessoryType == .checkmark {
                
                // Trigger selection feedback.
                feedbackGenerator?.selectionChanged()
                
                // Keep the generator in a prepared state.
                feedbackGenerator?.prepare()
                
                datePicker.isHidden = true
                
                dateString = "7"
                
                NotificationService.shared.notification.removePendingNotificationRequests(withIdentifiers: [storedContacts[key].value[10]])
                
                let notificationIdentifier = randomString(length: 60)
                
                storedContacts.updateValue([primaryPhone, secondaryPhone, primaryEmail, secondaryEmail, primaryAddress, secondaryAddress, birthday, anniversary, "Every Week", dateString, notificationIdentifier, contactPicture], forKey: storedContacts[key].key)
                
                var components = DateComponents()
                components.weekday = Date().dayNumberOfWeek() //every week at the day the reminder is set
                components.hour = 14 //2:00pm
                
                //timerRequest(with: 604800, contactName: storedContacts[key].key, identifier: storedContacts[key].value[10])
                NotificationService.shared.dateRequest(with: components, contactName: storedContacts[key].key, identifier: storedContacts[key].value[10])
                
                UserDefaults.standard.set(storedContacts, forKey: "selectedContacts")
                
                print(storedContacts[key].value[8])
                
            } else if indexPath.row == 1 && cell.accessoryType == .none {
                
                datePicker.isHidden = true
                
                dateString = ""
                
                NotificationService.shared.notification.removePendingNotificationRequests(withIdentifiers: [storedContacts[key].value[10]])
                
                let notificationIdentifier = ""
                
                storedContacts.updateValue([primaryPhone, secondaryPhone, primaryEmail, secondaryEmail, primaryAddress, secondaryAddress, birthday, anniversary, "No Reminder Set", dateString, notificationIdentifier, contactPicture], forKey: storedContacts[key].key)
                
                UserDefaults.standard.set(storedContacts, forKey: "selectedContacts")
                
                print(storedContacts[key].value[8])
                
            } else if indexPath.row == 2 && cell.accessoryType == .checkmark {
                
                // Trigger selection feedback.
                feedbackGenerator?.selectionChanged()
                
                // Keep the generator in a prepared state.
                feedbackGenerator?.prepare()
                
                datePicker.isHidden = true
                
                dateString = "30"
                
                NotificationService.shared.notification.removePendingNotificationRequests(withIdentifiers: [storedContacts[key].value[10]])
                
                let notificationIdentifier = randomString(length: 60)
                
                storedContacts.updateValue([primaryPhone, secondaryPhone, primaryEmail, secondaryEmail, primaryAddress, secondaryAddress, birthday, anniversary, "Every Month", dateString, notificationIdentifier, contactPicture], forKey: storedContacts[key].key)
                
                var components = DateComponents()
                components.day = Date().dayOfMonth()  //specific day of the month every month
                components.hour = 16 //4:00pm
                
                //timerRequest(with: 2629746, contactName: storedContacts[key].key, identifier: storedContacts[key].value[10])
                NotificationService.shared.dateRequest(with: components, contactName: storedContacts[key].key, identifier: storedContacts[key].value[10])
                
                UserDefaults.standard.set(storedContacts, forKey: "selectedContacts")
                
                print(storedContacts[key].value[8])
                
            } else if indexPath.row == 2 && cell.accessoryType == .none {
                
                datePicker.isHidden = true
                
                dateString = ""
                
                NotificationService.shared.notification.removePendingNotificationRequests(withIdentifiers: [storedContacts[key].value[10]])
                
                let notificationIdentifier = ""
                
                storedContacts.updateValue([primaryPhone, secondaryPhone, primaryEmail, secondaryEmail, primaryAddress, secondaryAddress, birthday, anniversary, "No Reminder Set", dateString, notificationIdentifier, contactPicture], forKey: storedContacts[key].key)
                
                UserDefaults.standard.set(storedContacts, forKey: "selectedContacts")
                
                print(storedContacts[key].value[8])
                
            } else if indexPath.row == 3 && cell.accessoryType == .checkmark {
                
                // Trigger selection feedback.
                feedbackGenerator?.selectionChanged()
                
                // Keep the generator in a prepared state.
                feedbackGenerator?.prepare()
                
                datePicker.isHidden = true
                
                dateString = "180"
                
                NotificationService.shared.notification.removePendingNotificationRequests(withIdentifiers: [storedContacts[key].value[10]])
                
                let notificationIdentifier = randomString(length: 60)
                
                storedContacts.updateValue([primaryPhone, secondaryPhone, primaryEmail, secondaryEmail, primaryAddress, secondaryAddress, birthday, anniversary, "Every Six Months", dateString, notificationIdentifier, contactPicture], forKey: storedContacts[key].key)
                
                let weekOfYear = Calendar.current.component(.weekOfYear, from: Date.init(timeIntervalSinceNow: 0))
                
                var components = DateComponents()
                //reminds every six months. Has to account for the year only having 52 weeks, so if it's above the 26th week (halfway through the year), subtract 26 weeks instead of adding
                if weekOfYear > 26 {
                    
                    components.weekOfYear = weekOfYear-26
                    
                } else {
                    
                    components.weekOfYear = weekOfYear+26
                    
                }
                
                components.weekday = Date().dayNumberOfWeek()
                components.hour = 10 //10:00am
                
                //timerRequest(with: 15778476, contactName: storedContacts[key].key, identifier: storedContacts[key].value[10])
                NotificationService.shared.dateRequest(with: components, contactName: storedContacts[key].key, identifier: storedContacts[key].value[10])
                
                UserDefaults.standard.set(storedContacts, forKey: "selectedContacts")
                
                print(storedContacts[key].value[8])
                
            } else if indexPath.row == 3 && cell.accessoryType == .none {
                
                datePicker.isHidden = true
                
                dateString = ""
                
                NotificationService.shared.notification.removePendingNotificationRequests(withIdentifiers: [storedContacts[key].value[10]])
                
                let notificationIdentifier = ""
                
                storedContacts.updateValue([primaryPhone, secondaryPhone, primaryEmail, secondaryEmail, primaryAddress, secondaryAddress, birthday, anniversary, "No Reminder Set", dateString, notificationIdentifier, contactPicture], forKey: storedContacts[key].key)
                
                UserDefaults.standard.set(storedContacts, forKey: "selectedContacts")
                
                print(storedContacts[key].value[8])
                
            } else if indexPath.row == 4 && cell.accessoryType == .checkmark {
                
                // Trigger selection feedback.
                feedbackGenerator?.selectionChanged()
                
                // Keep the generator in a prepared state.
                feedbackGenerator?.prepare()
                
                datePicker.isHidden = true
                
                dateString = "365"
                
                NotificationService.shared.notification.removePendingNotificationRequests(withIdentifiers: [storedContacts[key].value[10]])
                
                let notificationIdentifier = randomString(length: 60)
                
                storedContacts.updateValue([primaryPhone, secondaryPhone, primaryEmail, secondaryEmail, primaryAddress, secondaryAddress, birthday, anniversary, "Every Year", dateString, notificationIdentifier, contactPicture], forKey: storedContacts[key].key)
                
                let weekOfYear = Calendar.current.component(.weekOfYear, from: Date.init(timeIntervalSinceNow: 0))
                print(weekOfYear)
                
                var components = DateComponents()
                components.weekOfYear = weekOfYear
                components.weekday = Date().dayNumberOfWeek()
                components.hour = 13 //1:00pm
                
                //timerRequest(with: 31556952, contactName: storedContacts[key].key, identifier: storedContacts[key].value[10])
                NotificationService.shared.dateRequest(with: components, contactName: storedContacts[key].key, identifier: storedContacts[key].value[10])
                
                UserDefaults.standard.set(storedContacts, forKey: "selectedContacts")
                
                print(storedContacts[key].value[8])
                
            } else if indexPath.row == 4 && cell.accessoryType == .none {
                
                datePicker.isHidden = true
                
                dateString = ""
                
                NotificationService.shared.notification.removePendingNotificationRequests(withIdentifiers: [storedContacts[key].value[10]])
                
                let notificationIdentifier = ""
                
                storedContacts.updateValue([primaryPhone, secondaryPhone, primaryEmail, secondaryEmail, primaryAddress, secondaryAddress, birthday, anniversary, "", dateString, notificationIdentifier, contactPicture], forKey: storedContacts[key].key)
                
                UserDefaults.standard.set(storedContacts, forKey: "selectedContacts")
                
                print(storedContacts[key].value[8])
                
                //not working either
            } else if indexPath.row == 5 && cell.accessoryType == .checkmark {
                
                // Trigger selection feedback.
                feedbackGenerator?.selectionChanged()
                
                // Keep the generator in a prepared state.
                feedbackGenerator?.prepare()
                
                datePicker.isHidden = false
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yy"
                dateString = dateFormatter.string(from: datePicker.date)
                
                NotificationService.shared.notification.removePendingNotificationRequests(withIdentifiers: [storedContacts[key].value[10]])
                
                let notificationIdentifier = randomString(length: 60)
                
                let key = storedContacts.index(storedContacts.startIndex, offsetBy: activeFriend)
                
                storedContacts.updateValue([primaryPhone, secondaryPhone, primaryEmail, secondaryEmail, primaryAddress, secondaryAddress, birthday, anniversary, "Custom", dateString, notificationIdentifier, contactPicture], forKey: storedContacts[key].key)
                
                let startIndex = dateString.index(dateString.startIndex, offsetBy: 2)
                let substringMonth = dateString.prefix(upTo: startIndex)
                let stringMonth = String(substringMonth) //convert substring to string so it lets go of substring memory
                let month = Int(stringMonth) //convert string to int so we can use it in our date components call for dateRequest()
                
                let start = dateString.index(dateString.startIndex, offsetBy: 3)
                let end = dateString.index(dateString.endIndex, offsetBy: -3)
                let range = start..<end
                let substringDay = dateString[range]
                let stringDay = String(substringDay) //convert substring to string so it lets go of substring memory
                let day = Int(stringDay) //convert string to int so we can use it in our date components call for dateRequest()
                
                let endIndex = dateString.index(dateString.endIndex, offsetBy: -2)
                let substringYear = dateString.suffix(from: endIndex)
                let stringYear = String(substringYear) //convert substring to string so it lets go of substring memory
                let year = Int(stringYear) //convert string to int so we can use it in our date components call for dateRequest()
                
                let year2000 = "20"
                let twoThousandAnd = Int(year2000)
                let stringFullYear = "\(twoThousandAnd ?? 20)\(year ?? 99)"
                let fullYear = Int(stringFullYear)
                
                print(month!, "/", day!, "/", fullYear!)
                
                var components = DateComponents()
                components.month = month
                components.day = day
                components.year = fullYear
                components.hour = 9 //9:00am on the chosen day
                
                NotificationService.shared.dateRequest(with: components, contactName: storedContacts[key].key, identifier: storedContacts[key].value[10])
                
                UserDefaults.standard.set(storedContacts, forKey: "selectedContacts")
                print(storedContacts[key].value[8])
                
            } else if indexPath.row == 5 && cell.accessoryType == .none {
                
                datePicker.isHidden = true
                
                dateString = ""
                
                NotificationService.shared.notification.removePendingNotificationRequests(withIdentifiers: [storedContacts[key].value[10]])
                
                let notificationIdentifier = ""
                
                storedContacts.updateValue([primaryPhone, secondaryPhone, primaryEmail, secondaryEmail, primaryAddress, secondaryAddress, birthday, anniversary, "No Reminder Set", dateString, notificationIdentifier, contactPicture], forKey: storedContacts[key].key)
                
                UserDefaults.standard.set(storedContacts, forKey: "selectedContacts")
                
                print(storedContacts[key].value[8])
                
            }
            
        }
        
    }
    
    @IBAction func pickerMoved(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        dateString = dateFormatter.string(from: datePicker.date)
        
        let key = storedContacts.index(storedContacts.startIndex, offsetBy: activeFriend)
        
        NotificationService.shared.notification.removePendingNotificationRequests(withIdentifiers: [storedContacts[key].value[10]])
        
        let notificationIdentifier = randomString(length: 60)
        
        storedContacts.updateValue([primaryPhone, secondaryPhone, primaryEmail, secondaryEmail, primaryAddress, secondaryAddress, birthday, anniversary, "Custom", dateString, notificationIdentifier, contactPicture], forKey: storedContacts[key].key)
        
        let startIndex = dateString.index(dateString.startIndex, offsetBy: 2)
        let substringMonth = dateString.prefix(upTo: startIndex)
        let stringMonth = String(substringMonth) //convert substring to string so it lets go of substring memory
        let month = Int(stringMonth) //convert string to int so we can use it in our date components call for dateRequest()
        
        let start = dateString.index(dateString.startIndex, offsetBy: 3)
        let end = dateString.index(dateString.endIndex, offsetBy: -3)
        let range = start..<end
        let substringDay = dateString[range]
        let stringDay = String(substringDay) //convert substring to string so it lets go of substring memory
        let day = Int(stringDay) //convert string to int so we can use it in our date components call for dateRequest()
        
        let endIndex = dateString.index(dateString.endIndex, offsetBy: -2)
        let substringYear = dateString.suffix(from: endIndex)
        let stringYear = String(substringYear) //convert substring to string so it lets go of substring memory
        let year = Int(stringYear) //convert string to int so we can use it in our date components call for dateRequest()
        
        let year2000 = "20"
        let twoThousandAnd = Int(year2000)
        let stringFullYear = "\(twoThousandAnd ?? 20)\(year ?? 99)"
        let fullYear = Int(stringFullYear)
        
        print(month!, "/", day!, "/", fullYear!)
        
        var components = DateComponents()
        components.month = month
        components.day = day
        components.year = fullYear
        
        NotificationService.shared.dateRequest(with: components, contactName: storedContacts[key].key, identifier: storedContacts[key].value[10])
        
        UserDefaults.standard.set(storedContacts, forKey: "selectedContacts")
        print(storedContacts[key].value[9])
        
    }
    
   
    func uncheckAllCells() {
        
        for cell in preferenceTable.visibleCells {
            
            cell.accessoryType = .none
            
        }
        
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationService.shared.authorize()
        
        //REMOVES ALL PENDING NOTIFICATIONS
        //NotificationService.shared.notification.removeAllPendingNotificationRequests()
        
        let key = storedContacts.index(storedContacts.startIndex, offsetBy: activeFriend)
        
        //if there is a stored anniversary in the dictionary, set a reminder for their anniversary. Anniversary is stored just as MM-DD, no year
        if storedContacts[key].value[7] != "" {
            
            let anniversaryString = storedContacts[key].value[7]
            
            let notificationIdentifier = storedContacts[key].value[7]
            
            let startIndex = anniversaryString.index(anniversaryString.startIndex, offsetBy: 2)
            let substringMonth = anniversaryString.prefix(upTo: startIndex)
            let stringMonth = String(substringMonth) //convert substring to string so it lets go of substring memory
            let month = Int(stringMonth) //convert string to int so we can use it in our date components call for dateRequest()
            
            let endIndex = anniversaryString.index(anniversaryString.endIndex, offsetBy: -2)
            let substringDay = anniversaryString.suffix(from: endIndex)
            let stringDay = String(substringDay) //convert substring to string so it lets go of substring memory
            let day = Int(stringDay) //convert string to int so we can use it in our date components call for dateRequest()
            
            var components = DateComponents()
            if month == 1 && day == 1 { //remind on the day before anniversary or birthday. had to account for days on the 1st, and for january 1st
                
                components.month = 12
                components.day = 31
                components.hour = 10
                
            } else if day == 1 {
                
                components.month = month! - 1
                components.day = 28
                components.hour = 10
                
            } else {
                
                components.month = month
                components.day = day! - 1 //to get the day before
                components.hour = 10 //10:00am
                
            }
            
            NotificationService.shared.anniversaryRequest(with: components, contactName: storedContacts[key].key, identifier: notificationIdentifier)
            
        }
        
        //if there is a stored birthday in the dictionary, set a reminder for their birthday. Birthday is stored just as MM-DD, no year
        if storedContacts[key].value[6] != "" {
            
            let birthdayString = storedContacts[key].value[6]
            
            let notificationIdentifier = storedContacts[key].value[6]
            
            let startIndex = birthdayString.index(birthdayString.startIndex, offsetBy: 2)
            let substringMonth = birthdayString.prefix(upTo: startIndex)
            let stringMonth = String(substringMonth) //convert substring to string so it lets go of substring memory
            let month = Int(stringMonth) //convert string to int so we can use it in our date components call for dateRequest()
            
            let endIndex = birthdayString.index(birthdayString.endIndex, offsetBy: -2)
            let substringDay = birthdayString.suffix(from: endIndex)
            let stringDay = String(substringDay) //convert substring to string so it lets go of substring memory
            let day = Int(stringDay) //convert string to int so we can use it in our date components call for dateRequest()
            
            var components = DateComponents()
            if month == 1 && day == 1 { //remind on the day before anniversary or birthday. had to account for days on the 1st, and for january 1st
                
                components.month = 12
                components.day = 31
                components.hour = 10
                
            } else if day == 1 {
                
                components.month = month! - 1
                components.day = 28
                components.hour = 10
                
            } else {
                
                components.month = month
                components.day = day! - 1 //to get the day before
                components.hour = 10 //10:00am
                
            }
            
            NotificationService.shared.birthdayRequest(with: components, contactName: storedContacts[key].key, identifier: notificationIdentifier)
            
        }
        
        primaryPhone = storedContacts[key].value[0]
        secondaryPhone = storedContacts[key].value[1]
        primaryEmail = storedContacts[key].value[2]
        secondaryEmail = storedContacts[key].value[3]
        primaryAddress = storedContacts[key].value[4]
        secondaryAddress = storedContacts[key].value[5]
        birthday = storedContacts[key].value[6]
        anniversary = storedContacts[key].value[7]
        contactPicture = storedContacts[key].value[11]
        
        let components = DateComponents()
        let minDate = Calendar.current.date(byAdding: components, to: Date())
        datePicker.minimumDate = minDate
        
        if storedContacts[key].value[9] != "" {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy" //Your date format
            dateFormatter.timeZone = TimeZone(abbreviation: "CST+0:00") //Current time zone
            let setDate = dateFormatter.date(from: storedContacts[key].value[9]) //according to date format your date string
            
            datePicker.date = setDate ?? minDate!
            
        } else {
            
            datePicker.date = minDate!
            
        }
        
        //print(storedContacts[index].key)
        print(storedContacts[key].value[0])
        print(storedContacts[key].value[8]) //reminderType
            
        print(storedContacts[key].value[9]) //reminderPreference
        
        //set Save button to size 20 semibold
        //saveButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.semibold)], for: [])
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.backgroundColor = UIColor(rgb: 0xFFFFFF)
        
        // Instantiate a new generator.
        feedbackGenerator = UISelectionFeedbackGenerator()
        
        // Prepare the generator when the gesture begins.
        feedbackGenerator?.prepare()
        
        /*
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                print(request)
            }
        })
         */
        
    }
    
}

