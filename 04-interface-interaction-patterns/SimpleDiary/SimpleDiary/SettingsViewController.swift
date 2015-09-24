//
//  SettingsViewController.swift
//  SimpleDiary
//
//  Created by ADM on 9/19/15.
//  Copyright (c) 2015 Buypass. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    var selectedSetting: DateSetting?
    
    var selectedIndexPath: NSIndexPath?
    
    var delegate: SettingsViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "selectSetting")
        
        selectedIndexPath = NSIndexPath(forRow: selectedSetting!.rawValue, inSection: 0)
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
        selectedSetting = DateSetting(rawValue: indexPath.row)
        
        selectedIndexPath = indexPath
        tableView.reloadData()
    }
    
    func selectSetting() {
        if let delegate = self.delegate {
            delegate.didChooseSetting(self.selectedSetting)
        }
        
        dismissViewControllerAnimated(false, completion: nil)
    }
    
}
