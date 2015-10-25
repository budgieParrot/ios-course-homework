//
//  SearchResultsViewController.swift
//  Zrada
//
//  Created by ADM on 10/24/15.
//  Copyright © 2015 Anastasiia.Babicheva. All rights reserved.
//

import UIKit

class SearchResultsViewController: UITableViewController {
    
    var situations: [Situation] = [] {
        didSet {
            tableView?.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "SituationCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TableView
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return situations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("SituationCell")
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "SituationCell")
        }
        
        let situation = situations[indexPath.row]
        cell!.textLabel?.text = situation.shortName
        cell!.detailTextLabel!.text = situation.description
        
        return cell!
    }
}
