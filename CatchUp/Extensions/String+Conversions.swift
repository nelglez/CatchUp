//
//  String+Conversions.swift
//  CatchUp
//
//  Created by Ryan Token on 1/13/18.
//  Copyright © 2019 Token Solutions. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var imageFromBase64EncodedString: UIImage? {
        if let data = NSData(base64Encoded: self, options: .ignoreUnknownCharacters) {
            return UIImage(data: data as Data)
        }
        return nil
    }
}
