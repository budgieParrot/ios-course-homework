//
//  VideoViewController.swift
//  Zrada
//
//  Created by ADM on 10/29/15.
//  Copyright © 2015 Anastasiia.Babicheva. All rights reserved.
//

import UIKit
import AVFoundation

class FirstPageViewController: UIViewController {
    
    var avPlayer: AVPlayer?
    
    @IBOutlet weak var container: UIView!
    
    @IBAction func didHashTagClicked(sender: AnyObject) {
        let application = UIApplication.sharedApplication()
        application.openURL(NSURL.init(string: "https://twitter.com/search?q=%D0%B7%D1%80%D0%B0%D0%B4%D0%B0&src=typd")!)
    }
    
    @IBAction func didStartButtonClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let path: String = NSBundle.mainBundle().pathForResource("Data/02", ofType: "mp4") {
//            let fileUrl = NSURL(fileURLWithPath: path)
//            let item = AVPlayerItem(URL: fileUrl)
//            self.avPlayer = AVPlayer(playerItem: item)
//            
//            let layer = AVPlayerLayer(player: self.avPlayer)
//            self.avPlayer!.actionAtItemEnd = .None;
//            layer.videoGravity = AVLayerVideoGravityResizeAspect
//            
//            layer.frame = container.bounds
////            layer.bounds = container.bounds
//            container.layer.addSublayer(layer)
//            
//            avPlayer?.play()
//            
//            NSNotificationCenter.defaultCenter().addObserver(self, selector: "movieDidFinishPlaying:", name: AVPlayerItemDidPlayToEndTimeNotification, object: item)
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let path: String = NSBundle.mainBundle().pathForResource("Data/02", ofType: "mp4") {
            let fileUrl = NSURL(fileURLWithPath: path)
            let item = AVPlayerItem(URL: fileUrl)
            self.avPlayer = AVPlayer(playerItem: item)
            
            let layer = AVPlayerLayer(player: self.avPlayer)
            self.avPlayer!.actionAtItemEnd = .None;
            layer.videoGravity = AVLayerVideoGravityResizeAspect
            
            layer.frame = container.bounds
            //            layer.bounds = container.bounds
            container.layer.addSublayer(layer)
            
            avPlayer?.play()
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "movieDidFinishPlaying:", name: AVPlayerItemDidPlayToEndTimeNotification, object: item)
        }
    }
    
    func movieDidFinishPlaying(notification: NSNotification) {
        print("finish")
    }
    
}
