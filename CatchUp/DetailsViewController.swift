//
//  DetailsViewController.swift
//  CatchUp
//
//  Created by Ryan Token on 11/15/17.
//  Copyright © 2017 Token Solutions. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var contactName: UILabel!
    
    @IBOutlet weak var contactNumber: UILabel!
    
    @IBOutlet weak var contactEmail: UILabel!
    
    var activeFriend = 0
    
    let storedContacts = UserDefaults.standard.object(forKey: "selectedContacts") as! [String:String]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let intIndex = activeFriend
        
        let index = storedContacts.index(storedContacts.startIndex, offsetBy: intIndex)
        
        contactName.text = storedContacts[index].key
        
        contactNumber.text = storedContacts[index].value
        
        contactEmail.text = "testemail@gmail.com"
        
        //print (storedContacts[index])
        
        // print (activeFriend)
    }

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
