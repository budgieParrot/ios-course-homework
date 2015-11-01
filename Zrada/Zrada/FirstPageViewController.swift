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
    var secondView: UIView?
    var layer: AVPlayerLayer?
    
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path: String = NSBundle.mainBundle().pathForResource("Data/02", ofType: "mp4") {
            let fileUrl = NSURL(fileURLWithPath: path)
            let item = AVPlayerItem(URL: fileUrl)
            self.avPlayer = AVPlayer(playerItem: item)
            
            layer = AVPlayerLayer(player: self.avPlayer)
            self.avPlayer!.actionAtItemEnd = .None;
            
            layer!.frame = CGRectMake(0, 0, container.frame.width, container.frame.height)
            container.layer.addSublayer(layer!)
            
            avPlayer?.play()
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "movieDidFinishPlaying:", name: AVPlayerItemDidPlayToEndTimeNotification, object: item)
            
            secondView = UIView(frame: self.view.frame)
            secondView?.frame.origin.x = self.view.frame.origin.x
            secondView?.frame.origin.y = self.view.frame.origin.y + self.view.frame.size.height
            secondView?.backgroundColor = UIColor.redColor()
            self.view.addSubview(secondView!)
        }
    }
    
    func movieDidFinishPlaying(notification: NSNotification) {
        print("finish")
        UIView.animateWithDuration(1.5, animations: {
            self.performSegueWithIdentifier("showSecondPageView", sender: self)
        })
    }
    
}
