//
//  MasterViewController.swift
//  Zrada
//
//  Created by ADM on 10/13/15.
//  Copyright © 2015 Anastasiia.Babicheva. All rights reserved.
//

import UIKit
import CoreLocation

class MasterViewController: UITableViewController, CLLocationManagerDelegate {

    var detailViewController: DetailViewController? = nil
    var objects = [Place]()
    let locationManager: CLLocationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "settings"), style: UIBarButtonItemStyle.Plain, target: self, action: "openSettings")
        
        setupObjects()
        getCurrentLocation()
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupObjects() {
        if let path: String = NSBundle.mainBundle().pathForResource("Data/places", ofType: "json") {
            if let json = NSData(contentsOfFile: path) {
                do {
                    let parsed: NSDictionary = try NSJSONSerialization.JSONObjectWithData(json, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                    print(parsed)
                    let array: NSArray = parsed["places"] as! NSArray
                    for item in array {
                        let name: String = item["name"] as! String
                        let id: Int = Int(item["id"] as! String)!
                        objects.append(Place(name: name, id: id))
                    }
                } catch let error as NSError {
                    // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                    print("A JSON parsing error occurred, here are the details:\n \(error)")
                }
            }
        }
    }
    
    func openSettings() {
        NSLog("in openSettings")
        let settingsNavController = self.storyboard?.instantiateViewControllerWithIdentifier("settingsNavController") as! UINavigationController
        
        let settingsViewController = settingsNavController.topViewController as! SettingsViewController
        settingsViewController.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        settingsViewController.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        settingsViewController.locationManager = self.locationManager
        
        presentViewController(settingsNavController, animated: true, completion: nil)
    }
    
    private func getCurrentLocation() {
        if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.distanceFilter = 500;
            
            locationManager.startUpdatingLocation()
        }
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
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
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    // MARK: - Location
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        NSLog("got location")
        let geocoder = CLGeocoder()
        if (locations.count > 0) {
            geocoder.reverseGeocodeLocation(locations[0], completionHandler:
                {(placemarks: [CLPlacemark]?, error: NSError?) in
                    if error == nil && placemarks!.count > 0 {
                        for pm in placemarks! {
                            let v = pm.locality
                        }
                    }
            })
        }
    }

}

