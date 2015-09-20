//
//  MasterViewController.swift
//  SimpleDiary
//
//  Created by ADM on 9/18/15.
//  Copyright (c) 2015 Buypass. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, SettingsViewDelegate {
    
    @IBOutlet var recordsTable: UITableView!
    
    weak var detailViewController: DetailViewController?

    var objects = [DiaryRecord]()
    
    var lastClickedRowIndex: Int = -1
    
    var dateSetting: DateSetting = DateSetting.ShortFormat

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
        if(self.lastClickedRowIndex != -1) {
            // We returned from detail controller
            if let detailVC = self.detailViewController {
                if(self.lastClickedRowIndex > objects.endIndex) {
                    objects.append(detailVC.detailItem!)
                } else {
                    objects[lastClickedRowIndex] = detailVC.detailItem!
                }
                if let table = recordsTable {
                    objects.sort({(dr1: DiaryRecord, dr2: DiaryRecord) -> Bool
                        in return (dr1.creationDate.compare(dr2.creationDate) == NSComparisonResult.OrderedDescending)})
                    table.reloadData()
                }
                
                self.lastClickedRowIndex = -1
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupObjects() {
        var cal = NSCalendar.currentCalendar()
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
        
        var dr1: DiaryRecord = DiaryRecord(creationDate: cal.dateFromComponents(date1)!)
        dr1.name = "First record"
        dr1.body = "First body text"
        dr1.weather = Weather.Sunny
        
        var dr2: DiaryRecord = DiaryRecord(creationDate: cal.dateFromComponents(date2)!)
        dr2.name = "Second record"
        dr2.body = "Second body text"
        
        var dr3: DiaryRecord = DiaryRecord(creationDate: cal.dateFromComponents(date3)!)
        dr3.name = "Third record"
        dr3.body = "Third body text"
        
        objects.append(dr1);
        objects.append(dr2);
        objects.append(dr3);
        
        objects.sort({(dr1: DiaryRecord, dr2: DiaryRecord) -> Bool
            in return (dr1.creationDate.compare(dr2.creationDate) == NSComparisonResult.OrderedDescending)})
    }

    func insertNewObject(sender: AnyObject) {
        self.lastClickedRowIndex = objects.endIndex + 1
        self.detailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("detailViewController") as? DetailViewController;
        self.navigationController?.pushViewController(self.detailViewController!, animated: true);
    }
    
    func openSettings() {
        NSLog("in openSettings")
        let settingsNavController = self.storyboard?.instantiateViewControllerWithIdentifier("settingsNavController") as! UINavigationController
        
        let settingsViewController = settingsNavController.topViewController as! SettingsViewController
        settingsViewController.delegate = self
        settingsViewController.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        settingsViewController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        
        presentViewController(settingsNavController, animated: true, completion: nil)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                self.lastClickedRowIndex = indexPath.row
                let object = objects[indexPath.row]
                self.detailViewController = (segue.destinationViewController as! DetailViewController)
            (segue.destinationViewController as! DetailViewController).detailItem = object
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        let object = objects[indexPath.row]
        cell.textLabel!.text = object.name
        
        if let readableDate = humanReadableDate(object.creationDate) {
            cell.detailTextLabel!.text = readableDate
        } else {
            let date: String
            self.dateSetting.rawValue == DateSetting.ShortFormat.rawValue ? (date = object.formattedDateShort()) : (date = object.formattedDateLong())
            cell.detailTextLabel!.text = date
        }
        
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func humanReadableDate(date: NSDate) -> String? {
        var formatted: String?
        
        let currentCal = NSCalendar.currentCalendar()
        let dateCal = NSCalendar.currentCalendar()
        
        let currentComponents = currentCal.components(NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute, fromDate: NSDate())
        let dateComponents = dateCal.components(NSCalendarUnit.CalendarUnitYear | NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitHour | NSCalendarUnit.CalendarUnitMinute, fromDate: date)
        
        if(dateComponents.year == currentComponents.year && dateComponents.month == currentComponents.month) {
            if(dateComponents.day == currentComponents.day) {
                if(dateComponents.hour == currentComponents.hour) {
                    if(dateComponents.minute == currentComponents.minute) {
                        formatted = "Just now"
                    } else {
                        formatted = String(format: "%d minutes ago", (currentComponents.minute - dateComponents.minute))
                    }
                } else {
                    formatted = String(format: "%d hours ago", (currentComponents.hour - dateComponents.hour))
                }
            } else {
                if(currentComponents.day - dateComponents.day == 1) {
                    formatted = "Yesterday"
                }
            }
        }
        
        return formatted
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

