//
//  HomeViewController.swift
//  CatchUp
//
//  Created by Ryan Token on 11/9/17.
//  Copyright © 2019 Token Solutions. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

var activeFriend = -1

class HomeViewController: UIViewController, CNContactPickerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //let database = CKContainer.default().privateCloudDatabase
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    @IBOutlet weak var friendsTable: UITableView!
    
    let store = CNContactStore()
    
    var storedContacts: [String:[String]] = [:]
    
    var activeRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         if let bundle = Bundle.main.bundleIdentifier {
         UserDefaults.standard.removePersistentDomain(forName: bundle)
         }
         */
        
        
    } //end viewDidLoad
    
    override func viewDidAppear(_ animated: Bool) {
        
        if isKeyPresentInUserDefaults(key: "selectedContacts") == false {
            storedContacts = [:]
        } else {
            storedContacts = UserDefaults.standard.object(forKey: "selectedContacts") as! [String : [String]]
        }
        
        activeFriend = -1
        
        //remove app badge icon on app load
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        //hides the nav bar border
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.backgroundColor = UIColor(rgb: 0xFFFFFF)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        //let storedContacts = UserDefaults.standard.object(forKey: "selectedContacts")
        //print("Contacts Dictionary: \(storedContacts ?? "Nothing Here Yet")")
        
        friendsTable.reloadData()
        
    } //end viewDidAppear
    
    //Executes when the Add Contacts button is tapped
    //Requests access if not given yet, and displays the user's Contacts upon approval
    @IBAction func addContacts(_ sender: Any) {
        
        //Requests access to user's contacts
        let store = CNContactStore()
        store.requestAccess(for: .contacts){succeeded, err in
            guard err == nil && succeeded else {
                return
            }
        }
        
        switch CNContactStore.authorizationStatus(for: .contacts){
        //Requests access to user's contacts
        case .notDetermined:
            //print("Not Determined")
            store.requestAccess(for: .contacts){succeeded, err in
                guard err == nil && succeeded else{
                    return
                }
            }
            
        //If the user has tapped 'OK' when requested
        case .authorized:
            //print("Authorized")
            let contactPicker = CNContactPickerViewController()
            
            contactPicker.delegate = self
            
            //will only show the contact's first name (given name) and their phone number
            contactPicker.displayedPropertyKeys = [CNContactGivenNameKey, CNContactPhoneNumbersKey]
            
            self.present(contactPicker, animated: true, completion: nil)
            
        //If the user has tapped 'Don't Allow' when requested
        case .denied:
            let alert = UIAlertController(title: "Cannot Add Contacts", message: "🤭 You denied CatchUp access to your Contacts. To change this, go the Settings app, scroll down to CatchUp, and turn on Allow CatchUp to Access Contacts", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            //print("We need access to your Contacts to remind you to CatchUp with your friends!")
            
        //not sure what this is
        case .restricted:
            print("Do nothing.")
            
        default:
            print("Do nothing.")
            
        }
        
    } // End addContacts
    
    // Apple's Contact Picker
    // Parses out all information the user has on the contact
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        
        //First checks if there are keys in the dictionary
        //If not, initialize an empty [String:[String]] dictionary
        if isKeyPresentInUserDefaults(key: "selectedContacts") == false {
            storedContacts = [:]
        } else {
            storedContacts = UserDefaults.standard.object(forKey: "selectedContacts") as! [String : [String]]
        }
        
        //save each contact selected and print their name and phone number
        for contact in contacts {
            
            let contactPicture: String
            
            //contact picture
            if contact.imageDataAvailable == true {
                // there is an image for this contact
                contactPicture = (contact.thumbnailImageData?.base64EncodedString())!
            } else {
                // there is not an image for this contact, use the default image
                let imageData: NSData = #imageLiteral(resourceName: "DefaultPhoto.png").pngData()! as NSData
                contactPicture = imageData.base64EncodedString()
            }
            
            //set the contact's name
            var fullName:String
            
            //if they have a first and a last name
            if contact.givenName != "" && contact.familyName != "" {
                fullName = contact.givenName + " " + contact.familyName
                //if they have a first name, but no last name
            } else if contact.givenName != "" && contact.familyName == "" {
                fullName = contact.givenName
                //if they have no first name, but have a last name
            } else if contact.givenName == "" && contact.familyName != "" {
                fullName = contact.familyName
            } else {
                fullName = ""
            }
            
            //let fullName:String = contact.givenName + " " + contact.familyName
            
            //contact phone number array
            let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
            var primaryPhoneNumber:String
            var secondaryPhoneNumber:String
            
            //check for phone numbers and set values
            if userPhoneNumbers.count > 0 {
                
                let firstPhoneNumber = userPhoneNumbers[0].value
                primaryPhoneNumber = firstPhoneNumber.stringValue
                
                if userPhoneNumbers.count > 1 {
                    let secondPhoneNumber = userPhoneNumbers[1].value
                    secondaryPhoneNumber = secondPhoneNumber.stringValue
                } else {
                    secondaryPhoneNumber = ""
                }
            } else {
                primaryPhoneNumber = ""
                secondaryPhoneNumber = ""
            }
            
            //contact email address array
            let emailAddresses = contact.emailAddresses
            var primaryEmail:String
            var secondaryEmail:String
            
            //check for email addresses and set values
            if emailAddresses.count > 0 {
                let firstEmail = emailAddresses[0].value
                primaryEmail = firstEmail as String
                
                if emailAddresses.count > 1 {
                    let secondEmail = emailAddresses[1].value
                    secondaryEmail = secondEmail as String
                } else {
                    secondaryEmail = ""
                }
            } else {
                primaryEmail = ""
                secondaryEmail = ""
            }
            
            //contact postal address array
            let addresses = contact.postalAddresses
            var primaryAddress:String
            var secondaryAddress:String
            
            //check for postal addresses and set values
            if addresses.count > 0 {
                let firstAddress = addresses[0].value
                let fullAddress = firstAddress.street + ", " + firstAddress.city + ", " + firstAddress.state + " " + firstAddress.postalCode
                primaryAddress = fullAddress.replacingOccurrences(of: "\n", with: " ")
                
                if addresses.count > 1 {
                    let secondAddress = addresses[1].value
                    let fullAddress = secondAddress.street + ", " + secondAddress.city + ", " + secondAddress.state + " " + secondAddress.postalCode
                    secondaryAddress = fullAddress.replacingOccurrences(of: "\n", with: " ")
                } else {
                    secondaryAddress = ""
                }
            } else {
                primaryAddress = ""
                secondaryAddress = ""
            }
            
            //check for birthday and set value
            var birthday:String
            
            if contact.birthday != nil {
                
                let birthdayDate = contact.birthday?.date
                
                let formatter = DateFormatter()
                formatter.dateFormat = "MM-dd-yyyy"
                
                birthday = formatter.string(from: birthdayDate!)
                
                let month = DateFormatter()
                month.dateFormat = "MM-"
                let year = DateFormatter()
                year.dateFormat = "-yyyy"
                
                //contacts is returning a birthday and anniversary that is one day before the actual day...
                //pull out the substring day from  from the full date
                let start = birthday.index(birthday.startIndex, offsetBy: 3)
                let end = birthday.index(birthday.endIndex, offsetBy: -5)
                let range = start..<end
                
                //increment the day by one
                let daySubstring = birthday[range]  //day of the anniversary
                var dayInt = Int(daySubstring)!
                dayInt = dayInt+1
                let newDay = "\(dayInt)"
                
                //add the new full date as the birthday
                //scrapped the year in case they didn't set one, and I don't want to deal with that
                birthday = month.string(from: birthdayDate!) + newDay
                
            } else {
                
                birthday = ""
                
            }
            
            //check for anniversary and set value for anniversary and reminder preference
            var anniversary: String
            var reminderType: String
            var reminderPreference: String
            var notificationIdentifier: String
            
            let anniversaryDate = contact.dates.filter { date -> Bool in
                
                guard let label = date.label
                    else {
                        return false
                }
                
                return label.contains("Anniversary")
                
                } .first?.value as DateComponents?
            
            if anniversaryDate?.date != nil {
                
                let formatter = DateFormatter()
                formatter.dateFormat = "MM-dd-yyyy"
                
                anniversary = formatter.string(from: (anniversaryDate?.date!)!)
                
                let month = DateFormatter()
                month.dateFormat = "MM-"
                let year = DateFormatter()
                year.dateFormat = "-yyyy"
                
                //contacts is returning a birthday and anniversary that is one day before the actual day...
                //pull out the substring day from  from the full date
                let start = anniversary.index(anniversary.startIndex, offsetBy: 3)
                let end = anniversary.index(anniversary.endIndex, offsetBy: -5)
                let range = start..<end
                
                //increment the day by one
                let daySubstring = anniversary[range]  //day of the anniversary
                var dayInt = Int(daySubstring)!
                dayInt = dayInt+1
                let newDay = "\(dayInt)"
                
                //add the new full date as the anniversary
                //scrapped the year in case they didn't set one, and I don't want to deal with that
                anniversary = month.string(from: (anniversaryDate?.date!)!) + newDay
                reminderType = "No Reminder Set"
                reminderPreference = ""
                notificationIdentifier = ""
                
            } else {
                
                anniversary = ""
                reminderType = "No Reminder Set"
                reminderPreference = ""
                notificationIdentifier = ""
                
            }
            
            //if the contacts is already stored in the dictionary, do nothing
            //if the contact is not already stored in the dictionary, store it in the dictionary
            if storedContacts[fullName] != nil {
                print("already stored in dictionary")
            } else {
                storedContacts[fullName] = [primaryPhoneNumber, secondaryPhoneNumber, primaryEmail, secondaryEmail, primaryAddress, secondaryAddress, birthday, anniversary, reminderType, reminderPreference, notificationIdentifier, contactPicture]
            }
            
            UserDefaults.standard.set(storedContacts, forKey: "selectedContacts")
            //saveToiCloud(contactData: selectedContacts)
            //print(selectedContacts)
        }
    } //end contactPicker did selection contacts
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //if the dictionary is empty
        if isKeyPresentInUserDefaults(key: "selectedContacts") == false {
            return 0
            //if there is something in the dictionary
        } else {
            
            let storedContacts = UserDefaults.standard.object(forKey: "selectedContacts") as! [String:[String]]
            let tableRows = storedContacts.count
            return tableRows
            
        }
    } //end numberOfRowsInSection
    
    // Set height of each row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
        //return UITableViewAutomaticDimension
    } //end heightForRowAt
    
    //What each cell text shows
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //If there are no keys stored for key 'selectedContacts'
        if isKeyPresentInUserDefaults(key: "selectedContacts") == false {
            
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
            cell.textLabel?.text = ""
            cell.accessoryType = .disclosureIndicator
            return cell
            
            //If there are keys stored for key 'selectedContacts'
        } else {
            
            let storedContacts = UserDefaults.standard.object(forKey: "selectedContacts") as! [String:[String]]
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "Cell")
            let cellImageView = cell.imageView!
            
            //returns name (key) of selected
            let keys = Array(storedContacts.keys)[indexPath.row]
            
            //returns phone number (value) of selected
            let values = Array(storedContacts.values)[indexPath.row]
            
            //returns string of contact photo (or defaultContact.jpg) of selected
            let contactPictureString = Array(storedContacts.values)[indexPath.row].last
            
            //converts contactPictureString to the actual image
            let contactPicture = contactPictureString!.imageFromBase64EncodedString
            
            cellImageView.accessibilityIgnoresInvertColors = true
            cellImageView.frame = CGRect(x: 50, y: 50, width: 50, height: 50)
            cellImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            
            //cell photo
            cellImageView.image = contactPicture
            
            //convert the imageView in each cell to a circle instead of a default square
            cellImageView.layer.borderWidth = 1
            cellImageView.layer.masksToBounds = false
            cellImageView.layer.borderColor = UIColor.lightGray.cgColor
            cellImageView.layer.cornerRadius = cellImageView.frame.height/2
            cellImageView.clipsToBounds = true
            
            //cell title
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            cell.textLabel?.text = keys
            
            //cell subtitle
            cell.detailTextLabel?.text = values[8]
            
            cell.clipsToBounds = true
            cell.accessoryType = .disclosureIndicator
            
            return cell
            
        }
    } //end cellForRowAt
    
    //what happens when a table cell is swiped
    //long swipe = delete cell
    //short swipe reveals delete and details
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        var storedContacts = UserDefaults.standard.object(forKey: "selectedContacts") as! [String:[String]]
        
        //var selectedContacts: [String:[String]] = storedContacts as! [String:[String]]
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { (action, indexPath) in
            
            //returns name (key) of selected
            let selected = Array(storedContacts.keys)[indexPath.row]
            let key = storedContacts.index(forKey: selected)
            
            switch UIDevice.current.userInterfaceIdiom {
            //only iPhones support the Action Sheet, so this case statement uses Action Sheet for iPhones and Alerts for iPads
            case .phone:
                print ("iPhone")
                
                let alert = UIAlertController(
                    title: nil,
                    message: "Are you sure you want to delete this contact from your CatchUp list?",
                    preferredStyle: .actionSheet)
                
                alert.messageActions(actions: [UIAlertAction(title: "Delete \(selected)", style: .destructive) { (_) in
                    //remove current key from dictionary
                    if storedContacts[key!].value[10] != "" {
                        NotificationService.shared.notification.removePendingNotificationRequests(withIdentifiers: [storedContacts[key!].value[10]])
                        print ("notification request removed")
                    } else {
                        print ("notification request not removed")
                    }
                    
                    storedContacts.removeValue(forKey: selected)
                    UserDefaults.standard.set(storedContacts, forKey: "selectedContacts")
                    
                    self.friendsTable.reloadData()
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
                    if storedContacts[key!].value[10] != "" {
                        NotificationService.shared.notification.removePendingNotificationRequests(withIdentifiers: [storedContacts[key!].value[10]])
                        print ("notification request removed")
                    } else {
                        print ("notification request not removed")
                    }
                    
                    storedContacts.removeValue(forKey: selected)
                    UserDefaults.standard.set(storedContacts, forKey: "selectedContacts")
                    
                    self.friendsTable.reloadData()
                    },
                                               UIAlertAction(title: "Cancel", style: .cancel, handler: nil)],
                                     preferred: "Text")
                
                self.present(alert, animated: true)
                
            case .tv:
                print("CatchUp is not available on Apple TV")
                
            case .carPlay:
                print("CatchUp does not support Apple CarPlay")
                
            case .unspecified:
                print ("What device could this be?")
                
                let alert = UIAlertController(
                    title: nil,
                    message: "Are you sure you want to delete this contact from your CatchUp list?",
                    preferredStyle: .alert
                )
                
                alert.messageActions(actions: [UIAlertAction(title: "Delete \(selected)", style: .destructive) { (_) in
                    //remove current key from dictionary
                    if storedContacts[key!].value[10] != "" {
                        NotificationService.shared.notification.removePendingNotificationRequests(withIdentifiers: [storedContacts[key!].value[10]])
                        print ("notification request removed")
                    } else {
                        print ("notification request not removed")
                    }
                    
                    storedContacts.removeValue(forKey: selected)
                    UserDefaults.standard.set(storedContacts, forKey: "selectedContacts")
                    
                    self.friendsTable.reloadData()
                    },
                                               UIAlertAction(title: "Cancel", style: .cancel, handler: nil)],
                                     preferred: "Text")
                
                self.present(alert, animated: true)
                
            default:
                print("Do nothing.")
                
            }
            
        }
        
        let details = UITableViewRowAction(style: .normal, title: "Details") { (action, indexPath) in
            
            activeFriend = indexPath.row
            self.performSegue(withIdentifier: "toDetailsViewController", sender: nil)
            
        }
        
        delete.backgroundColor = UIColor(rgb: 0xFF3B30)
        details.backgroundColor = UIColor(rgb: 0xC7C7CC)
        
        return [delete, details]
    } //end editActionsForRowAt
    
    //keeps track of which row is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        activeFriend = indexPath.row
        
        let currentCell = tableView.cellForRow(at: indexPath) as UITableViewCell?
        
        print(currentCell?.textLabel!.text! ?? "None")
        
        performSegue(withIdentifier: "toDetailsViewController", sender: nil)
        
    } //end didSelectRowAt
    
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        
        return UserDefaults.standard.object(forKey: "selectedContacts") != nil
        
    } //end isKeyPresentInUserDefaults
    
    //what happens when the segue is performed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsViewController" {
            let detailsViewController = segue.destination as! DetailsViewController
            
            detailsViewController.activeFriend = activeFriend //sets activeRow in DetailsViewController to the row just tapped in TableViewController!
        }
    } //end prepare(for segue:)
    
}

