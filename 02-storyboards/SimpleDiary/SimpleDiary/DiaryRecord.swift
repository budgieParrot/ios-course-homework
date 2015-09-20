//
//  DiaryRecord.swift
//  SimpleDiary
//
//  Created by ADM on 9/18/15.
//  Copyright (c) 2015 Buypass. All rights reserved.
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
        self.weather = Weather.Cloudy
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
    
}
