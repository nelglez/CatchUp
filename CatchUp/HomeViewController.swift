//
//  HomeViewController.swift
//  CatchUp
//
//  Created by Ryan Token on 11/9/17.
//  Copyright © 2017 Token Solutions. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

var activeFriend = -1

class HomeViewController: UIViewController, CNContactPickerDelegate, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var headerTitle: UINavigationItem!
    
    @IBOutlet weak var friendsTable: UITableView!
    
    let store = CNContactStore()
    
    var activeRow = 0
    
    //Executes when the + button is tapped
    //Requests access if not given yet, and displays the user's Contacts upon approval
    @IBAction func addFriends(_ sender: Any) {
        
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
            print("We need access to your Contacts to remind you to CatchUp with your friends!")
            
        //not sure what this is
        case .restricted:
            print("Probably won't have to deal with this")
            
        }
        
    }
    
    //Executes when a contact is selected
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        
        //First checks if there are keys in the dictionary
        //If not, initialize an empty [String:[String]] dictionary
        if isKeyPresentInUserDefaults(key: "selectedContacts") == false {
            
            var selectedContacts: [String:[String]] = [:]
            
            //save each contact selected and print their name and phone number
            for contact in contacts {
                
                let contactPicture: String
                
                //contact picture
                if contact.imageDataAvailable == true {
                    // there is an image for this contact
                    
                    contactPicture = (contact.thumbnailImageData?.base64EncodedString())!
                    
                    /*
                     let contactImage: UIImage = UIImage(data: contact.imageData!)!
                     
                     //custom convertUIImageToString function way down below
                     contactPicture = convertUIImageToString(image: contactImage)
                     */
                    
                } else {
                    
                    let imageData: NSData = UIImagePNGRepresentation(#imageLiteral(resourceName: "DefaultContact.jpg"))! as NSData
                    //let contactImageData: Data = UIImagePNGRepresentation(#imageLiteral(resourceName: "Default Contact.png"))!
                    
                    contactPicture = imageData.base64EncodedString()
                    
                    /*
                     let contactImageData: Data = UIImagePNGRepresentation(#imageLiteral(resourceName: "Default Contact.png"))!
                     let contactImage: UIImage = UIImage(data: contactImageData)!
                     
                     contactPicture = convertUIImageToString(image: contactImage)
                     
                     //contactPicture = UIImage(data: contactPictureData)!
                     */
                    
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
                
                //user phone number array and first number
                let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
                var primaryPhoneNumber:String
                var secondaryPhoneNumber:String
                
                //user email addresses array
                let emailAddresses = contact.emailAddresses
                var primaryEmail:String
                var secondaryEmail:String
                
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
                
                //if two phone numbers and two email addresses
                if userPhoneNumbers.count > 1 && emailAddresses.count > 1 {
                    
                    selectedContacts[fullName] = [primaryPhoneNumber, secondaryPhoneNumber, primaryEmail, secondaryEmail, contactPicture]
                    print ("Image Available: ", contact.imageDataAvailable)
                    
                    //if two phone numbers and one email address
                } else if userPhoneNumbers.count > 1 && emailAddresses.count > 0 {
                    
                    selectedContacts[fullName] = [primaryPhoneNumber, secondaryPhoneNumber, primaryEmail, contactPicture]
                    print ("Image Available: ", contact.imageDataAvailable)
                    
                    //if one phone number and two email addresses
                } else if userPhoneNumbers.count > 0 && emailAddresses.count > 1 {
                    
                    selectedContacts[fullName] = [primaryPhoneNumber, primaryEmail, secondaryEmail, contactPicture]
                    print ("Image Available: ", contact.imageDataAvailable)
                    
                    //if 1 phone number and one email address
                } else if userPhoneNumbers.count > 0 && emailAddresses.count > 0 {
                    
                    selectedContacts[fullName] = [primaryPhoneNumber, primaryEmail, contactPicture]
                    print ("Image Available: ", contact.imageDataAvailable)
                    
                    //if no phone number and one email address
                } else if userPhoneNumbers.count == 0 && emailAddresses.count > 0 {
                    
                    selectedContacts[fullName] = [primaryEmail, contactPicture]
                    print ("Image Available: ", contact.imageDataAvailable)
                    
                    //if one phone number and no email address
                } else if userPhoneNumbers.count > 0 && emailAddresses.count == 0 {
                    
                    selectedContacts[fullName] = [primaryPhoneNumber, contactPicture]
                    print ("Image Available: ", contact.imageDataAvailable)
                    
                    //if none of the above
                } else {
                    
                    selectedContacts[fullName] = [contactPicture]
                    print ("Image Available: ", contact.imageDataAvailable)
                    
                }
                
                UserDefaults.standard.set(selectedContacts, forKey: "selectedContacts")
                
                //print(selectedContacts)
                
            }
            
        //if there are already stored keys, set the dictionary to those stored keys
        } else {
            
            let storedContacts = UserDefaults.standard.object(forKey: "selectedContacts")
            
            var selectedContacts: [String:[String]] = storedContacts as! [String:[String]]
            
            //save each contact selected and print their name and phone number
            for contact in contacts {
                
                let contactPicture: String
                
                //contact picture
                if contact.imageDataAvailable == true {
                    // there is an image for this contact
                    
                    contactPicture = (contact.thumbnailImageData?.base64EncodedString())!
                    
                    /*
                     let contactImage: UIImage = UIImage(data: contact.imageData!)!
                     
                     //custom convertUIImageToString function way down below
                     contactPicture = convertUIImageToString(image: contactImage)
                     */
                    
                } else {
                    
                    let imageData: NSData = UIImagePNGRepresentation(#imageLiteral(resourceName: "DefaultContact.jpg"))! as NSData
                    //let contactImageData: Data = UIImagePNGRepresentation(#imageLiteral(resourceName: "Default Contact.png"))!
                    
                    contactPicture = imageData.base64EncodedString()
                    
                    /*
                     let contactImageData: Data = UIImagePNGRepresentation(#imageLiteral(resourceName: "Default Contact.png"))!
                     let contactImage: UIImage = UIImage(data: contactImageData)!
                     
                     contactPicture = convertUIImageToString(image: contactImage)
                     
                     //contactPicture = UIImage(data: contactPictureData)!
                     */
                    
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
                
                //user phone number array and first number
                let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
                var primaryPhoneNumber:String
                var secondaryPhoneNumber:String
                
                //user email addresses array
                let emailAddresses = contact.emailAddresses
                var primaryEmail:String
                var secondaryEmail:String
                
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
                
                //if two phone numbers and two email addresses
                if userPhoneNumbers.count > 1 && emailAddresses.count > 1 {
                    
                    selectedContacts[fullName] = [primaryPhoneNumber, secondaryPhoneNumber, primaryEmail, secondaryEmail, contactPicture]
                    print ("Image Available: ", contact.imageDataAvailable)
                    
                    //if two phone numbers and one email address
                } else if userPhoneNumbers.count > 1 && emailAddresses.count > 0 {
                    
                    selectedContacts[fullName] = [primaryPhoneNumber, secondaryPhoneNumber, primaryEmail, contactPicture]
                    print ("Image Available: ", contact.imageDataAvailable)
                    
                    //if one phone number and two email addresses
                } else if userPhoneNumbers.count > 0 && emailAddresses.count > 1 {
                    
                    selectedContacts[fullName] = [primaryPhoneNumber, primaryEmail, secondaryEmail, contactPicture]
                    print ("Image Available: ", contact.imageDataAvailable)
                    
                    //if 1 phone number and one email address
                } else if userPhoneNumbers.count > 0 && emailAddresses.count > 0 {
                    
                    selectedContacts[fullName] = [primaryPhoneNumber, primaryEmail, contactPicture]
                    print ("Image Available: ", contact.imageDataAvailable)
                    
                    //if no phone number and one email address
                } else if userPhoneNumbers.count == 0 && emailAddresses.count > 0 {
                    
                    selectedContacts[fullName] = [primaryEmail, contactPicture]
                    print ("Image Available: ", contact.imageDataAvailable)
                    
                    //if one phone number and no email address
                } else if userPhoneNumbers.count > 0 && emailAddresses.count == 0 {
                    
                    selectedContacts[fullName] = [primaryPhoneNumber, contactPicture]
                    print ("Image Available: ", contact.imageDataAvailable)
                    
                    //if none of the above
                } else {
                    
                    selectedContacts[fullName] = [contactPicture]
                    print ("Image Available: ", contact.imageDataAvailable)
                    
                }
                
                UserDefaults.standard.set(selectedContacts, forKey: "selectedContacts")
                
                //print(selectedContacts)
                
            }
            
        }
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isKeyPresentInUserDefaults(key: "selectedContacts") == false {
            
            //print("Nothing to see here")
            return 0
            
        } else {
            
            let storedContacts = UserDefaults.standard.object(forKey: "selectedContacts") as! [String:[String]]
            
            let tableRows = storedContacts.count
            
            return tableRows
            
        }
        
    }
    
    //What each cell text shows
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //If there are no keys stored for key 'selectedContacts'
        if isKeyPresentInUserDefaults(key: "selectedContacts") == false {
            
            let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
            
            cell.textLabel?.text = ""
            
            return cell
        
        //If there are keys stored for key 'selectedContacts'
        } else {
            
            let storedContacts = UserDefaults.standard.object(forKey: "selectedContacts") as! [String:[String]]
            
            var selectedContacts: [String:[String]] = storedContacts
            
            let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
            
            //returns name (key) of selected
            let contactName = Array(storedContacts.keys)[indexPath.row]
            
            //returns phone number (value) of selected
            let contactNumber = Array(selectedContacts.values)[indexPath.row]
            
            //cell title
            cell.textLabel?.text = contactName
            
            //cell subtitle
            cell.detailTextLabel?.text = contactNumber[0]
            
            return cell
            
        }
        
    }
    
    //what happens when a table cell is swiped
    //long swipe = delete cell
    //short swipe reveals delete and details
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    
        let storedContacts = UserDefaults.standard.object(forKey: "selectedContacts")
        
        var selectedContacts: [String:[String]] = storedContacts as! [String:[String]]
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { (action, indexPath) in
            
            //returns name (key) of selected
            let selected = Array(selectedContacts.keys)[indexPath.row]
            
            //returns phone number (value) of selected
            //let removeNum = Array(selectedContacts.values)[indexPath.row]
            
            selectedContacts.removeValue(forKey: selected)
            
            UserDefaults.standard.set(selectedContacts, forKey: "selectedContacts")
            
            self.friendsTable.reloadData()
            
        }
    
        let details = UITableViewRowAction(style: .normal, title: "Details") { (action, indexPath) in
            
            activeFriend = indexPath.row
            
            self.performSegue(withIdentifier: "toDetailsViewController", sender: nil)
            
        }
        
        delete.backgroundColor = UIColor.red
        details.backgroundColor = UIColor.lightGray
        
        return [delete, details]
    }
    
    //maybe works?
    func convertUIImageToString (image: UIImage) -> String {
        
        var imageAsData: Data = UIImagePNGRepresentation(image)!
        var imageAsInt: Int = 0 // initialize
        
        let data = NSData(bytes: &imageAsData, length: MemoryLayout<Int>.size)
        data.getBytes(&imageAsInt, length: MemoryLayout<Int>.size)
        
        let imageAsString: String = String (imageAsInt)
        
        return imageAsString
        
    }
    
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        
        return UserDefaults.standard.object(forKey: "selectedContacts") != nil
        
    }
    
    //keeps track of which row is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        activeFriend = indexPath.row
        
        let currentCell = tableView.cellForRow(at: indexPath) as UITableViewCell!
        
        print(currentCell?.textLabel!.text! ?? "None")
        
        performSegue(withIdentifier: "toDetailsViewController", sender: nil)
        
    }
    
    //what happens when the segue is performed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsViewController" {
            let detailsViewController = segue.destination as! DetailsViewController
            
            detailsViewController.activeFriend = activeFriend //sets activeRow in DetailsViewController to the row just tapped in TableViewController!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerTitle.largeTitleDisplayMode = .always
        
        /* CLEAR ALL USER DEFAULTS ON APP LOAD! WARNING
            if let bundle = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: bundle)
            }
         */
        
        //Requests access to user's contacts
        let store = CNContactStore()
        store.requestAccess(for: .contacts){succeeded, err in
            guard err == nil && succeeded else {
                return
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        activeFriend = -1
        
        let storedContacts = UserDefaults.standard.object(forKey: "selectedContacts")
        
        print("Contacts Dictionary: \(storedContacts ?? "Nothing Here Yet")")
        
        friendsTable.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

