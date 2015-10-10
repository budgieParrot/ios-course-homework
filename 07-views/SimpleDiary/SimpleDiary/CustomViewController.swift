//
//  CustomViewController.swift
//  SimpleDiary
//
//  Created by ADM on 10/6/15.
//  Copyright © 2015 Buypass. All rights reserved.
//

import UIKit

class CustomViewController: UIViewController {
    
    @IBOutlet weak var customViewContainer: UIView!
    @IBOutlet weak var switchView: UISegmentedControl!
    
    var objectsForEvents = [DiaryRecord]()
    var objectsForTimeline = [DiaryRecord]()
    var diaryRecordViews: [DiaryRecordView] = []
    
    var timeline: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        fillEvents()
        switchView.selectedSegmentIndex = 0
    }
    
    private func setupObjectsForEvents() {
        let cal = NSCalendar.currentCalendar()
        let date1 = NSDateComponents()
        date1.year = 2015
        date1.month = 4
        date1.day = 15
        
        let date2 = NSDateComponents()
        date2.year = 2014
        date2.month = 12
        date2.day = 31
        
        let date3 = NSDateComponents()
        date3.year = 2015
        date3.month = 9
        date3.day = 17
        
        let dr1: DiaryRecord = DiaryRecord(creationDate: cal.dateFromComponents(date1)!)
        dr1.name = "First record"
        dr1.body = "First body text"
        dr1.weather = Weather.Sunny
        
        let dr2: DiaryRecord = DiaryRecord(creationDate: cal.dateFromComponents(date2)!)
        dr2.name = "Second record"
        dr2.body = "Second body text"
        dr2.weather = Weather.Cloudy
        
        let dr3: DiaryRecord = DiaryRecord(creationDate: cal.dateFromComponents(date3)!)
        dr3.name = "Third record"
        dr3.body = "Third body text"
        dr3.weather = Weather.Rain
        
        objectsForEvents.append(dr1);
        objectsForEvents.append(dr2);
        objectsForEvents.append(dr3);
        
        objectsForEvents.sortInPlace({(dr1: DiaryRecord, dr2: DiaryRecord) -> Bool
            in return (dr1.creationDate.compare(dr2.creationDate) == NSComparisonResult.OrderedDescending)})
    }
    
    private func setupObjectsForTimeline() {
        let cal = NSCalendar.currentCalendar()
        let date1 = NSDateComponents()
        date1.year = 2015
        date1.month = 4
        date1.day = 15
        
        let date2 = NSDateComponents()
        date2.year = 2014
        date2.month = 12
        date2.day = 31
        
        let date3 = NSDateComponents()
        date3.year = 2015
        date3.month = 9
        date3.day = 17
        
        let date4 = NSDateComponents()
        date4.year = 2015
        date4.month = 4
        date4.day = 1
        
        let date5 = NSDateComponents()
        date5.year = 2015
        date5.month = 4
        date5.day = 5
        
        let dr1: DiaryRecord = DiaryRecord(creationDate: cal.dateFromComponents(date1)!)
        dr1.name = "First record"
        dr1.body = "First body text"
        dr1.weather = Weather.Sunny
        
        let dr2: DiaryRecord = DiaryRecord(creationDate: cal.dateFromComponents(date2)!)
        dr2.name = "Second record"
        dr2.body = "Second body text"
        dr2.weather = Weather.Cloudy
        
        let dr3: DiaryRecord = DiaryRecord(creationDate: cal.dateFromComponents(date3)!)
        dr3.name = "Third record"
        dr3.body = "Third body text"
        dr3.weather = Weather.Rain
        
        let dr4: DiaryRecord = DiaryRecord(creationDate: cal.dateFromComponents(date4)!)
        let dr5: DiaryRecord = DiaryRecord(creationDate: cal.dateFromComponents(date5)!)
        
        objectsForTimeline.append(dr1);
        objectsForTimeline.append(dr2);
        objectsForTimeline.append(dr3);
        objectsForTimeline.append(dr4);
        objectsForTimeline.append(dr5);
        
        objectsForTimeline.sortInPlace({(dr1: DiaryRecord, dr2: DiaryRecord) -> Bool
            in return (dr1.creationDate.compare(dr2.creationDate) == NSComparisonResult.OrderedDescending)})
    }
    
    private func clearContainer() {
        for v in diaryRecordViews {
            v.removeFromSuperview()
        }
        
        if let t = timeline {
            t.removeFromSuperview()
        }
    }
    
    private func fillEvents() {
        diaryRecordViews = []
        if (objectsForEvents.count == 0) {
            setupObjectsForEvents()
        }
        var origin: CGPoint = customViewContainer.bounds.origin
        
        for (index, _) in objectsForEvents.enumerate() {
            let nib = UINib(nibName: "DiaryRecordView", bundle: nil)
            let nibObjects = nib.instantiateWithOwner(nil, options: nil)
            if (nibObjects.count == 1) {
                if let diaryRecordView = nibObjects[0] as? DiaryRecordView {
                    diaryRecordViews.append(diaryRecordView)
                    origin.y = origin.y + diaryRecordView.frame.height + 20
                    diaryRecordView.frame.origin = origin
                    if (index == objectsForEvents.count - 1) {
                        timeline = UIView(frame: CGRectMake(0, 0, 2.0, diaryRecordView.frame.maxY))
                        timeline!.backgroundColor = UIColor.grayColor()
                        timeline!.frame.origin.x = diaryRecordView.dateLabel.bounds.origin.x + diaryRecordView.dateLabel.bounds.width / 2
                        customViewContainer.insertSubview(timeline!, atIndex: 0)
                        
                    }
                    customViewContainer.addSubview(diaryRecordView)
                }
            }
        }
        
        for (i, diaryRecordView) in diaryRecordViews.enumerate() {
            diaryRecordView.record = objectsForEvents[i]
        }
    }
    
    private func fillTimeline() {
        diaryRecordViews = []
        if (objectsForTimeline.count == 0) {
            setupObjectsForTimeline()
        }
        var origin: CGPoint = customViewContainer.bounds.origin
        
        for (index, _) in objectsForTimeline.enumerate() {
            let nib = UINib(nibName: "DiaryRecordView", bundle: nil)
            let nibObjects = nib.instantiateWithOwner(nil, options: nil)
            if (nibObjects.count == 1) {
                if let diaryRecordView = nibObjects[0] as? DiaryRecordView {
                    diaryRecordViews.append(diaryRecordView)
                    origin.y = origin.y + diaryRecordView.frame.height + 20
                    diaryRecordView.frame.origin = origin
                    if (index == objectsForTimeline.count - 1) {
                        timeline = UIView(frame: CGRectMake(0, 0, 2.0, diaryRecordView.frame.maxY))
                        timeline!.backgroundColor = UIColor.grayColor()
                        timeline!.frame.origin.x = diaryRecordView.dateLabel.bounds.origin.x + diaryRecordView.dateLabel.bounds.width / 2
                        customViewContainer.insertSubview(timeline!, atIndex: 0)
                        
                    }
                    customViewContainer.addSubview(diaryRecordView)
                }
            }
        }

        
        for (i, diaryRecordView) in diaryRecordViews.enumerate() {
            diaryRecordView.record = objectsForTimeline[i]
        }
    }
    
    @IBAction func segmentDidChanged(sender: AnyObject) {
        if let segmentedControl = sender as? UISegmentedControl {
            clearContainer()
            if segmentedControl.selectedSegmentIndex == 0 {
                fillEvents()
            } else {
                fillTimeline()
            }
        }
    }
}
