//
//  DetailViewController.swift
//  Zrada
//
//  Created by ADM on 10/13/15.
//  Copyright © 2015 Anastasiia.Babicheva. All rights reserved.
//

import UIKit
import AVFoundation

class DetailViewController: SearchResultsViewController, UISearchResultsUpdating,
    UISearchControllerDelegate {

    var objects = [Situation]()
    var audioRecorder: AVAudioRecorder?
    
    var resultsTableController: SearchResultsViewController?
    var searchController: UISearchController?
    
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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "record"), style: UIBarButtonItemStyle.Plain, target: self, action: "startRecord")
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.redColor()
        
        let rc = SearchResultsViewController()
        resultsTableController = rc
        // We want to be the delegate for our filtered table so didSelectRowAtIndexPath(_:) is called for both tables.
        rc.tableView.delegate = self
        
        let sc = UISearchController(searchResultsController: resultsTableController)
        searchController = sc
        sc.searchResultsUpdater = self
        sc.searchBar.sizeToFit()
        tableView.tableHeaderView = sc.searchBar
        
        sc.delegate = self
        sc.searchResultsUpdater = self
        
        definesPresentationContext = true
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
                let controller = (segue.destinationViewController as! SituationDetailViewController)
                controller.situationDescriptionString = object.description!
                controller.steps = object.steps!
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let resultsController = resultsTableController
            where tableView == resultsController.tableView {
                let situation: Situation = resultsController.situations[indexPath.row]
                self.tableView?.selectRowAtIndexPath(NSIndexPath(forRow: objects.indexOf({$0.description! == situation.description!})!, inSection: 1), animated: false, scrollPosition: .None)
                self.performSegueWithIdentifier("showDetail", sender: nil)
        }
    }

    // MARK: Search
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchKey: String
        if let text = searchController.searchBar.text {
            searchKey = text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        } else {
            searchKey = ""
        }
    
        let searchResults = recordsWithNameStarting(searchKey)
        resultsTableController?.situations = searchResults
    }
    
    private func recordsWithNameStarting(namePrefix: String) -> [Situation] {
        let array = objects.filter() { self.hasCaseInsensitivePrefix($0.description!, $0.steps!, namePrefix) }
        return array
    }
    
    private func hasCaseInsensitivePrefix(description: String, _ steps: [Step], _ prefix: String) -> Bool {
        var isInDesc = false
        var isInSteps = false
        
        print("prefix: ", prefix)
        print("description: ", description)
        if let _ = description.rangeOfString(prefix, options: [.CaseInsensitiveSearch], range: nil, locale: nil) {
            isInDesc = true
        }
        
        for step in steps {
            print("step: ", step.description)
            if let _ = step.description!.rangeOfString(prefix, options: [.CaseInsensitiveSearch], range: nil, locale: nil) {
                print("prefix: ", prefix, " found in step: ", step.description)
                isInSteps = true
                break
            }
        }
        
        if (isInDesc || isInSteps) {
            return true
        }
        
        return false
    }

}

