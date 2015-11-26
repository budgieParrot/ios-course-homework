//
//  MasterViewController.swift
//  Zrada
//
//  Created by ADM on 10/13/15.
//  Copyright © 2015 Anastasiia.Babicheva. All rights reserved.
//

import UIKit
import AVFoundation

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    
    var objects = [Place]()
    var situationsCache: [Situation]?
    
    var audioRecorder: AVAudioRecorder?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupObjects()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "record"), style: UIBarButtonItemStyle.Plain, target: self, action: "startRecord")
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.redColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let recorder = audioRecorder {
            if (recorder.recording) {
                UIView.animateWithDuration(0.2, animations: {
                    self.navigationItem.rightBarButtonItem?.image = UIImage(named: "stop")
                    self.navigationItem.rightBarButtonItem?.tintColor = UIColor.blackColor()
                })
                self.navigationItem.rightBarButtonItem?.action = "stopRecord"
            } else {
                UIView.animateWithDuration(0.2, animations: {
                    self.navigationItem.rightBarButtonItem?.image = UIImage(named: "record")
                    self.navigationItem.rightBarButtonItem?.tintColor = UIColor.redColor()
                })
                self.navigationItem.rightBarButtonItem?.action = "startRecord"
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
    
    func startRecord() {
        NSLog("in start record")
        UIView.animateWithDuration(0.2, animations: {
            self.navigationItem.rightBarButtonItem?.image = UIImage(named: "stop")
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.blackColor()
        })
        self.navigationItem.rightBarButtonItem?.action = "stopRecord"
        
        (parentViewController?.parentViewController as? TabBarViewController)?.startRecord()
    }
    
    func stopRecord() {
        UIView.animateWithDuration(0.2, animations: {
            self.navigationItem.rightBarButtonItem?.image = UIImage(named: "record")
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.redColor()
        })
        self.navigationItem.rightBarButtonItem?.action = "startRecord"
        
        (parentViewController?.parentViewController as? TabBarViewController)?.stopRecord()
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destinationViewController as! DetailViewController)
                controller.detailItem = object
                controller.navigationItem.leftItemsSupplementBackButton = true
                controller.audioRecorder = self.audioRecorder
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

}

