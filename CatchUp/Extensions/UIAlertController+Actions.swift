//
//  UIAlertController+Actions.swift
//  CatchUp
//
//  Created by Ryan Token on 3/10/18.
//  Copyright © 2018 Token Solutions. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    func messageActions(actions: [UIAlertAction], preferred: String? = nil) {
        
        for action in actions {
            self.addAction(action)
            
            if let preferred = preferred, preferred == action.title {
                self.preferredAction = action
            }
        }
    }
}
