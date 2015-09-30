//
//  SettingsViewController.swift
//  SimpleDiary
//
//  Created by ADM on 9/19/15.
//  Copyright (c) 2015 Buypass. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    internal let DATE_SETTING_KEY = "dateSetting"
    
    var selectedSetting: Int?
    
    var selectedIndexPath: NSIndexPath?
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedSetting = userDefaults.integerForKey(DATE_SETTING_KEY)
        
        selectedIndexPath = NSIndexPath(forRow: selectedSetting!, inSection: 0)
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        
        if(indexPath == selectedIndexPath) {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("didSelectRow")
        selectedSetting = indexPath.row
        
        selectedIndexPath = indexPath
        tableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        userDefaults.setInteger(self.selectedSetting!, forKey: DATE_SETTING_KEY)
        userDefaults.synchronize()
    }
    
}
