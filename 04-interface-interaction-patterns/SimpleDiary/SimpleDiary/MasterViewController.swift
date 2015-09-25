//
//  MasterViewController.swift
//  SimpleDiary
//
//  Created by ADM on 9/18/15.
//  Copyright (c) 2015 Buypass. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, SettingsViewDelegate {
    
    private let TODAY = "Today"
    private let THIS_WEEK = "This week"
    private let THIS_MONTH = "This month"
    private let EARLIER = "Earlier"
    
    @IBOutlet var recordsTable: UITableView!
    
    weak var detailViewController: DetailViewController?

    var objects = [DiaryRecord]()
    
    var sortedObjects:NSMutableDictionary?
    
    var lastClickedRowIndex: NSIndexPath?
    
    var dateSetting: DateSetting = DateSetting.ShortFormat
    
    var managedObjectContext: NSManagedObjectContext? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings"), style: UIBarButtonItemStyle.Plain, target: self, action: "openSettings")

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        
        setupObjects()
    }
    
    override func viewDidAppear(animated: Bool) {
        NSLog("in viewDidAppear")
        if let detailVC = self.detailViewController {
            // We returned from detail controller
            if let indexPath = self.lastClickedRowIndex {
                let header = getHeaderForSection(indexPath.section)
                var objects = sortedObjects?.objectForKey(header) as! [DiaryRecord]
                objects[indexPath.row] = detailVC.detailItem!
                self.lastClickedRowIndex = nil
            } else {
                self.objects.append(detailVC.detailItem!)
            }
            
            if let table = recordsTable {
                self.objects.sortInPlace({(dr1: DiaryRecord, dr2: DiaryRecord) -> Bool
                    in return (dr1.creationDate!.compare(dr2.creationDate!) == NSComparisonResult.OrderedDescending)})
                sortedObjects = sortBySections()
                table.reloadData()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupObjects() {
        let moc = self.managedObjectContext
        let employeesFetch = NSFetchRequest(entityName: "DiaryRecord")
        
        do {
            let records = try moc!.executeFetchRequest(employeesFetch) as! [DiaryRecord]
            objects = records
        } catch {
            fatalError("Failed to fetch records: \(error)")
        }
        
        objects.sortInPlace({(dr1: DiaryRecord, dr2: DiaryRecord) -> Bool
            in return ((dr1.valueForKey("creationDate") as! NSDate).compare(dr2.valueForKey("creationDate") as! NSDate) == NSComparisonResult.OrderedDescending)})
        sortedObjects = sortBySections()
    }
    
    private func saveObjects() {
        do {
            try self.managedObjectContext!.save()
        } catch {
            fatalError("Failure to save diary records: \(error)")
        }

    }

    func insertNewObject(sender: AnyObject) {
        self.detailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("detailViewController") as? DetailViewController;
        self.detailViewController?.managedObjectContext = self.managedObjectContext
        self.navigationController?.pushViewController(self.detailViewController!, animated: true);
    }
    
    func openSettings() {
        NSLog("in openSettings")
        let settingsNavController = self.storyboard?.instantiateViewControllerWithIdentifier("settingsNavController") as! UINavigationController
        
        let settingsViewController = settingsNavController.topViewController as! SettingsViewController
        settingsViewController.delegate = self
        settingsViewController.selectedSetting = dateSetting
        settingsViewController.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        settingsViewController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        
        presentViewController(settingsNavController, animated: true, completion: nil)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                self.lastClickedRowIndex = NSIndexPath(forRow: indexPath.row, inSection: indexPath.section)
                NSLog("lastClickedRow %d", indexPath.row)
                let header = getHeaderForSection(indexPath.section)
                let objects = sortedObjects?.objectForKey(header) as! [DiaryRecord]
                let object = objects[indexPath.row]
                self.detailViewController = (segue.destinationViewController as! DetailViewController)
                self.detailViewController?.managedObjectContext = self.managedObjectContext
            (segue.destinationViewController as! DetailViewController).detailItem = object
            }
        }
    }
    
    private func sortBySections() -> NSMutableDictionary {
        var today = [DiaryRecord]()
        var thisWeek = [DiaryRecord]()
        var thisMonth = [DiaryRecord]()
        var earlier = [DiaryRecord]()
        for item in objects {
            if(isDateInThisUnitRange(item.creationDate!, calendarUnit:NSCalendarUnit.Day)) {
                NSLog("today")
                today.append(item)
            } else if(isDateInThisUnitRange(item.creationDate!, calendarUnit:NSCalendarUnit.WeekOfMonth)) {
                NSLog("this week")
                thisWeek.append(item)
            } else if(isDateInThisUnitRange(item.creationDate!, calendarUnit: NSCalendarUnit.Month)) {
                NSLog("this month")
                thisMonth.append(item)
            } else {
                NSLog("earlier")
                earlier.append(item)
            }
        }
        
        let diaryRecords = NSMutableDictionary()
        if(today.count > 0) {
            diaryRecords.setObject(today, forKey: TODAY)
        }
        
        if(thisWeek.count > 0) {
            diaryRecords.setObject(thisWeek, forKey: THIS_WEEK)
        }
        
        if(thisMonth.count > 0) {
            diaryRecords.setObject(thisMonth, forKey: THIS_MONTH)
        }
        
        if(earlier.count > 0) {
            diaryRecords.setObject(today, forKey: EARLIER)
        }
        
        return diaryRecords
        
    }
    
    private func isDateInThisUnitRange(date:NSDate, calendarUnit:NSCalendarUnit) -> Bool {
        var start:NSDate? = nil
        var extends:NSTimeInterval = 0
        let cal = NSCalendar.autoupdatingCurrentCalendar()
        let today = NSDate()
        let success = cal.rangeOfUnit(calendarUnit, startDate: &start, interval: &extends, forDate: today)
        
        if(!success) {
            return false
        }
        
        let dateInSecs = date.timeIntervalSinceReferenceDate
        let dayStartInSecs = start!.timeIntervalSinceReferenceDate
        if(dateInSecs > dayStartInSecs && dateInSecs < (dayStartInSecs+extends)){
            return true;
        } else {
            return false;
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let objects = sortedObjects {
            return objects.count
        }
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let header = getHeaderForSection(section)
        if(header != "") {
            return (sortedObjects?.objectForKey(header)?.count)!
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        if let diaryRecordCell = cell as? DiaryRecordCell {
            let header = getHeaderForSection(indexPath.section)
            var objects = sortedObjects?.objectForKey(header) as! [DiaryRecord]
            let object:DiaryRecord = objects[indexPath.row]
            diaryRecordCell.titleLabel.text = object.name
            diaryRecordCell.entryLabel.text = object.body
            diaryRecordCell.dateLabel.text = self.dateSetting.rawValue == DateSetting.ShortFormat.rawValue ? object.formattedDateShort() : object.formattedDateLong()
            diaryRecordCell.weatherImage.image = UIImage(named: object.weatherIconIdentifier()!)
        }
        
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let header = getHeaderForSection(indexPath.section)
            var objects = sortedObjects?.objectForKey(header) as! [DiaryRecord]
            self.managedObjectContext?.deleteObject(objects[indexPath.row])
            saveObjects()
            setupObjects()
            
            tableView.reloadData()
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let header = getHeaderForSection(section)
        if(header != "") {
            return header
        }
        return nil
    }
    
    private func getHeaderForSection(section:Int) -> String {
        switch(section) {
        case 0:
            if(sortedObjects?.objectForKey(TODAY) != nil) {
                return TODAY
            } else {
                if(sortedObjects?.objectForKey(THIS_WEEK) != nil) {
                    return THIS_WEEK
                } else {
                    if(sortedObjects?.objectForKey(THIS_MONTH) != nil) {
                        return THIS_MONTH
                    } else {
                        return EARLIER
                    }
                }
            }
        case 1:
            if(sortedObjects?.objectForKey(THIS_WEEK) != nil) {
                return THIS_WEEK
            } else {
                if(sortedObjects?.objectForKey(THIS_MONTH) != nil) {
                    return THIS_MONTH
                } else {
                    return EARLIER
                }
            }
        case 2:
            if(sortedObjects?.objectForKey(THIS_MONTH) != nil) {
                return THIS_MONTH
            } else {
                return EARLIER
            }
        case 3:
            return EARLIER
        default:
            return ""
        }
    }
    
    func didChooseSetting(selectedSetting: DateSetting?) {
        if let setting = selectedSetting {
            self.dateSetting = setting
            if let table = self.recordsTable {
                table.reloadData()
            }
        }
    }

}

