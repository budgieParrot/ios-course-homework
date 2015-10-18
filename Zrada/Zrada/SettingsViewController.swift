//
//  SettingsViewController.swift
//  Zrada
//
//  Created by ADM on 10/14/15.
//  Copyright © 2015 Anastasiia.Babicheva. All rights reserved.
//

import UIKit
import CoreLocation

class SettingsViewController: UIViewController {
    
    internal let GPS_SETTING_KEY = "gpsSetting"
    
    var locationManager: CLLocationManager?
    
    @IBOutlet weak var gpsSwitch: UISwitch!
    
    @IBAction func gpsSwitchChanged(sender: UISwitch) {
        userDefaults.setBool(sender.on, forKey: GPS_SETTING_KEY)
        userDefaults.synchronize()
        
        if(sender.on) {
            if(CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse) {
                locationManager?.requestWhenInUseAuthorization()
            }
        }
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
