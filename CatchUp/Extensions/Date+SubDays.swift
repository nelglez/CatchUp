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
    
    func dayNumberOfWeekMinusOne() -> Int? {
        let weekday = Calendar.current.dateComponents([.weekday], from: self).weekday
        let weekdayMinusOne = weekday!-1
        return weekdayMinusOne
    }
    
    func dayOfMonth() -> Int? {
        return Calendar.current.dateComponents([.day], from: self).day
    }
    
    func currentMonth() -> Int? {
        let month = Calendar.current.component(.month, from: Date())
        return month
    }
    
    func currentMonthPlusTwo() -> Int? {
        let month = Calendar.current.component(.month, from: Date())
        let monthPlusTwo = month+2
        return monthPlusTwo
    }
    
    func currentMonthPlusThree() -> Int? {
        let month = Calendar.current.component(.month, from: Date())
        let monthPlusThree = month+3
        return monthPlusThree
    }
    
    func dayOfYear() -> Int? {
        let day = Calendar.current.ordinality(of: .day, in: .year, for: Date())
        return day
    }
    
    func weekOfMonth() -> Int? {
        let calendar = Calendar.current
        let weekOfMonth = calendar.component(.weekOfMonth, from: Date())
        return weekOfMonth
    }
    
    func weekOfYear() -> Int? {
        let calendar = Calendar.current
        let weekOfYear = calendar.component(.weekOfYear, from: Date())
        return weekOfYear
    }
}
