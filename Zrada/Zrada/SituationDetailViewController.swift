//
//  SituationDetailViewController.swift
//  Zrada
//
//  Created by ADM on 10/17/15.
//  Copyright © 2015 Anastasiia.Babicheva. All rights reserved.
//

import UIKit
import AVFoundation

class SituationDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,
    SituationDetailCellDelegate {
    
    
    @IBOutlet weak var situationDescription: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var situationDescriptionString: String?
    var steps = [Step]()
    
    var audioRecorder: AVAudioRecorder?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let description = situationDescriptionString {
            situationDescription.text = description
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "record"), style: UIBarButtonItemStyle.Plain, target: self, action: "startRecord")
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.redColor()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let recorder = audioRecorder {
            if (recorder.recording) {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "stop"), style: UIBarButtonItemStyle.Plain, target: self, action: "stopRecord")
                self.navigationItem.rightBarButtonItem?.tintColor = UIColor.blackColor()
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
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return steps.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SituationDetailCell", forIndexPath: indexPath) as! SituationDetailCell
        
        let object = steps[indexPath.row]
        cell.stepLabel.text = object.index?.description
        cell.descriptionText.text = object.description
        cell.delegate = self
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    func didPressLawButton(cell: SituationDetailCell?) {
        if let c = cell {
            let indexPath = self.tableView.indexPathForCell(c)
            let application = UIApplication.sharedApplication()
            application.openURL(NSURL.init(string: steps[(indexPath?.row)!].lawLink!)!)
        }
    }
    
}
