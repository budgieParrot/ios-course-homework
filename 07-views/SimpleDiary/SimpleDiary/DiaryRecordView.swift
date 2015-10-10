//
//  DiaryRecordView.swift
//  SimpleDiary
//
//  Created by ADM on 10/6/15.
//  Copyright © 2015 Buypass. All rights reserved.
//

import UIKit

class DiaryRecordView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var leftLine: UILabel!
    @IBOutlet weak var rightLine: UILabel!
    
    var record: DiaryRecord? {
        didSet {
            updateRecords()
        }
    }
    
    var shouldHideDate: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.layer.cornerRadius = 0.3 * titleLabel.bounds.size.height
        titleLabel.layer.borderWidth = 1.5
        titleLabel.textAlignment = NSTextAlignment.Center
        
        dateLabel.layer.cornerRadius = 0.3 * titleLabel.bounds.size.height
        dateLabel.layer.borderWidth = 1.5
        dateLabel.textAlignment = NSTextAlignment.Center
        
        weatherImage.layer.cornerRadius = 0.5 * titleLabel.bounds.size.height
        weatherImage.layer.borderWidth = 1.5
        
    }
    
    private func updateRecords() {
        if let rec = record {
            
            dateLabel.text = rec.formattedDateShort()
            dateLabel.layer.borderColor = UIColor.lightGrayColor().CGColor
            
            if let name = rec.name {
                if (!name.isEmpty) {
                    titleLabel.text = name
                } else {
                    titleLabel.hidden = true
                    rightLine.hidden = true
                }
            } else {
                titleLabel.hidden = true
                rightLine.hidden = true
            }
            
            if let w = rec.weather {
                weatherImage.image = UIImage(named: rec.weatherIconIdentifier()!)
                setBorderColorByWeather(w)
            } else {
                weatherImage.hidden = true
                leftLine.hidden = true
            }
        }
    }
    
    private func setBorderColorByWeather(weather:Weather) {
        var color: CGColor?
        switch(weather) {
        case Weather.Cloudy:
            color = UIColor(red: 0.3, green: 0.6, blue: 1.0, alpha: 1.0).CGColor
        case Weather.Rain:
            color = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0).CGColor
        case Weather.Sunny:
            color = UIColor(red: 1.0, green: 0.4, blue: 0.2, alpha: 1.0).CGColor
        }
        
        titleLabel.layer.borderColor = color
        dateLabel.layer.borderColor = color
        weatherImage.layer.borderColor = color
        
        titleLabel.textColor = UIColor(CGColor: color!)
        dateLabel.textColor = UIColor(CGColor: color!)
    }
    
}
