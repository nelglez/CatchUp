//
//  UIImage+Conversions.swift
//  CatchUp
//
//  Created by Ryan Token on 1/13/18.
//  Copyright © 2018 Token Solutions. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    var base64EncodedString: String? {
        if let data = self.pngData() {
            return data.base64EncodedString()
        }
        return nil
    }
}
