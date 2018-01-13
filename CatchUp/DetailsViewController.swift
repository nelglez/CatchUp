//
//  DetailsViewController.swift
//  CatchUp
//
//  Created by Ryan Token on 11/15/17.
//  Copyright © 2017 Token Solutions. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var activeFriend = 0
    
    //contact picture
    @IBOutlet weak var contactPicture: UIImageView!
    
    //labels
    @IBOutlet weak var contactName: UILabel!
    
    @IBOutlet weak var primaryPhoneLabel: UILabel!
    
    @IBOutlet weak var secondaryPhoneLabel: UILabel!
    
    @IBOutlet weak var primaryEmailLabel: UILabel!
    
    @IBOutlet weak var secondaryEmailLabel: UILabel!
    
    //buttons
    @IBOutlet weak var primaryPhoneNumber: UIButton!
    
    @IBOutlet weak var secondaryPhoneNumber: UIButton!
    
    @IBOutlet weak var primaryEmailAddress: UIButton!
    
    @IBOutlet weak var secondaryEmailAddress: UIButton!
    
    //strings
    var primaryPhone:String = "No Phone Number"
    
    var secondaryPhone:String = "No Secondary Phone Number"
    
    var primaryEmail:String = "No Email Address"
    
    var secondaryEmail:String = "No Secondary Email Address"
    
    let storedContacts = UserDefaults.standard.object(forKey: "selectedContacts") as! [String:[String]]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let index = storedContacts.index(storedContacts.startIndex, offsetBy: activeFriend)
        
        contactName.text = storedContacts[index].key
        
        var emails = 0
        
        //find emails in information
        for information in storedContacts[index].value {
            
            //checks isValidEmail regex function for a valid email address in each information index
            if isValidEmail(value: information) == true {
                emails += 1
                
                if emails == 1 {
                    
                    primaryEmail = information
                    
                } else if emails > 1 {
                    
                    secondaryEmail = information
                    
                }
                
            } else {
                
                //print ("")
                
            }
            
        }
        
        var phoneNumbers = 0
        
        //isValidPhoneNumber is matching the UIImageView string as a phone number - this is the workaround for that
        //if there's only one index (there will always be at least one because of contactPicture), set primaryPhone to "No Phone Number"
        //if there are at least two indexes, only loop through the first two to look for phone numbers
        if storedContacts[index].value.count == 1 {
            
            primaryPhone = "No Phone Number"
            
        } else {
            
            let n = 2
            
            let firstTwo = storedContacts[index].value[0..<n]
            
            //find phone numbers in information
            for information in firstTwo {
                
                //checks for a valid phone number format using the function below
                if isValidPhoneNumber(value: information) == true {
                    phoneNumbers += 1
                    
                    if phoneNumbers == 1 {
                        
                        primaryPhone = information
                        
                    } else if phoneNumbers > 1 {
                        
                        secondaryPhone = information
                        
                    }
                    
                } else {
                    
                    //print("")
                    
                }
                
            }
            
        }
        
        contactPicture.image = getImageString().imageFromBase64EncodedString
        
        //if there's no primary phone number, hide the button, show the un-tappable label that says "No Phone Number"
        if primaryPhone == "No Phone Number" {
            
            primaryPhoneNumber.isHidden = true
            primaryPhoneLabel.isHidden = false
            primaryPhoneLabel.text = primaryPhone
            
            //there is a primary phone number
        } else {
            
            primaryPhoneLabel.isHidden = true
            primaryPhoneNumber.isHidden = false
            primaryPhoneNumber.setTitle(primaryPhone, for: .normal)
            
        }
        
        //if there's no secondary phone number, hide the button, show the un-tappable label that says "No Phone Number"
        if secondaryPhone == "No Secondary Phone Number" {
            
            secondaryPhoneNumber.isHidden = true
            secondaryPhoneLabel.isHidden = false
            secondaryPhoneLabel.text = secondaryPhone
            
            //there is a secondary phone number
        } else {
            
            secondaryPhoneLabel.isHidden = true
            secondaryPhoneNumber.isHidden = false
            secondaryPhoneNumber.setTitle(secondaryPhone, for: .normal)
            
        }
        
        //if there's no primary email address, hide the button, show the un-tappable label that says "No Email Address"
        if primaryEmail == "No Email Address" {
            
            primaryEmailAddress.isHidden = true
            primaryEmailLabel.isHidden = false
            primaryEmailLabel.text = primaryEmail
            
            //there is a primary email address
        } else {
            
            primaryEmailLabel.isHidden = true
            primaryEmailAddress.isHidden = false
            primaryEmailAddress.setTitle(primaryEmail, for: .normal)
            
        }
        
        //if there's no secondary email address, hide the button, show the un-tappable label that says "No Secondary Email Address"
        if secondaryEmail == "No Secondary Email Address" {
            
            secondaryEmailAddress.isHidden = true
            secondaryEmailLabel.isHidden = false
            secondaryEmailLabel.text = secondaryEmail
            
            //there is a secondary email address
        } else {
            
            secondaryEmailLabel.isHidden = true
            secondaryEmailAddress.isHidden = false
            secondaryEmailAddress.setTitle(secondaryEmail, for: .normal)
            
        }
        
    }
    
    //regex to check for 15 straight numbers (string value for image)
    func getImageString() -> String {
        
        let index = storedContacts.index(storedContacts.startIndex, offsetBy: activeFriend)
        
        let lastValue = storedContacts[index].value.last!
        
        print("lastValue = ", lastValue)
        return lastValue
        
    }
    
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
    
    @IBAction func primaryPhoneNumberPressed(_ sender: Any) {
        
        if let number = URL(string: "tel://\(primaryPhone)"), UIApplication.shared.canOpenURL(number) {
                UIApplication.shared.open(number)
        }
        
    }
    
    @IBAction func secondaryPhoneNumberPressed(_ sender: Any) {
        
        if let number = URL(string: "tel://\(secondaryPhone)"), UIApplication.shared.canOpenURL(number) {
            UIApplication.shared.open(number)
        }
        
    }
    
    @IBAction func primaryEmailAddressPressed(_ sender: Any) {
        
        if let number = URL(string: "tel://\(primaryEmail)"), UIApplication.shared.canOpenURL(number) {
            UIApplication.shared.open(number)
        }
        
    }
    
    @IBAction func secondaryEmailAddressPressed(_ sender: Any) {
        
        if let number = URL(string: "tel://\(secondaryEmail)"), UIApplication.shared.canOpenURL(number) {
            UIApplication.shared.open(number)
        }
        
    }
    
    /*
    func convertStringToUIImage (image: String) -> UIImage {
        
        //print(image)
        
        let imageData = image.data(using: String.Encoding.utf8)
        print ("imageData: ", imageData!)
        
        let base64Image = imageData!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        print ("base64Image: ", base64Image)

        let base64ImageAsData =  Data(base64Encoded: base64Image as String, options: NSData.Base64DecodingOptions())
        print ("base64ImageAsData: ", base64ImageAsData!)
        
        let dataAsUIImage = UIImage(data: base64ImageAsData!)
        print ("dataAsUIImage: ", dataAsUIImage)
        
        if dataAsUIImage != nil {
            
            print (dataAsUIImage)
            return dataAsUIImage!
            
        } else {
            
            print (dataAsUIImage)
            return #imageLiteral(resourceName: "DefaultContact.jpg")
            
        }
 
    }
 */

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
