//
//  ReminderViewController.swift
//  CatchUp
//
//  Created by Ryan Token on 2/12/18.
//  Copyright © 2019 Token Solutions. All rights reserved.
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
    
    //var originalPerson: Int = 0
    
    var delimiter = " "
    
    //set who we have stored
    var storedContacts = UserDefaults.standard.object(forKey: "selectedContacts") as! [String:[String]]
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var preferenceTable: UITableView!
    
    @IBOutlet weak var dayDatePicker: UIDatePicker!
    @IBOutlet weak var weekDatePicker: UIDatePicker!
    @IBOutlet weak var monthDatePicker: UIDatePicker!
    @IBOutlet weak var yearDatePicker: UIDatePicker!
    @IBOutlet weak var customDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationService.shared.authorize()
        
        //REMOVES ALL PENDING NOTIFICATIONS
        //NotificationService.shared.notification.removeAllPendingNotificationRequests()
        
        let key = storedContacts.index(storedContacts.startIndex, offsetBy: activeFriend)
        
        let fullName = storedContacts[key].key
        let firstName = fullName.components(separatedBy: delimiter)
        
        //originalPerson = (storedContacts.index(forKey: fullName)?.hashValue)!
        
        descriptionLabel.text? = "Receive a notification to CatchUp with \(firstName[0]):"
        
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
        customDatePicker.minimumDate = minDate
        
        //set the date picker to the chosen setting
        func formatDates(picker:String) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss" //Only time date format
            //dateFormatter.timeZone = TimeZone(abbreviation: "CST+0:00") //Current time zone
            var setDate = dateFormatter.date(from: storedContacts[key].value[9]) //according to date, format your date string
            switch picker{
            case "Custom":
                dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss" //Day/time date format
                setDate = dateFormatter.date(from: storedContacts[key].value[9])
                customDatePicker.date = setDate ?? minDate!
            case "Every Day":
                dayDatePicker.date = setDate ?? minDate!
            case "Every Week":
                weekDatePicker.date = setDate ?? minDate!
            case "Every Month":
                monthDatePicker.date = setDate ?? minDate!
            case "Every Year":
                yearDatePicker.date = setDate ?? minDate!
            default:
                customDatePicker.date = minDate!
            }
        }
        
        switch storedContacts[key].value[8] {
        case "Custom":
            formatDates(picker: "Custom")
        case "Every Day":
            formatDates(picker: "Every Day")
        case "Every Week":
            formatDates(picker: "Every Week")
        case "Every Month":
            formatDates(picker: "Every Month")
        case "Every Year":
            formatDates(picker: "Every Year")
        default:
            customDatePicker.date = minDate!
        }
        
    } //end viewDidLoad
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.backgroundColor = UIColor(rgb: 0xFFFFFF)
        
        // Instantiate a new generator.
        feedbackGenerator = UISelectionFeedbackGenerator()
        
        // Prepare the generator when the gesture begins.
        feedbackGenerator?.prepare()
        
    } //end viewDidAppear
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5 //a row for every day, week, month, two months, three months, six months, year, and custom
        
    } //end numberOfRowsInSection
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "reminderCell")
        
        cell.selectionStyle = .none
        
        let key = storedContacts.index(storedContacts.startIndex, offsetBy: activeFriend)
        
        switch indexPath.row {
            
        case 0:
            cell.textLabel?.text = "Every Day"
        case 1:
            cell.textLabel?.text = "Every Week"
        case 2:
            cell.textLabel?.text = "Every Month"
        case 3:
            cell.textLabel?.text = "Every Year"
        case 4:
            cell.textLabel?.text = "Custom Reminder"
        default:
            cell.textLabel?.text = ""
            
        }
        
        if storedContacts[key].value[8] == "Every Day" && indexPath.row == 0 {
            
            hideAllDatePickers()
            dayDatePicker.isHidden = false
            
            cell.accessoryType = .checkmark
            
        } else if storedContacts[key].value[8] == "Every Week" && indexPath.row == 1 {
            
            hideAllDatePickers()
            weekDatePicker.isHidden = false
            
            cell.accessoryType = .checkmark
            
        } else if storedContacts[key].value[8] == "Every Month" && indexPath.row == 2 {
            
            hideAllDatePickers()
            monthDatePicker.isHidden = false
            
            cell.accessoryType = .checkmark
            
        } else if storedContacts[key].value[8] == "Every Year" && indexPath.row == 3 {
            
            hideAllDatePickers()
            yearDatePicker.isHidden = false
            
            cell.accessoryType = .checkmark
            
        } else if storedContacts[key].value[8] == "Custom" && indexPath.row == 4 {
            
            hideAllDatePickers()
            customDatePicker.isHidden = false
            
            cell.accessoryType = .checkmark
            
        }
        
        return cell
        
    } //end cellForRowAt
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            
            let key = storedContacts.index(storedContacts.startIndex, offsetBy: activeFriend)
            
            //print("current person: \(originalPerson)")
            
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
            } else {
                uncheckAllCells()
                cell.accessoryType = .checkmark
            }
            
            //removes any set reminders for this person, then sets the appropriate reminder
            
            //every day
            if indexPath.row == 0 && cell.accessoryType == .checkmark {
                print(activeFriend)
                
                // Trigger selection feedback.
                feedbackGenerator?.selectionChanged()
                
                // Keep the generator in a prepared state.
                feedbackGenerator?.prepare()
                
                hideAllDatePickers()
                dayDatePicker.isHidden = false
                
                dateString = "1"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm:ss"
                dateString = dateFormatter.string(from: dayDatePicker.date)
                
                NotificationService.shared.notification.removePendingNotificationRequests(withIdentifiers: [storedContacts[key].value[10]])
                
                let notificationIdentifier = randomString(length: 60)
                
                storedContacts.updateValue([primaryPhone, secondaryPhone, primaryEmail, secondaryEmail, primaryAddress, secondaryAddress, birthday, anniversary, "Every Day", dateString, notificationIdentifier, contactPicture], forKey: storedContacts[key].key)
                
                let startIndex = dateString.index(dateString.startIndex, offsetBy: 2)
                let substringHour = dateString.prefix(upTo: startIndex)
                let stringHour = String(substringHour) //convert substring to string so it lets go of substring memory
                let hour = Int(stringHour) //convert string to int so we can use it in our date components call for dateRequest()
                
                let start = dateString.index(dateString.startIndex, offsetBy: 3)
                let end = dateString.index(dateString.endIndex, offsetBy: -3)
                let range = start..<end
                let substringMinute = dateString[range]
                let stringMinute = String(substringMinute) //convert substring to string so it lets go of substring memory
                let minute = Int(stringMinute) //convert string to int so we can use it in our date components call for dateRequest()
                
                var components = DateComponents()
                components.hour = hour
                components.minute = minute
                
                //timerRequest(with: 86400, contactName: storedContacts[key].key, identifier: storedContacts[key].value[10])
                NotificationService.shared.dateRequest(with: components, contactName: storedContacts[key].key, identifier: storedContacts[key].value[10])
                
                UserDefaults.standard.set(storedContacts, forKey: "selectedContacts")
                
                //activeFriend = originalPerson
                //print(activeFriend)
                
                print(storedContacts[key].value[8])
                print(storedContacts[key].value[9])
                
                //removes the reminder that was set before and updates the dictionary
            } else if indexPath.row == 0 && cell.accessoryType == .none {
                
                hideAllDatePickers()
                
                dateString = ""
                
                NotificationService.shared.notification.removePendingNotificationRequests(withIdentifiers: [storedContacts[key].value[10]])
                
                let notificationIdentifier = ""
                
                storedContacts.updateValue([primaryPhone, secondaryPhone, primaryEmail, secondaryEmail, primaryAddress, secondaryAddress, birthday, anniversary, "No Reminder Set", dateString, notificationIdentifier, contactPicture], forKey: storedContacts[key].key)
                
                UserDefaults.standard.set(storedContacts, forKey: "selectedContacts")
                
                print(storedContacts[key].value[8])
                
                //every week
            } else if indexPath.row == 1 && cell.accessoryType == .checkmark {
                
                // Trigger selection feedback.
                feedbackGenerator?.selectionChanged()
                
                // Keep the generator in a prepared state.
                feedbackGenerator?.prepare()
                
                hideAllDatePickers()
                weekDatePicker.isHidden = false
                
                dateString = "7"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm:ss"
                dateString = dateFormatter.string(from: weekDatePicker.date)
                
                NotificationService.shared.notification.removePendingNotificationRequests(withIdentifiers: [storedContacts[key].value[10]])
                
                let notificationIdentifier = randomString(length: 60)
                
                storedContacts.updateValue([primaryPhone, secondaryPhone, primaryEmail, secondaryEmail, primaryAddress, secondaryAddress, birthday, anniversary, "Every Week", dateString, notificationIdentifier, contactPicture], forKey: storedContacts[key].key)
                
                let startIndex = dateString.index(dateString.startIndex, offsetBy: 2)
                let substringHour = dateString.prefix(upTo: startIndex)
                let stringHour = String(substringHour) //convert substring to string so it lets go of substring memory
                let hour = Int(stringHour) //convert string to int so we can use it in our date components call for dateRequest()
                
                let start = dateString.index(dateString.startIndex, offsetBy: 3)
                let end = dateString.index(dateString.endIndex, offsetBy: -3)
                let range = start..<end
                let substringMinute = dateString[range]
                let stringMinute = String(substringMinute) //convert substring to string so it lets go of substring memory
                let minute = Int(stringMinute) //convert string to int so we can use it in our date components call for dateRequest()
                
                var components = DateComponents()
                //if it's Sunday, remind on Saturday to avoid same-day notifications
                if Date().dayNumberOfWeek() == 1 {
                    components.weekday = 7
                } else {
                    components.weekday = Date().dayNumberOfWeekMinusOne() //every week at the day before the reminder is set (to avoid same-day notifications)
                }
                components.hour = hour
                components.minute = minute
                
                //timerRequest(with: 604800, contactName: storedContacts[key].key, identifier: storedContacts[key].value[10])
                NotificationService.shared.dateRequest(with: components, contactName: storedContacts[key].key, identifier: storedContacts[key].value[10])
                
                UserDefaults.standard.set(storedContacts, forKey: "selectedContacts")
                
                print(storedContacts[key].value[8])
                print(storedContacts[key].value[9])
                
            } else if indexPath.row == 1 && cell.accessoryType == .none {
                
                hideAllDatePickers()
                
                dateString = ""
                
                NotificationService.shared.notification.removePendingNotificationRequests(withIdentifiers: [storedContacts[key].value[10]])
                
                let notificationIdentifier = ""
                
                storedContacts.updateValue([primaryPhone, secondaryPhone, primaryEmail, secondaryEmail, primaryAddress, secondaryAddress, birthday, anniversary, "No Reminder Set", dateString, notificationIdentifier, contactPicture], forKey: storedContacts[key].key)
                
                UserDefaults.standard.set(storedContacts, forKey: "selectedContacts")
                
                print(storedContacts[key].value[8])
                
                //every month
            } else if indexPath.row == 2 && cell.accessoryType == .checkmark {
                
                // Trigger selection feedback.
                feedbackGenerator?.selectionChanged()
                
                // Keep the generator in a prepared state.
                feedbackGenerator?.prepare()
                
                hideAllDatePickers()
                monthDatePicker.isHidden = false
                
                dateString = "30"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm:ss"
                dateString = dateFormatter.string(from: monthDatePicker.date)
                
                NotificationService.shared.notification.removePendingNotificationRequests(withIdentifiers: [storedContacts[key].value[10]])
                
                let notificationIdentifier = randomString(length: 60)
                
                storedContacts.updateValue([primaryPhone, secondaryPhone, primaryEmail, secondaryEmail, primaryAddress, secondaryAddress, birthday, anniversary, "Every Month", dateString, notificationIdentifier, contactPicture], forKey: storedContacts[key].key)
                
                let startIndex = dateString.index(dateString.startIndex, offsetBy: 2)
                let substringHour = dateString.prefix(upTo: startIndex)
                let stringHour = String(substringHour) //convert substring to string so it lets go of substring memory
                let hour = Int(stringHour) //convert string to int so we can use it in our date components call for dateRequest()
                
                let start = dateString.index(dateString.startIndex, offsetBy: 3)
                let end = dateString.index(dateString.endIndex, offsetBy: -3)
                let range = start..<end
                let substringMinute = dateString[range]
                let stringMinute = String(substringMinute) //convert substring to string so it lets go of substring memory
                let minute = Int(stringMinute) //convert string to int so we can use it in our date components call for dateRequest()
                
                var components = DateComponents()
                
                if Date().dayNumberOfWeek() == 1 {
                    components.weekday = 1 //previously had this as 7 (saturday), but then they'd get the reminder the same week
                } else {
                    components.weekday = Date().dayNumberOfWeekMinusOne()
                }
                
                if Date().weekOfMonth() == 5 {
                    components.weekOfMonth = 4
                } else {
                    components.weekOfMonth = Date().weekOfMonth()
                }
                components.hour = hour
                components.minute = minute
                
                //timerRequest(with: 2629746, contactName: storedContacts[key].key, identifier: storedContacts[key].value[10])
                NotificationService.shared.dateRequest(with: components, contactName: storedContacts[key].key, identifier: storedContacts[key].value[10])
                
                UserDefaults.standard.set(storedContacts, forKey: "selectedContacts")
                
                print(storedContacts[key].value[8])
                print(storedContacts[key].value[9])
                
                
            } else if indexPath.row == 2 && cell.accessoryType == .none {
                
                hideAllDatePickers()
                
                dateString = ""
                
                NotificationService.shared.notification.removePendingNotificationRequests(withIdentifiers: [storedContacts[key].value[10]])
                
                let notificationIdentifier = ""
                
                storedContacts.updateValue([primaryPhone, secondaryPhone, primaryEmail, secondaryEmail, primaryAddress, secondaryAddress, birthday, anniversary, "No Reminder Set", dateString, notificationIdentifier, contactPicture], forKey: storedContacts[key].key)
                
                UserDefaults.standard.set(storedContacts, forKey: "selectedContacts")
                
                print(storedContacts[key].value[8])
                
                //every year
            } else if indexPath.row == 3 && cell.accessoryType == .checkmark {
                
                // Trigger selection feedback.
                feedbackGenerator?.selectionChanged()
                
                // Keep the generator in a prepared state.
                feedbackGenerator?.prepare()
                
                hideAllDatePickers()
                yearDatePicker.isHidden = false
                
                dateString = "365"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm:ss"
                dateString = dateFormatter.string(from: yearDatePicker.date)
                
                NotificationService.shared.notification.removePendingNotificationRequests(withIdentifiers: [storedContacts[key].value[10]])
                
                let notificationIdentifier = randomString(length: 60)
                
                storedContacts.updateValue([primaryPhone, secondaryPhone, primaryEmail, secondaryEmail, primaryAddress, secondaryAddress, birthday, anniversary, "Every Year", dateString, notificationIdentifier, contactPicture], forKey: storedContacts[key].key)
                
                let startIndex = dateString.index(dateString.startIndex, offsetBy: 2)
                let substringHour = dateString.prefix(upTo: startIndex)
                let stringHour = String(substringHour) //convert substring to string so it lets go of substring memory
                let hour = Int(stringHour) //convert string to int so we can use it in our date components call for dateRequest()
                
                let start = dateString.index(dateString.startIndex, offsetBy: 3)
                let end = dateString.index(dateString.endIndex, offsetBy: -3)
                let range = start..<end
                let substringMinute = dateString[range]
                let stringMinute = String(substringMinute) //convert substring to string so it lets go of substring memory
                let minute = Int(stringMinute) //convert string to int so we can use it in our date components call for dateRequest()
                
                let weekOfYear = Date().weekOfYear()
                //print(weekOfYear)
                
                var components = DateComponents()
                components.weekOfYear = weekOfYear
                
                if Date().dayNumberOfWeek() == 1 {
                    components.weekday = 1
                } else {
                    components.weekday = Date().dayNumberOfWeekMinusOne() //every year at the day before the reminder is set (to avoid same-day notifications)
                }
                components.hour = hour
                components.minute = minute
                
                //timerRequest(with: 31556952, contactName: storedContacts[key].key, identifier: storedContacts[key].value[10])
                NotificationService.shared.dateRequest(with: components, contactName: storedContacts[key].key, identifier: storedContacts[key].value[10])
                
                UserDefaults.standard.set(storedContacts, forKey: "selectedContacts")
                
                //print(storedContacts[key].value[8])
                //print(storedContacts[key].value[9])
                
            } else if indexPath.row == 3 && cell.accessoryType == .none {
                
                hideAllDatePickers()
                
                dateString = ""
                
                NotificationService.shared.notification.removePendingNotificationRequests(withIdentifiers: [storedContacts[key].value[10]])
                
                let notificationIdentifier = ""
                
                storedContacts.updateValue([primaryPhone, secondaryPhone, primaryEmail, secondaryEmail, primaryAddress, secondaryAddress, birthday, anniversary, "No Reminder Set", dateString, notificationIdentifier, contactPicture], forKey: storedContacts[key].key)
                
                UserDefaults.standard.set(storedContacts, forKey: "selectedContacts")
                
                //print(storedContacts[key].value[8])
                
                //custom date
            } else if indexPath.row == 4 && cell.accessoryType == .checkmark {
                
                // Trigger selection feedback.
                feedbackGenerator?.selectionChanged()
                
                // Keep the generator in a prepared state.
                feedbackGenerator?.prepare()
                
                hideAllDatePickers()
                customDatePicker.isHidden = false
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
                dateString = dateFormatter.string(from: customDatePicker.date)
                
                let key = storedContacts.index(storedContacts.startIndex, offsetBy: activeFriend)
                
                NotificationService.shared.notification.removePendingNotificationRequests(withIdentifiers: [storedContacts[key].value[10]])
                
                let notificationIdentifier = randomString(length: 60)
                
                storedContacts.updateValue([primaryPhone, secondaryPhone, primaryEmail, secondaryEmail, primaryAddress, secondaryAddress, birthday, anniversary, "Custom", dateString, notificationIdentifier, contactPicture], forKey: storedContacts[key].key)
                
                let startIndex = dateString.index(dateString.startIndex, offsetBy: 2)
                let substringMonth = dateString.prefix(upTo: startIndex)
                let stringMonth = String(substringMonth) //convert substring to string so it lets go of substring memory
                let month = Int(stringMonth) //convert string to int so we can use it in our date components call for dateRequest()
                
                let start = dateString.index(dateString.startIndex, offsetBy: 3)
                let end = dateString.index(dateString.endIndex, offsetBy: -14)
                let range = start..<end
                let substringDay = dateString[range]
                let stringDay = String(substringDay) //convert substring to string so it lets go of substring memory
                let day = Int(stringDay) //convert string to int so we can use it in our date components call for dateRequest()
                
                let yearStartIndex = dateString.index(dateString.startIndex, offsetBy: 6)
                let endIndex = dateString.index(dateString.endIndex, offsetBy: -9)
                let range2 = yearStartIndex..<endIndex
                let substringYear = dateString[range2]
                let stringYear = String(substringYear) //convert substring to string so it lets go of substring memory
                let year = Int(stringYear) //convert string to int so we can use it in our date components call for dateRequest()
                
                let hourStartIndex = dateString.index(dateString.startIndex, offsetBy: 11)
                let hourEndIndex = dateString.index(dateString.endIndex, offsetBy: -6)
                let range3 = hourStartIndex..<hourEndIndex
                let substringHour = dateString[range3]
                let stringHour = String(substringHour) //convert substring to string so it lets go of substring memory
                let hour = Int(stringHour) //convert string to int so we can use it in our date components call for dateRequest()
                
                let minuteStartIndex = dateString.index(dateString.startIndex, offsetBy: 14)
                let minuteEndIndex = dateString.index(dateString.endIndex, offsetBy: -3)
                let range4 = minuteStartIndex..<minuteEndIndex
                let substringMinute = dateString[range4]
                let stringMinute = String(substringMinute) //convert substring to string so it lets go of substring memory
                let minute = Int(stringMinute) //convert string to int so we can use it in our date components call for dateRequest()
                
                //print(month!, "/", day!, "/", year!, " ", hour!, ":", minute!)
                
                var components = DateComponents()
                components.month = month
                components.day = day
                components.year = year
                components.hour = hour
                components.minute = minute //custom time on custom day
                components.second = 00
                
                NotificationService.shared.dateRequest(with: components, contactName: storedContacts[key].key, identifier: storedContacts[key].value[10])
                
                UserDefaults.standard.set(storedContacts, forKey: "selectedContacts")
                //print(storedContacts[key].value[8])
                //print(storedContacts[key].value[9])
                
            } else if indexPath.row == 4 && cell.accessoryType == .none {
                
                hideAllDatePickers()
                
                dateString = ""
                
                NotificationService.shared.notification.removePendingNotificationRequests(withIdentifiers: [storedContacts[key].value[10]])
                
                let notificationIdentifier = ""
                
                storedContacts.updateValue([primaryPhone, secondaryPhone, primaryEmail, secondaryEmail, primaryAddress, secondaryAddress, birthday, anniversary, "No Reminder Set", dateString, notificationIdentifier, contactPicture], forKey: storedContacts[key].key)
                
                UserDefaults.standard.set(storedContacts, forKey: "selectedContacts")
                
                //print(storedContacts[key].value[8])
                
            }
            
        }
        
    } //end didSelectRowAt
    
    @IBAction func dayPickerMoved(_ sender: Any) {
        
        //print("day time moved")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateString = dateFormatter.string(from: dayDatePicker.date)
        
        let key = storedContacts.index(storedContacts.startIndex, offsetBy: activeFriend)
        
        NotificationService.shared.notification.removePendingNotificationRequests(withIdentifiers: [storedContacts[key].value[10]])
        
        let notificationIdentifier = randomString(length: 60)
        
        storedContacts.updateValue([primaryPhone, secondaryPhone, primaryEmail, secondaryEmail, primaryAddress, secondaryAddress, birthday, anniversary, "Every Day", dateString, notificationIdentifier, contactPicture], forKey: storedContacts[key].key)
        
        let startIndex = dateString.index(dateString.startIndex, offsetBy: 2)
        let substringHour = dateString.prefix(upTo: startIndex)
        let stringHour = String(substringHour) //convert substring to string so it lets go of substring memory
        let hour = Int(stringHour) //convert string to int so we can use it in our date components call for dateRequest()
        
        let start = dateString.index(dateString.startIndex, offsetBy: 3)
        let end = dateString.index(dateString.endIndex, offsetBy: -3)
        let range = start..<end
        let substringMinute = dateString[range]
        let stringMinute = String(substringMinute) //convert substring to string so it lets go of substring memory
        let minute = Int(stringMinute) //convert string to int so we can use it in our date components call for dateRequest()
        
        var components = DateComponents()
        components.hour = hour
        components.minute = minute //custom time on custom day
        components.second = 00
        
        NotificationService.shared.dateRequest(with: components, contactName: storedContacts[key].key, identifier: storedContacts[key].value[10])
        
        UserDefaults.standard.set(storedContacts, forKey: "selectedContacts")
        //print(storedContacts[key].value[9])
        
    } //end dayPickerMoved
    
    @IBAction func weekPickerMoved(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateString = dateFormatter.string(from: weekDatePicker.date)
        
        let key = storedContacts.index(storedContacts.startIndex, offsetBy: activeFriend)
        
        NotificationService.shared.notification.removePendingNotificationRequests(withIdentifiers: [storedContacts[key].value[10]])
        
        let notificationIdentifier = randomString(length: 60)
        
        storedContacts.updateValue([primaryPhone, secondaryPhone, primaryEmail, secondaryEmail, primaryAddress, secondaryAddress, birthday, anniversary, "Every Week", dateString, notificationIdentifier, contactPicture], forKey: storedContacts[key].key)
        
        let startIndex = dateString.index(dateString.startIndex, offsetBy: 2)
        let substringHour = dateString.prefix(upTo: startIndex)
        let stringHour = String(substringHour) //convert substring to string so it lets go of substring memory
        let hour = Int(stringHour) //convert string to int so we can use it in our date components call for dateRequest()
        
        let start = dateString.index(dateString.startIndex, offsetBy: 3)
        let end = dateString.index(dateString.endIndex, offsetBy: -3)
        let range = start..<end
        let substringMinute = dateString[range]
        let stringMinute = String(substringMinute) //convert substring to string so it lets go of substring memory
        let minute = Int(stringMinute) //convert string to int so we can use it in our date components call for dateRequest()
        
        var components = DateComponents()
        //if it's Sunday, remind on Saturday to avoid same-day notifications
        if Date().dayNumberOfWeek() == 1 {
            components.weekday = 7
        } else {
            components.weekday = Date().dayNumberOfWeek()! - 1 //every week at the day before the reminder is set (to avoid same-day notifications)
        }
        components.hour = hour
        components.minute = minute //custom time on custom day
        components.second = 00
        
        NotificationService.shared.dateRequest(with: components, contactName: storedContacts[key].key, identifier: storedContacts[key].value[10])
        
        UserDefaults.standard.set(storedContacts, forKey: "selectedContacts")
        //print(storedContacts[key].value[9])
        
    } //end weekPickerMoved
    
    @IBAction func monthPickerMoved(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateString = dateFormatter.string(from: monthDatePicker.date)
        
        let key = storedContacts.index(storedContacts.startIndex, offsetBy: activeFriend)
        
        NotificationService.shared.notification.removePendingNotificationRequests(withIdentifiers: [storedContacts[key].value[10]])
        
        let notificationIdentifier = randomString(length: 60)
        
        storedContacts.updateValue([primaryPhone, secondaryPhone, primaryEmail, secondaryEmail, primaryAddress, secondaryAddress, birthday, anniversary, "Every Month", dateString, notificationIdentifier, contactPicture], forKey: storedContacts[key].key)
        
        let startIndex = dateString.index(dateString.startIndex, offsetBy: 2)
        let substringHour = dateString.prefix(upTo: startIndex)
        let stringHour = String(substringHour) //convert substring to string so it lets go of substring memory
        let hour = Int(stringHour) //convert string to int so we can use it in our date components call for dateRequest()
        
        let start = dateString.index(dateString.startIndex, offsetBy: 3)
        let end = dateString.index(dateString.endIndex, offsetBy: -3)
        let range = start..<end
        let substringMinute = dateString[range]
        let stringMinute = String(substringMinute) //convert substring to string so it lets go of substring memory
        let minute = Int(stringMinute) //convert string to int so we can use it in our date components call for dateRequest()
        
        var components = DateComponents()
        if Date().dayNumberOfWeek() == 1 {
            components.weekday = 1 //Sunday
        } else {
            components.weekday = Date().dayNumberOfWeekMinusOne()
        }
        components.weekOfMonth = Date().weekOfMonth()
        components.hour = hour
        components.minute = minute //custom time on custom day
        components.second = 00
        
        NotificationService.shared.dateRequest(with: components, contactName: storedContacts[key].key, identifier: storedContacts[key].value[10])
        
        UserDefaults.standard.set(storedContacts, forKey: "selectedContacts")
        //print(storedContacts[key].value[9])
        
    } //end monthPickerMoved
    
    @IBAction func yearPickerMoved(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateString = dateFormatter.string(from: yearDatePicker.date)
        
        let key = storedContacts.index(storedContacts.startIndex, offsetBy: activeFriend)
        
        NotificationService.shared.notification.removePendingNotificationRequests(withIdentifiers: [storedContacts[key].value[10]])
        
        let notificationIdentifier = randomString(length: 60)
        
        storedContacts.updateValue([primaryPhone, secondaryPhone, primaryEmail, secondaryEmail, primaryAddress, secondaryAddress, birthday, anniversary, "Every Year", dateString, notificationIdentifier, contactPicture], forKey: storedContacts[key].key)
        
        let startIndex = dateString.index(dateString.startIndex, offsetBy: 2)
        let substringHour = dateString.prefix(upTo: startIndex)
        let stringHour = String(substringHour) //convert substring to string so it lets go of substring memory
        let hour = Int(stringHour) //convert string to int so we can use it in our date components call for dateRequest()
        
        let start = dateString.index(dateString.startIndex, offsetBy: 3)
        let end = dateString.index(dateString.endIndex, offsetBy: -3)
        let range = start..<end
        let substringMinute = dateString[range]
        let stringMinute = String(substringMinute) //convert substring to string so it lets go of substring memory
        let minute = Int(stringMinute) //convert string to int so we can use it in our date components call for dateRequest()
        
        let weekOfYear = Calendar.current.component(.weekOfYear, from: Date.init(timeIntervalSinceNow: 0))
        //print(weekOfYear)
        
        var components = DateComponents()
        components.weekOfYear = weekOfYear
        
        if Date().dayNumberOfWeek() == 1 {
            components.weekday = 1
        } else {
            components.weekday = Date().dayNumberOfWeek()! - 1 //every year at the day before the reminder is set (to avoid same-day notifications)
        }
        components.weekOfMonth = Date().weekOfMonth()
        components.hour = hour
        components.minute = minute //custom time on custom day
        components.second = 00
        
        NotificationService.shared.dateRequest(with: components, contactName: storedContacts[key].key, identifier: storedContacts[key].value[10])
        
        UserDefaults.standard.set(storedContacts, forKey: "selectedContacts")
        //print(storedContacts[key].value[9])
        
    } //end yearPickerMoved
    
    @IBAction func customPickerMoved(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        dateString = dateFormatter.string(from: customDatePicker.date)
        
        let key = storedContacts.index(storedContacts.startIndex, offsetBy: activeFriend)
        
        NotificationService.shared.notification.removePendingNotificationRequests(withIdentifiers: [storedContacts[key].value[10]])
        
        let notificationIdentifier = randomString(length: 60)
        
        storedContacts.updateValue([primaryPhone, secondaryPhone, primaryEmail, secondaryEmail, primaryAddress, secondaryAddress, birthday, anniversary, "Custom", dateString, notificationIdentifier, contactPicture], forKey: storedContacts[key].key)
        
        let startIndex = dateString.index(dateString.startIndex, offsetBy: 2)
        let substringMonth = dateString.prefix(upTo: startIndex)
        let stringMonth = String(substringMonth) //convert substring to string so it lets go of substring memory
        let month = Int(stringMonth) //convert string to int so we can use it in our date components call for dateRequest()
        
        let start = dateString.index(dateString.startIndex, offsetBy: 3)
        let end = dateString.index(dateString.endIndex, offsetBy: -14)
        let range = start..<end
        let substringDay = dateString[range]
        let stringDay = String(substringDay) //convert substring to string so it lets go of substring memory
        let day = Int(stringDay) //convert string to int so we can use it in our date components call for dateRequest()
        
        let yearStartIndex = dateString.index(dateString.startIndex, offsetBy: 6)
        let endIndex = dateString.index(dateString.endIndex, offsetBy: -9)
        let range2 = yearStartIndex..<endIndex
        let substringYear = dateString[range2]
        let stringYear = String(substringYear) //convert substring to string so it lets go of substring memory
        let year = Int(stringYear) //convert string to int so we can use it in our date components call for dateRequest()
        
        let hourStartIndex = dateString.index(dateString.startIndex, offsetBy: 11)
        let hourEndIndex = dateString.index(dateString.endIndex, offsetBy: -6)
        let range3 = hourStartIndex..<hourEndIndex
        let substringHour = dateString[range3]
        let stringHour = String(substringHour) //convert substring to string so it lets go of substring memory
        let hour = Int(stringHour) //convert string to int so we can use it in our date components call for dateRequest()
        
        let minuteStartIndex = dateString.index(dateString.startIndex, offsetBy: 14)
        let minuteEndIndex = dateString.index(dateString.endIndex, offsetBy: -3)
        let range4 = minuteStartIndex..<minuteEndIndex
        let substringMinute = dateString[range4]
        let stringMinute = String(substringMinute) //convert substring to string so it lets go of substring memory
        let minute = Int(stringMinute) //convert string to int so we can use it in our date components call for dateRequest()
        
        //print(month!, "/", day!, "/", year!, " ", hour!, ":", minute!)
        
        var components = DateComponents()
        components.month = month
        components.day = day
        components.year = year
        components.hour = hour
        components.minute = minute //custom time on custom day
        components.second = 00
        
        NotificationService.shared.dateRequest(with: components, contactName: storedContacts[key].key, identifier: storedContacts[key].value[10])
        
        UserDefaults.standard.set(storedContacts, forKey: "selectedContacts")
        //print(storedContacts[key].value[9])
        
    } //end customPickerMoved
    
    func uncheckAllCells() {
        
        for cell in preferenceTable.visibleCells {
            cell.accessoryType = .none
        }
        
    } //end uncheckAllCells
    
    //need a random string to be the unique identifier for each notification
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
    } //end randomString
    
    func hideAllDatePickers() {
        dayDatePicker.isHidden =  true
        weekDatePicker.isHidden = true
        monthDatePicker.isHidden = true
        yearDatePicker.isHidden = true
        customDatePicker.isHidden = true
    }
    
}
