//
//  DetailViewController.swift
//  SimpleDiary
//
//  Created by ADM on 9/18/15.
//  Copyright (c) 2015 Buypass. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var titleText: UITextField!

    @IBOutlet weak var entryText: UITextField!
    
    @IBOutlet weak var weatherSegments: UISegmentedControl!
    
    var detailItem: DiaryRecord? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func didWeatherChange() {
        NSLog("weather changed: %d", self.weatherSegments.selectedSegmentIndex)
    }
    
    func saveDiaryRecord() {
        NSLog("save diary record")
        if let detail = self.detailItem {
            if let title = self.titleText {
                detail.name = title.text
            }
            
            if let body = self.entryText {
                detail.body = body.text
            }
            
            if let weather = self.weatherSegments {
                detail.weather = Weather(rawValue: weather.selectedSegmentIndex)
            }
        }
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: DiaryRecord = self.detailItem {
            self.navigationItem.title = detail.formattedDate()
            
            if let title = self.titleText {
                title.text = detail.name
            }
            
            if let body = self.entryText {
                body.text = detail.body
            }
            
            if let weather = self.weatherSegments {
                weather.selectedSegmentIndex = detail.weather!.rawValue
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        let doneButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "saveDiaryRecord")
        self.navigationItem.rightBarButtonItem = doneButtonItem
        
        self.weatherSegments.addTarget(self, action: "didWeatherChange", forControlEvents: UIControlEvents.ValueChanged)
        
        if(self.detailItem == nil) {
            self.detailItem = DiaryRecord(creationDate: NSDate())
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

