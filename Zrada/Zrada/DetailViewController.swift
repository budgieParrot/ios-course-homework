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
        let step1 = Step(index: 1, description: "Откажитесь сдавать вещи и идите дальше", lawLink: "www.lawlink")
        let step2 = Step(index: 2, description: "В том случае, если охранник препятствует...В том случае, если охранник препятствует...В том случае, если охранник препятствует...В том случае, если охранник препятствует...В том случае, если охранник препятствует...В том случае, если охранник препятствуе!!!!", lawLink: "www.lawlink")
        let s1 = Situation(shortName: "Охранник просит оставить вещи", description: "Охранник настойчиво просит оставить ваши личные вещи в камере хранения или просит показать содержимое...Охранник настойчиво просит оставить ваши личные вещи в камере хранения или просит показать содержимое...", steps: [step1, step2], place: (detailItem! as! Place))
        objects.append(s1)
        objects.append(s1)
        objects.append(s1)
        objects.append(s1)
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

