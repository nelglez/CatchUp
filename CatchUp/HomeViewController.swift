//
//  ViewController.swift
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
    
    var activeRow = 0
    
    //var storedContacts = UserDefaults.standard.object(forKey: "selectedContacts")  as! [String:String]
    
    
    //Executes when the + button is tapped
    //Requests access if not given yet, and displays the user's Contacts upon approval
    @IBAction func addFriends(_ sender: Any) {
        
        switch CNContactStore.authorizationStatus(for: .contacts){
            
        //Requests access to user's contacts
        case .notDetermined:
            //print("Not Determined")
            let store = CNContactStore()
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
    //First checks if there are keys in the dictionary
    //If not, initialize an empty [String:String: dictionary
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        
        if isKeyPresentInUserDefaults(key: "selectedContacts") == false {
            
            var selectedContacts: [String:String] = [:]
            
            //save each contact selected and print their name and phone number
            for contact in contacts {
                
                // user name
                let fullName:String = contact.givenName + " " + contact.familyName
                
                // user phone number array and first number if they have multiple listed
                let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
                let firstPhoneNumber:CNPhoneNumber = userPhoneNumbers[0].value
                
                // user phone number as a string so I can display it on a label
                let primaryPhoneNumber:String = firstPhoneNumber.stringValue
                
                // print("Username: \(userName)")
                // print("Phone Number: \(primaryPhoneNumber)")
                
                selectedContacts[fullName] = primaryPhoneNumber
                
                UserDefaults.standard.set(selectedContacts, forKey: "selectedContacts")
                
                //print(selectedContacts)
                
            }
            
        //If there are already stored keys, set the dictionary to those stored keys
        } else {
            
            let storedContacts = UserDefaults.standard.object(forKey: "selectedContacts")
            
            var selectedContacts: [String:String] = storedContacts as! [String:String]
            
            //save each contact selected and print their name and phone number
            for contact in contacts {
                
                // user name
                let fullName:String = contact.givenName + " " + contact.familyName
                
                // user phone number array and first number
                let userPhoneNumbers:[CNLabeledValue<CNPhoneNumber>] = contact.phoneNumbers
                let firstPhoneNumber:CNPhoneNumber = userPhoneNumbers[0].value
                
                // user phone number as a string so I can display it on a label
                let primaryPhoneNumber:String = firstPhoneNumber.stringValue
                
                // print("Username: \(userName)")
                // print("Phone Number: \(primaryPhoneNumber)")
                
                selectedContacts[fullName] = primaryPhoneNumber
                
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
            
            let storedContacts = UserDefaults.standard.object(forKey: "selectedContacts") as! [String:String]
            
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
            
            let storedContacts = UserDefaults.standard.object(forKey: "selectedContacts") as! [String:String]
            
            var selectedContacts: [String:String] = storedContacts
            
            let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
            
            //returns name (key) of selected
            let contactName = Array(storedContacts.keys)[indexPath.row]
            
            //returns phone number (value) of selected
            let contactNumber = Array(selectedContacts.values)[indexPath.row]
            
            cell.textLabel?.text = contactName
            
            cell.detailTextLabel?.text = contactNumber
            
            return cell
            
        }
        
    }
    
    /*
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            let storedContacts = UserDefaults.standard.object(forKey: "selectedContacts")
            
            var selectedContacts: [String:String] = storedContacts as! [String:String]
            
            //returns name (key) of selected
            let selected = Array(selectedContacts.keys)[indexPath.row]
            
            //returns phone number (value) of selected
            //let removeNum = Array(selectedContacts.values)[indexPath.row]
            
            selectedContacts.removeValue(forKey: selected)
            
            UserDefaults.standard.set(selectedContacts, forKey: "selectedContacts")
            
            friendsTable.reloadData()
        }
    }
     */
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    
        let storedContacts = UserDefaults.standard.object(forKey: "selectedContacts")
        
        var selectedContacts: [String:String] = storedContacts as! [String:String]
        
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
    
    
    
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        
        return UserDefaults.standard.object(forKey: key) != nil
        
    }
    
    //keeps track of which row is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        activeFriend = indexPath.row
        
        performSegue(withIdentifier: "toDetailsViewController", sender: nil)
    }
    
    //what happens when the segue is performed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsViewController" {
            let detailsViewController = segue.destination as! DetailsViewController
            
            detailsViewController.activeRow = activeRow //sets activeRow in DetailsViewController to the row just tapped in TableViewController! Very cool
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerTitle.largeTitleDisplayMode = .automatic
        
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
        
        print("Contacts Dictionary: \(storedContacts)")
        
        friendsTable.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

