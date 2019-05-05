//
//  CKRecord+Enum.swift
//  CatchUp
//
//  Created by Ryan Token on 1/26/18.
//  Copyright © 2019 Token Solutions. All rights reserved.
//

import Foundation
import CloudKit

enum contactKey: String {
    case fullName
    case primaryPhoneNumber
    case secondaryPhoneNumber
    case primaryEmail
    case secondaryEmail
    case primaryAddress
    case secondaryAddress
    case birthday
    case anniversary
    case contactPicture
}

extension CKRecord {
    
    subscript(key: contactKey) -> Any? {
        get {
            return self[key.rawValue]
        }
        set {
            self[key.rawValue] = newValue as? CKRecordValue
        }
    }
    
}
