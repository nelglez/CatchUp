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
    
    //contact picture
    @IBOutlet weak var contactPicture: UIImageView!
    
    //labels
    @IBOutlet weak var contactName: UILabel!
    
    //set who we have stored
    var storedContacts = UserDefaults.standard.object(forKey: "selectedContacts") as! [String:[String]]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let index = storedContacts.index(storedContacts.startIndex, offsetBy: activeFriend)
        
        contactName.text = storedContacts[index].key
        
        //set contact picture
        contactPicture.image = getImageString().imageFromBase64EncodedString
        contactPicture.layer.borderWidth = 1
        contactPicture.layer.masksToBounds = false
        contactPicture.layer.borderColor = UIColor.clear.cgColor
        contactPicture.layer.cornerRadius = contactPicture.frame.height/2
        contactPicture.clipsToBounds = true
        
    }
    
    //number of rows in the table
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let index = storedContacts.index(storedContacts.startIndex, offsetBy: activeFriend)
        
        //this might return too many
        let tableRows = storedContacts.values[index].count
        
        return tableRows-1

    }
    
    //the height of each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //set height to 0 if string is ""
        let index = storedContacts.index(storedContacts.startIndex, offsetBy: activeFriend)
        
        let details = storedContacts.values[index][indexPath.row]
        
        //if the dictionary index is "", set the height to 0
        if details == "" {
            
            return 0
            
            //if there is something at that index, set the height to default
        } else {
            
            return UITableViewAutomaticDimension
            
        }
        
    }
    
    //What each cell's text shows
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = storedContacts.index(storedContacts.startIndex, offsetBy: activeFriend)
        
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "detailCell")
        
        let details = storedContacts.values[index][indexPath.row]
        
        if indexPath.row == 0 && details != "" {
            
            cell.textLabel?.text = "Phone"
            cell.detailTextLabel?.textColor = UIColor(red: 0.0, green: 0.588, blue: 1.0, alpha: 0.85)
            
        } else if indexPath.row == 1 && details != "" {
            
            cell.textLabel?.text = "Secondary Phone"
            cell.detailTextLabel?.textColor = UIColor(red: 0.0, green: 0.588, blue: 1.0, alpha: 0.85)
            
        } else if indexPath.row == 2 && details != "" {
            
            cell.textLabel?.text = "Email"
            cell.detailTextLabel?.textColor = UIColor(red: 0.0, green: 0.588, blue: 1.0, alpha: 0.85)
            
        } else if indexPath.row == 3 && details != "" {
            
            cell.textLabel?.text = "Secondary Email"
            cell.detailTextLabel?.textColor = UIColor(red: 0.0, green: 0.588, blue: 1.0, alpha: 0.85)
            
        } else if indexPath.row == 4 && details != "" {
            
            cell.textLabel?.text = "Address"
            
        } else if indexPath.row == 5 && details != "" {
            
            cell.textLabel?.text = "Secondary Address"
            
        } else if indexPath.row == 6 && details != "" {
            
            cell.textLabel?.text = "Birthday"
            
        } else if indexPath.row == 7 && details != "" {
            
            cell.textLabel?.text = "Anniversary"
            
        }
        
        if details != "" {
            
            cell.detailTextLabel?.text = details
            
        }
        
        cell.detailTextLabel?.numberOfLines = 0;
        cell.detailTextLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
        
        cell.clipsToBounds = true
        
        return cell
        
    }
    
    //what happens when you select a cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let index = storedContacts.index(storedContacts.startIndex, offsetBy: activeFriend)
        
        var details = storedContacts.values[index][indexPath.row]
        
        //call primary phone number if there is one
        if indexPath.row == 0 && details != "" {
            
            details = details.replacingOccurrences(of: "[^\\d+]", with: "", options: [.regularExpression])
            
            if let number = URL(string: "tel://\(details)"), UIApplication.shared.canOpenURL(number) {
                UIApplication.shared.open(number)
            }
            
            //call secondary phone number if there is one
        } else if indexPath.row == 1 && details != "" {
            
            details = details.replacingOccurrences(of: "[^\\d+]", with: "", options: [.regularExpression])
            
            if let number = URL(string: "tel://\(details)"), UIApplication.shared.canOpenURL(number) {
                UIApplication.shared.open(number)
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
        
    }
    
    //gets last index of my dictionary, because that's where the contact photo always is
    func getImageString() -> String {
        
        let index = storedContacts.index(storedContacts.startIndex, offsetBy: activeFriend)
        
        let lastValue = storedContacts[index].value.last!
        
        //print("lastValue = ", lastValue)
        return lastValue
        
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        
        let selected = Array(storedContacts.keys)[activeFriend]
        
        //remove current key from dictionary
        storedContacts.removeValue(forKey: selected)
        
        UserDefaults.standard.set(storedContacts, forKey: "selectedContacts")
        
        //go back to home screen
        _ = navigationController?.popViewController(animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*valuable code so not deleting it
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
