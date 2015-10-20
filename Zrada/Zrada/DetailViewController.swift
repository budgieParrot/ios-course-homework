//
//  DetailViewController.swift
//  Zrada
//
//  Created by ADM on 10/13/15.
//  Copyright © 2015 Anastasiia.Babicheva. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {

    var objects = [Situation]()
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
            setupObjects()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            self.navigationItem.title = (detail as! Place).name
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupObjects() {
        if let path: String = NSBundle.mainBundle().pathForResource("Data/situations", ofType: "json") {
            if let json = NSData(contentsOfFile: path) {
                do {
                    let parsed: NSDictionary = try NSJSONSerialization.JSONObjectWithData(json, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                    print(parsed)
                    let situationsArray: NSArray = parsed["situations"] as! NSArray
                    for item in situationsArray {
                        var steps = [Step]()
                        if let stepsArray: NSArray = item["steps"] as? NSArray {
                            for step in stepsArray {
                                let index: Int = Int(step["index"] as! String)!
                                let description = step["description"] as! String
                                let lawLink = step["lawLink"] as! String
                                steps.append(Step(index: index, description: description, lawLink: lawLink))
                            }
                        }
                        let shortName = item["shortName"] as! String
                        let description = item["description"] as! String
                        let place = Int(item["place"] as! String)
                        objects.append(Situation(shortName: shortName, description: description, steps: steps, place: place!))
                    }
                } catch let error as NSError {
                    // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                    print("A JSON parsing error occurred, here are the details:\n \(error)")
                }
            }
        }
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! SituationDetailViewController
                controller.situationDescriptionString = object.description!
                controller.steps = object.steps!
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
        let cell = tableView.dequeueReusableCellWithIdentifier("SituationCell", forIndexPath: indexPath)
        
        let object = objects[indexPath.row]
        cell.textLabel!.text = object.shortName
        cell.detailTextLabel!.text = object.description
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }


}

