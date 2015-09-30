//
//  DetailViewController.swift
//  SimpleDiary
//
//  Created by ADM on 9/18/15.
//  Copyright (c) 2015 Buypass. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var titleText: UITextField!
    
    @IBOutlet weak var entryText: UITextView!
    
    @IBOutlet weak var weatherSegments: UISegmentedControl!
    
    var managedObjectContext: NSManagedObjectContext? = nil
    
    var detailItem: DiaryRecord? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func didWeatherChange() {
        NSLog("weather changed: %d", self.weatherSegments.selectedSegmentIndex)
        setBackgroundColor(self.weatherSegments.selectedSegmentIndex)
    }
    
    func setBackgroundColor(segmentIndex: Int) {
        let weather: Weather = Weather(rawValue: segmentIndex)!
        switch weather {
        case Weather.Cloudy:
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg-cloudy")!)
            weatherSegments.tintColor = UIColor.whiteColor()
        case Weather.Rain:
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg-rainy")!)
            weatherSegments.tintColor = UIColor.blackColor()
        case Weather.Sunny:
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg-sunny")!)
            weatherSegments.tintColor = UIColor.blueColor()
        }
    }
    
    private func saveDiaryRecord() {
        NSLog("save diary record")
        if let detail = self.detailItem {
            if let title = self.titleText {
                detail.setValue(title.text, forKey: "name")
            }
            
            if let body = self.entryText {
                detail.setValue(body.text, forKey: "body")
            }
            
            if let weather = self.weatherSegments {
                detail.setValue(weather.selectedSegmentIndex , forKey: "weather")
            }
        }
        
        do {
            try self.managedObjectContext!.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: DiaryRecord = self.detailItem {
            self.navigationItem.title = detail.formattedDateShort()
            
            if let title = self.titleText {
                title.text = detail.name
            }
            
            if let body = self.entryText {
                body.text = detail.body
            }
            
            if let weather = self.weatherSegments {
                weather.selectedSegmentIndex = detail.valueForKey("weather") as! Int
                setBackgroundColor(weather.selectedSegmentIndex)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
//        
        let doneButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "doneButtonClick")
        self.navigationItem.rightBarButtonItem = doneButtonItem
        
        self.weatherSegments.addTarget(self, action: "didWeatherChange", forControlEvents: UIControlEvents.ValueChanged)
        
        if(self.detailItem == nil) {
            self.detailItem = NSEntityDescription.insertNewObjectForEntityForName("DiaryRecord", inManagedObjectContext: managedObjectContext!) as? DiaryRecord
            self.detailItem?.setValue(NSDate(), forKey: "creationDate")
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        saveDiaryRecord()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let entry = entryText {
            entry.becomeFirstResponder()
        }
        
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            if let entry = entryText {
                entry.resignFirstResponder()
            }
        }
        
        return true
    }
    
    func doneButtonClick() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
}

