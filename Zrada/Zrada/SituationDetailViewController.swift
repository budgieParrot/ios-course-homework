//
//  SituationDetailViewController.swift
//  Zrada
//
//  Created by ADM on 10/17/15.
//  Copyright © 2015 Anastasiia.Babicheva. All rights reserved.
//

import UIKit

class SituationDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,
    SituationDetailCellDelegate {
    
    
    @IBOutlet weak var situationDescription: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var situationDescriptionString: String?
    var steps = [Step]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let description = situationDescriptionString {
            situationDescription.text = description
        }
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
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
