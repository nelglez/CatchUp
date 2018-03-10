//
//  Date+DayOfWeek.swift
//  CatchUp
//
//  Created by Ryan Token on 3/6/18.
//  Copyright © 2018 Token Solutions. All rights reserved.
//

import Foundation

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    
    func dayOfMonth() -> Int? {
        return Calendar.current.dateComponents([.day], from: self).day
    }
}
