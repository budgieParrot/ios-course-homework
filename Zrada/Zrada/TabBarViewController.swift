//
//  TabBarViewController.swift
//  Zrada
//
//  Created by ADM on 10/22/15.
//  Copyright © 2015 Anastasiia.Babicheva. All rights reserved.
//

import UIKit
import AVFoundation

class TabBarViewController: UITabBarController, AVAudioRecorderDelegate,
    AVAudioPlayerDelegate, UITabBarControllerDelegate {
    
    internal let FTR_SETTING_KEY = "didUserLaunchedAppBefore"
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let didUserLaunchedAppBefore = userDefaults.boolForKey(FTR_SETTING_KEY)
        
        if (!didUserLaunchedAppBefore) {
            self.performSegueWithIdentifier("showFirstTimeRunView", sender: self)
            userDefaults.setBool(true, forKey: FTR_SETTING_KEY)
        } 
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        ((viewController as? UINavigationController)?.topViewController as? MasterViewController)?
            .audioRecorder = self.audioRecorder
    }
    
    // MARK - Audio
    
    func startRecord() {
        NSLog("in start record")
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord,
                withOptions: .DuckOthers)
            do {
                try session.setActive(true)
                print("Successfully activated the audio session")
                
                session.requestRecordPermission{allowed in
                    
                    if allowed{
                        self.startRecordingAudio()
                    } else {
                        print("We don't have permission to record audio");
                    }
                    
                }
            } catch {
                print("Could not activate the audio session")
            }
            
        } catch let error as NSError {
            print("An error occurred in setting the audio " +
                "session category. Error = \(error)")
        }
    }
    
    func stopRecord() {
        self.audioRecorder?.stop()
    }
    
    func startRecordingAudio() {
        
        let audioRecordingURL = self.audioRecordingPath()
        
        do {
            audioRecorder = try AVAudioRecorder(URL: audioRecordingURL,
                settings: audioRecordingSettings())
            
            guard let recorder = audioRecorder else {
                return
            }
            
            ((self.viewControllers?.first as? UINavigationController)?.viewControllers[0] as! MasterViewController)
                .audioRecorder = recorder
            
            recorder.delegate = self
            /* Prepare the recorder and then start the recording */
            
            if recorder.prepareToRecord() {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    recorder.record()
                    print("Successfully started to record.")
                })
                
            } else {
                print("Failed to record.")
                audioRecorder = nil
            }
            
        } catch {
            audioRecorder = nil
        }
        
        
    }
    
    func audioRecordingPath() -> NSURL{
        
        let fileManager = NSFileManager()
        
        let documentsFolderUrl: NSURL?
        do {
            documentsFolderUrl = try fileManager.URLForDirectory(.DocumentDirectory,
                inDomain: .UserDomainMask,
                appropriateForURL: nil,
                create: false)
        } catch _ {
            documentsFolderUrl = nil
        }
        
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy 'at' HH:mm:ss"
        
        let formattedDate = dateFormatter.stringFromDate(NSDate())
        
        return documentsFolderUrl!.URLByAppendingPathComponent(formattedDate + ".m4a")
        
    }
    
    func audioRecordingSettings() -> [String : AnyObject]{
        
        /* Let's prepare the audio recorder options in the dictionary.
        Later we will use this dictionary to instantiate an audio
        recorder of type AVAudioRecorder */
        
        return [
            AVFormatIDKey : NSNumber(unsignedInt: kAudioFormatMPEG4AAC),
            AVSampleRateKey : 16000.0 as NSNumber,
            AVNumberOfChannelsKey : 1 as NSNumber,
            AVEncoderAudioQualityKey : AVAudioQuality.Low.rawValue as NSNumber
        ]
        
    }
    
    // MARK: Audio recorder
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        print("recording finished")
    }
    
}
