//
//  File.swift
//  SimpleDiary
//
//  Created by ADM on 10/2/15.
//  Copyright © 2015 Buypass. All rights reserved.
//

import UIKit

class SearchResultsViewController: UITableViewController {
    
    var records: [DiaryRecord] = [] {
        didSet {
            tableView?.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "SearchResultsViewController.Cell")
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
        return records.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchResultsViewController.Cell", forIndexPath: indexPath)
        
        let record = records[indexPath.row]
        cell.textLabel?.text = record.name
        
        return cell
    }
    
}
