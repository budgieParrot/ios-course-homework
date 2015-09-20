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
    
    var delegate: SettingsViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "selectSetting")
        
        self.tableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.None)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("didSelectRow")
        selectedSetting = DateSetting(rawValue: indexPath.row)
    }
    
    func selectSetting() {
        if let delegate = self.delegate {
            delegate.didChooseSetting(self.selectedSetting)
        }
        
        dismissViewControllerAnimated(false, completion: nil)
    }
    
}
