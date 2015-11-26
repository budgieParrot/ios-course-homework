//
//  SecondPageViewController.swift
//  Zrada
//
//  Created by ADM on 10/29/15.
//  Copyright © 2015 Anastasiia.Babicheva. All rights reserved.
//

import UIKit

class SecondPageViewController: UIViewController {
    
    @IBAction func didBeginButtonClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil);
    }
    
    @IBAction func hashtagDidClicked(sender: AnyObject) {
        let application = UIApplication.sharedApplication()
        application.openURL(NSURL.init(string: "https://twitter.com/search?q=%D0%B7%D1%80%D0%B0%D0%B4%D0%B0&src=typd")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
