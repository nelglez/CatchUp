//
//  AboutViewController.swift
//  CatchUp
//
//  Created by Ryan Token on 3/7/18.
//  Copyright © 2018 Token Solutions. All rights reserved.
//

import Foundation
import UIKit

class AboutViewController: UIViewController {
    
    var feedbackGenerator : UIImpactFeedbackGenerator? = nil
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func viewDidLoad() {
        
        // Instantiate a new generator.
        feedbackGenerator = UIImpactFeedbackGenerator()
        
        iconImageView.accessibilityIgnoresInvertColors = true
        
        IAPService.shared.fetchAvailableProducts()
        IAPService.shared.purchaseStatusBlock = {[weak self] (type) in
            guard let strongSelf = self else{ return }
            if type == .purchased {
                let alertView = UIAlertController(title: "", message: type.message(), preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    
                })
                alertView.addAction(action)
                strongSelf.present(alertView, animated: true, completion: nil)
            }
        }
    } //end viewDidLoad
    
    //$0.99 tip from Tip Jar
    @IBAction func graciousTipPressed(_ sender: Any) {
        // Prepare the generator when the gesture begins.
        feedbackGenerator?.prepare()
        feedbackGenerator?.impactOccurred() //Trigger selection feedback.
        IAPService.shared.leaveATip(index: 1)
    } //end graciousTipPressed
    
    //$1.99 tip from Tip Jar
    @IBAction func generousTipPressed(_ sender: Any) {
        feedbackGenerator?.prepare()
        feedbackGenerator?.impactOccurred() //Trigger selection feedback.
        IAPService.shared.leaveATip(index: 0)
    } //end generousTipPressed
    
    //$4.99 tip from Tip Jar
    @IBAction func gratuitousTipPressed(_ sender: Any) {
        feedbackGenerator?.prepare()
        feedbackGenerator?.impactOccurred() //Trigger selection feedback.
        IAPService.shared.leaveATip(index: 2)
    } //end gratuitousTipPressed
    
}
