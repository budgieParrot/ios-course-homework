//
//  SettingsViewController.swift
//  Zrada
//
//  Created by ADM on 10/14/15.
//  Copyright © 2015 Anastasiia.Babicheva. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    internal let GPS_SETTING_KEY = "gpsSetting"
    
    @IBOutlet weak var gpsSwitch: UISwitch!
    
    @IBAction func gpsSwitchChanged(sender: UISwitch) {
        userDefaults.setBool(sender.on, forKey: GPS_SETTING_KEY)
        userDefaults.synchronize()
    }
    
    var gpsEnabled: Bool = false
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gpsEnabled = userDefaults.boolForKey(GPS_SETTING_KEY)
        gpsSwitch.on = gpsEnabled
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Готово", style: UIBarButtonItemStyle.Done, target: self, action: "selectSetting")
    }
    
    func selectSetting() {
        dismissViewControllerAnimated(false, completion: nil)
    }
    
}
