//
//  DiaryRecord.swift
//  SimpleDiary
//
//  Created by ADM on 9/21/15.
//  Copyright © 2015 Buypass. All rights reserved.
//

import Foundation
import CoreData

class DiaryRecord: NSManagedObject {
    
//    init(creationDate: NSDate) {
//        super.init()
//        self.creationDate = creationDate
//        self.name = ""
//        self.body = ""
//        self.weather = Weather.Cloudy.rawValue
//    }
    
    func formattedDateShort() -> String {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.doesRelativeDateFormatting = true
        
        var formattedDate: String = ""
        if let date = creationDate {
            formattedDate = dateFormatter.stringFromDate(date)
        }
        
        return formattedDate
    }
    
    func formattedDateLong() -> String {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateFormatter.doesRelativeDateFormatting = true
        
        var formattedDate: String = ""
        if let date = creationDate {
            formattedDate = dateFormatter.stringFromDate(date)
        }
        
        return formattedDate
    }
    
    func weatherIconIdentifier() -> String? {
        if let w = weather {
            if(w == 0) {
                return "cloudy_sm"
            } else if(w == 1) {
                return "rain_sm"
            } else {
                return "sunny_sm"
            }
        }
        
        return nil
    }
 

}
