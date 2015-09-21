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
    
    @IBOutlet var recordsTable: UITableView!
    
    weak var detailViewController: DetailViewController?

    var objects = [DiaryRecord]()
    
    var lastClickedRowIndex: Int = -1
    
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
        if(self.lastClickedRowIndex != -1) {
            // We returned from detail controller
            if let detailVC = self.detailViewController {
                if(self.lastClickedRowIndex > objects.endIndex) {
                    objects.append(detailVC.detailItem!)
                } else {
                    objects[lastClickedRowIndex] = detailVC.detailItem!
                }
                if let table = recordsTable {
                    objects.sortInPlace({(dr1: DiaryRecord, dr2: DiaryRecord) -> Bool
                        in return (dr1.creationDate!.compare(dr2.creationDate!) == NSComparisonResult.OrderedDescending)})
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
    }

    func insertNewObject(sender: AnyObject) {
        self.lastClickedRowIndex = objects.endIndex + 1
        self.detailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("detailViewController") as? DetailViewController;
        self.detailViewController?.managedObjectContext = self.managedObjectContext
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
            if let indexPath = self.tableView.indexPathForSelectedRow {
                self.lastClickedRowIndex = indexPath.row
                let object = objects[indexPath.row]
                self.detailViewController = (segue.destinationViewController as! DetailViewController)
                self.detailViewController?.managedObjectContext = self.managedObjectContext
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
    
    func didChooseSetting(selectedSetting: DateSetting?) {
        if let setting = selectedSetting {
            self.dateSetting = setting
            if let table = self.recordsTable {
                table.reloadData()
            }
        }
    }

}

