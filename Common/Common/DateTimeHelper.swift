//
//  DateTimeHelper.swift
//  Welltravel
//
//  Created by Amit Sen on 11/17/17.
//  Copyright © 2017 Welldev.io. All rights reserved.
//

import Foundation

open class DateTimeHelper {
    
    public init() {
        
    }
    
    func compareDay(date1: Date, date2: Date) -> Int {
        let order = Calendar.current.compare(date1, to: date2, toGranularity: .day)
        
        switch order {
        case .orderedDescending:
            return -1   // DESCENDING
        case .orderedAscending:
            return 1    // ASCENDING
        case .orderedSame:
            return 0    // SAME
        }
    }
    
   public func getDate(format: String, dateString: String) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
       
        let dateObj = dateFormatter.date(from: dateString)
        
        return dateObj!
    }
    
    
    
    func getDate(daysFromNow: Int) -> Date {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let dateComponent = NSDateComponents()
        
        dateComponent.day = daysFromNow
        let newDate = calendar?.date(byAdding: dateComponent as DateComponents, to: Date(), options: [])
        
        return newDate!
    }
    
    func getDate(date: Date, daysFromDate: Int) -> Date {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let dateComponent = NSDateComponents()
        
        dateComponent.day = daysFromDate
        let newDate = calendar?.date(byAdding: dateComponent as DateComponents, to: date, options: [])
        
        return newDate!
    }
    
    func getDate(yearsFromNow years: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: 0 - years, to: Date())!
    }
    
    //
    public func getDateString(atFormat: String, fromFormat: String, dateString: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        //        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let dateObj = dateFormatter.date(from: dateString)
        
        print("dateObj in getDateString",getDate(format: fromFormat, dateString: dateString))
        
        dateFormatter.dateFormat = atFormat
        let finalDateStr = dateFormatter.string(from: dateObj!)
        
        print("Dateobj: \(finalDateStr)")
        
        return finalDateStr
    }
    


    
    
    func getDateStringFromDate(atFormat: String, date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = atFormat
        let finalDateStr = dateFormatter.string(from: date)
        
        print("Dateobj: \(finalDateStr)")
        
        return finalDateStr
    }
    
    func getYear(fromFormat: String, dateStr: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromFormat
        //        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let dateObj = dateFormatter.date(from: dateStr)
        
        dateFormatter.dateFormat = "YYYY"
        let finalDateStr = dateFormatter.string(from: dateObj!)
        
        return Int(finalDateStr)!
    }
}
