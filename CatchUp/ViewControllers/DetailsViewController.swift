//
//  DetailsViewController.swift
//  CatchUp
//
//  Created by Ryan Token on 11/15/17.
//  Copyright © 2017 Token Solutions. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var activeFriend = 0
    
    //var originalPerson: Int = 0
    
    //contact picture
    @IBOutlet weak var contactPicture: UIImageView!
    
    //contact name
    @IBOutlet weak var contactName: UILabel!
    
    //contact preference
    @IBOutlet weak var contactPreference: UILabel!
    
    //set who we have stored
    var storedContacts = UserDefaults.standard.object(forKey: "selectedContacts") as! [String:[String]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let key = storedContacts.index(storedContacts.startIndex, offsetBy: activeFriend)
        
        //let fullName = storedContacts[key].key
        
        //originalPerson = (storedContacts.index(forKey: fullName)?.hashValue)!
        
        //print(storedContacts[key].value[0])
        
        contactPreference.text = "Preference: \(storedContacts[key].value[8])"
        
        contactName.text = storedContacts[key].key
        
        //set contact picture
        contactPicture.accessibilityIgnoresInvertColors = true
        contactPicture.image = getImageString().imageFromBase64EncodedString
        contactPicture.layer.borderWidth = 1
        contactPicture.layer.masksToBounds = false
        contactPicture.layer.borderColor = UIColor.clear.cgColor
        contactPicture.layer.cornerRadius = contactPicture.frame.height/2
        contactPicture.clipsToBounds = true
        
    } //end viewDidLoad
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.backgroundColor = UIColor(rgb: 0xFAFAFF)
        
        storedContacts = UserDefaults.standard.object(forKey: "selectedContacts") as! [String:[String]]
        
        //let key = storedContacts.index(storedContacts.startIndex, offsetBy: activeFriend)
        
        if let entry = storedContacts.first(where: { (key, _) in key.contains(contactName.text!) }) {
            contactPreference.text = "Preference: \(entry.value[8])"
        } else {
            contactPreference.text = "No Reminder Set"
        }
        
        //activeFriend = originalPerson
        
        //contactPreference.text = "Preference: \(storedContacts[key].value[8])"
    } //end viewDidAppear
    
    //number of rows in the table
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let key = storedContacts.index(storedContacts.startIndex, offsetBy: activeFriend)
        
        //this might return too many
        let tableRows = storedContacts.values[key].count
        
        return tableRows-3
        
    } //end numberOfRowsInSection
    
    //the height of each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //set height to 0 if string is ""
        let key = storedContacts.index(storedContacts.startIndex, offsetBy: activeFriend)
        
        let details = storedContacts.values[key][indexPath.row]
        
        //if the dictionary index is "", set the height to 0
        if details == "" {
            return 0
            //if there is something at that index, set the height to default
        } else {
            return UITableView.automaticDimension
        }
        
    } //end heightForRowAt
    
    //What each cell's text shows
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let key = storedContacts.index(storedContacts.startIndex, offsetBy: activeFriend)
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "detailCell")
        
        cell.selectionStyle = .none
        
        let details = storedContacts.values[key][indexPath.row]
        
        if indexPath.row == 0 && details != "" {
            
            cell.textLabel?.text = "Phone"
            cell.detailTextLabel?.textColor = UIColor(red: 0.0, green: 0.588, blue: 1.0, alpha: 0.85)
            cell.detailTextLabel?.text = details
            
        } else if indexPath.row == 1 && details != "" {
            
            cell.textLabel?.text = "Secondary Phone"
            cell.detailTextLabel?.textColor = UIColor(red: 0.0, green: 0.588, blue: 1.0, alpha: 0.85)
            cell.detailTextLabel?.text = details
            
        } else if indexPath.row == 2 && details != "" {
            
            cell.textLabel?.text = "Email"
            cell.detailTextLabel?.textColor = UIColor(red: 0.0, green: 0.588, blue: 1.0, alpha: 0.85)
            cell.detailTextLabel?.text = details
            
        } else if indexPath.row == 3 && details != "" {
            
            cell.textLabel?.text = "Secondary Email"
            cell.detailTextLabel?.textColor = UIColor(red: 0.0, green: 0.588, blue: 1.0, alpha: 0.85)
            cell.detailTextLabel?.text = details
            
        } else if indexPath.row == 4 && details != "" {
            
            cell.textLabel?.text = "Address"
            cell.detailTextLabel?.text = details
            
        } else if indexPath.row == 5 && details != "" {
            
            cell.textLabel?.text = "Secondary Address"
            cell.detailTextLabel?.text = details
            
        } else if indexPath.row == 6 && details != "" {
            
            cell.textLabel?.text = "Birthday"
            cell.detailTextLabel?.text = details
            
        } else if indexPath.row == 7 && details != "" {
            
            cell.textLabel?.text = "Anniversary"
            cell.detailTextLabel?.text = details
            
        } else if indexPath.row == 8 || indexPath.row == 9 {
            
            cell.textLabel?.text = ""
            cell.detailTextLabel?.text = ""
            
        }
        
        /*
         if details != "" && storedContacts[key].value[8] == "" {
         
         cell.detailTextLabel?.text = details
         
         } else {
         
         cell.detailTextLabel?.text = ""
         
         }
         */
        
        cell.detailTextLabel?.numberOfLines = 0;
        cell.detailTextLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
        
        cell.clipsToBounds = true
        
        return cell
        
    } //end cellForRowAt
    
    //what happens when you select a cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let key = storedContacts.index(storedContacts.startIndex, offsetBy: activeFriend)
        
        var details = storedContacts.values[key][indexPath.row]
        
        //call primary phone number if there is one
        if indexPath.row == 0 && details != "" {
            
            details = details.replacingOccurrences(of: "[^\\d+]", with: "", options: [.regularExpression])
            
            //give option to call or text the number via ActionSheet
            if let number = URL(string: "tel://\(details)"), UIApplication.shared.canOpenURL(number) {
                
                let callNumber = number
                
                let callNumberString = number.absoluteString
                let start = callNumberString.index(callNumberString.startIndex, offsetBy: 6)
                let end = callNumberString.index(callNumberString.endIndex, offsetBy: 0)
                let range = start..<end
                let substringCallNumberString = callNumberString[range]
                
                let textNumber = String(substringCallNumberString) //convert substring to string so it lets go of substring memory
                
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                alert.messageActions(actions: [UIAlertAction(title: "Text", style: .default, handler: {(alert: UIAlertAction!) in self.textNumber(number: textNumber)}),
                                               UIAlertAction(title: "Call", style: .default, handler: {(alert: UIAlertAction!) in self.callNumber(number: callNumber)}),
                                               UIAlertAction(title: "FaceTime", style: .default, handler: {(alert: UIAlertAction!) in facetime(phoneNumber: textNumber)}),
                                               UIAlertAction(title: "Cancel", style: .cancel, handler: nil)],
                                     preferred: "Text")
                
                self.present(alert, animated: true)
                
            }
            
            //call secondary phone number if there is one
        } else if indexPath.row == 1 && details != "" {
            
            details = details.replacingOccurrences(of: "[^\\d+]", with: "", options: [.regularExpression])
            
            //give option to call or text the number via ActionSheet
            if let number = URL(string: "tel://\(details)"), UIApplication.shared.canOpenURL(number) {
                
                let callNumber = number
                
                let callNumberString = number.absoluteString
                let start = callNumberString.index(callNumberString.startIndex, offsetBy: 6)
                let end = callNumberString.index(callNumberString.endIndex, offsetBy: 0)
                let range = start..<end
                let substringCallNumberString = callNumberString[range]
                
                let textNumber = String(substringCallNumberString) //convert substring to string so it lets go of substring memory
                
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                alert.messageActions(actions: [UIAlertAction(title: "Text", style: .default, handler: {(alert: UIAlertAction!) in self.textNumber(number: textNumber)}),
                                               UIAlertAction(title: "Call", style: .default, handler: {(alert: UIAlertAction!) in self.callNumber(number: callNumber)}),
                                               UIAlertAction(title: "FaceTime", style: .default, handler: {(alert: UIAlertAction!) in facetime(phoneNumber: textNumber)}),
                                               UIAlertAction(title: "Cancel", style: .cancel, handler: nil)],
                                     preferred: "Text")
                
                self.present(alert, animated: true)
                
            }
            
            //email primary email address if there is one
        } else if indexPath.row == 2 && details != "" {
            
            if let email  = URL(string: "mailto:\(details)") {
                UIApplication.shared.open(email)
            } else {
                
            }
            
            //email secondary email address if there is one
        } else if indexPath.row == 3 && details != "" {
            
            if let email  = URL(string: "mailto:\(details)") {
                UIApplication.shared.open(email)
            } else {
                
            }
        }
    } //end didSelectRowAt
    
    //end table view functions//
    
    func callNumber(number: URL) {
        UIApplication.shared.open(number)
    } //end callNumber
    
    func textNumber(number: String) {
        UIApplication.shared.open(URL(string: "sms:\(number)")!)
    } //end textNumber
    
    //gets last index of my dictionary, because that's where the contact photo always is
    func getImageString() -> String {
        
        let key = storedContacts.index(storedContacts.startIndex, offsetBy: activeFriend)
        
        let lastValue = storedContacts[key].value.last!
        
        //print("lastValue = ", lastValue)
        return lastValue
        
    } //end getImageString
    
    @IBAction func deletePressed(_ sender: Any) {
        
        let selected = Array(storedContacts.keys)[activeFriend]
        
        let key = storedContacts.index(storedContacts.startIndex, offsetBy: activeFriend)
        
        switch UIDevice.current.userInterfaceIdiom {
        //only iPhones support the action sheet, so this case statement uses action sheet for iPhones and alerts for iPads
        case .phone:
            print ("iPhone")
            
            let alert = UIAlertController(
                title: nil,
                message: "Are you sure you want to delete this contact from your CatchUp list?",
                preferredStyle: .actionSheet)
            
            alert.messageActions(actions: [UIAlertAction(title: "Delete \(selected)", style: .destructive) { (_) in
                //remove current key from dictionary
                if self.storedContacts[key].value[10] != "" {
                    NotificationService.shared.notification.removePendingNotificationRequests(withIdentifiers: [self.storedContacts[key].value[10]])
                    print ("notification request removed")
                } else {
                    print ("notification request not removed")
                }
                
                self.storedContacts.removeValue(forKey: selected)
                UserDefaults.standard.set(self.storedContacts, forKey: "selectedContacts")
                
                //go back to home screen
                _ = self.navigationController?.popViewController(animated: true)
                },
                                           UIAlertAction(title: "Cancel", style: .cancel, handler: nil)],
                                 preferred: "Text")
            
            self.present(alert, animated: true)
            
        case .pad:
            print ("iPad")
            
            let alert = UIAlertController(
                title: nil,
                message: "Are you sure you want to delete this contact from your CatchUp list?",
                preferredStyle: .alert
            )
            
            alert.messageActions(actions: [UIAlertAction(title: "Delete \(selected)", style: .destructive) { (_) in
                //remove current key from dictionary
                if self.storedContacts[key].value[10] != "" {
                    NotificationService.shared.notification.removePendingNotificationRequests(withIdentifiers: [self.storedContacts[key].value[10]])
                    print ("notification request removed")
                } else {
                    print ("notification request not removed")
                }
                
                self.storedContacts.removeValue(forKey: selected)
                UserDefaults.standard.set(self.storedContacts, forKey: "selectedContacts")
                
                //go back to home screen
                _ = self.navigationController?.popViewController(animated: true)
                },
                                           UIAlertAction(title: "Cancel", style: .cancel, handler: nil)],
                                 preferred: "Text")
            
            self.present(alert, animated: true)
            
        case .unspecified:
            print ("What device could this be?")
            
            let alert = UIAlertController(
                title: nil,
                message: "Are you sure you want to delete this contact from your CatchUp list?",
                preferredStyle: .alert
            )
            
            alert.messageActions(actions: [UIAlertAction(title: "Delete \(selected)", style: .destructive) { (_) in
                //remove current key from dictionary
                if self.storedContacts[key].value[10] != "" {
                    NotificationService.shared.notification.removePendingNotificationRequests(withIdentifiers: [self.storedContacts[key].value[10]])
                    print ("notification request removed")
                } else {
                    print ("notification request not removed")
                }
                
                self.storedContacts.removeValue(forKey: selected)
                UserDefaults.standard.set(self.storedContacts, forKey: "selectedContacts")
                
                //go back to home screen
                _ = self.navigationController?.popViewController(animated: true)
                },
                                           UIAlertAction(title: "Cancel", style: .cancel, handler: nil)],
                                 preferred: "Text")
            
            self.present(alert, animated: true)
            
        case .tv:
            print("CatchUp is not available on Apple TV")
            
        case .carPlay:
            print("CatchUp does not support Apple CarPlay")
        }
        
    } //end deletePressed
    
    //what happens when the segue is performed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toReminderViewController" {
            let reminderViewController = segue.destination as! ReminderViewController
            
            reminderViewController.activeFriend = activeFriend
        }
    } //end prepare(for segue:)
    
    /*valuable regex code so not deleting it
     //regex check for a valid phone number
     //got from the second answer here (https://stackoverflow.com/questions/16699007/regular-expression-to-match-standard-10-digit-phone-number)
     func isValidPhoneNumber(value: String) -> Bool {
     let phoneRegEx = "^\\s*(?:\\+?(\\d{1,3}))?[-. (]*(\\d{3})?[-. )]*(\\d{3})[-. ]*(\\d{4})(?: *x(\\d+))?\\s*$"
     let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
     return phoneTest.evaluate(with: value)
     }
     
     //regex check for any number of letters, numbers, and characters separated by an @ sign and a . signifying a valid email address
     func isValidEmail(value:String) -> Bool {
     let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
     let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
     return emailTest.evaluate(with: value)
     }
     */
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

private func facetime(phoneNumber:String) {
    if let facetimeURL:NSURL = NSURL(string: "facetime://\(phoneNumber)") {
        let application:UIApplication = UIApplication.shared
        if (application.canOpenURL(facetimeURL as URL)) {
            application.open(facetimeURL as URL, options: [:], completionHandler: nil)
        }
    }
}
