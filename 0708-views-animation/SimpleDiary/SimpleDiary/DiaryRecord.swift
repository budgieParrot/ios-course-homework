//
//  DiaryRecord.swift
//  SimpleDiary
//
//  Created by ADM on 9/21/15.
//  Copyright © 2015 Buypass. All rights reserved.
//

import Foundation

class DiaryRecord {
    
    let creationDate: NSDate
    var name: String?
    var body: String?
    var tags = [String]()
    var weather: Weather?
    
    init(creationDate: NSDate) {
        self.creationDate = creationDate
        self.name = ""
        self.body = ""
    }
    
    func formattedDateShort() -> String {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.doesRelativeDateFormatting = true
        let formattedDate = dateFormatter.stringFromDate(creationDate)
        
        return formattedDate
    }
    
    func formattedDateLong() -> String {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateFormatter.doesRelativeDateFormatting = true
        let formattedDate = dateFormatter.stringFromDate(creationDate)
        
        return formattedDate
    }
    
    func weatherIconIdentifier() -> String? {
        if let w = weather {
            if(w.rawValue == 0) {
                return "cloudy_sm"
            } else if(w.rawValue == 1) {
                return "rain_sm"
            } else {
                return "sunny_sm"
            }
        }
        
        return nil
    }
    
}
