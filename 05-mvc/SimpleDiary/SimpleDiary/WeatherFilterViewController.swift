//
//  WeatherFilterViewController.swift
//  SimpleDiary
//
//  Created by ADM on 10/2/15.
//  Copyright © 2015 Buypass. All rights reserved.
//

import UIKit
import CoreData

class WeatherFilterViewController: UITableViewController {
    
    @IBOutlet var recordsTable: UITableView!
    
    weak var detailViewController: DetailViewController?
    
    var objects = [DiaryRecord]()
    
    var lastClickedRowIndex: NSIndexPath?
    
    var dateSetting: DateSetting = DateSetting.ShortFormat
    
    var header: UISegmentedControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let notificationsCenter = NSNotificationCenter.defaultCenter()
        notificationsCenter.addObserver(self, selector: "dateSettingChanged:", name: NSUserDefaultsDidChangeNotification, object: nil)
        
        setupObjects()
        addHeaderToTableView()
    }
    
    override func viewDidAppear(animated: Bool) {
        NSLog("in viewDidAppear")
        if(detailViewController != nil) {
            setupObjects()
            if let table = recordsTable {
                table.reloadData()
            }
        }
    }
    
    private func addHeaderToTableView() {
        let segments = [UIImage(named: "cloudy_sm")!, UIImage(named: "rain_sm")!, UIImage(named: "sunny_sm")!]
        header = UISegmentedControl(items: segments)
        header!.addTarget(self, action: "didWeatherChange", forControlEvents: UIControlEvents.ValueChanged)
        if let table = recordsTable {
            table.tableHeaderView = header
        }
    }
    
    func didWeatherChange() {
        setupObjects()
        if let h = header {
            let filtered = objects.filter() {$0.weather == h.selectedSegmentIndex}
            objects = filtered
            if let table = recordsTable {
                table.reloadData()
            }
        }
    }
    
    private func setupObjects() {
        let moc = MOCHelper.sharedInstance.moc
        let employeesFetch = NSFetchRequest(entityName: "DiaryRecord")
        
        do {
            let records = try moc!.executeFetchRequest(employeesFetch) as! [DiaryRecord]
            objects = records
        } catch {
            fatalError("Failed to fetch records: \(error)")
        }
        
        objects.sortInPlace({(dr1: DiaryRecord, dr2: DiaryRecord) -> Bool
            in return ((dr1.valueForKey("creationDate") as! NSDate).compare(dr2.valueForKey("creationDate") as! NSDate) == NSComparisonResult.OrderedDescending)})
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        dateSetting = DateSetting(rawValue: userDefaults.integerForKey("dateSetting"))!
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                self.lastClickedRowIndex = indexPath
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
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        let object = objects[indexPath.row]
        cell.textLabel!.text = object.name
        
        
        let date: String
        self.dateSetting.rawValue == DateSetting.ShortFormat.rawValue ? (date = object.formattedDateShort()) : (date = object.formattedDateLong())
        cell.detailTextLabel!.text = date
        
        
        return cell
    }
    
    func dateSettingChanged(notification: NSNotification) {
        if let userDefaults = notification.object as? NSUserDefaults {
            self.dateSetting = DateSetting(rawValue: userDefaults.integerForKey("dateSetting"))!
            if let table = self.recordsTable {
                table.reloadData()
            }
        }
    }
    
}
