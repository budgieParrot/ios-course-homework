//
//  DatePickerViewController.swift
//  SimpleDiary
//
//  Created by ADM on 9/25/15.
//  Copyright © 2015 Buypass. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func didDateSelected(sender: AnyObject) {
        if let del = delegate {
            del.didDateSelected((sender as! UIDatePicker).date)
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    let currentRecordDate: NSDate?
    
    let delegate: DatePickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let date = currentRecordDate {
            datePicker!.date = date
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
