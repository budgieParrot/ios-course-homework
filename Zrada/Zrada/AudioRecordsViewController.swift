//
//  AudioRecordsViewController.swift
//  Zrada
//
//  Created by ADM on 10/22/15.
//  Copyright © 2015 Anastasiia.Babicheva. All rights reserved.
//

import UIKit
import AVFoundation

class AudioRecordsViewController: UITableViewController, AVAudioPlayerDelegate,
    AudioRecordCellDelegate {
    
    var objects = [NSURL]()
    var audioPlayer: AVAudioPlayer?
    var currentCell: AudioRecordCell?
    let fileManager = NSFileManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        setupObjects()
    }
    
    private func setupObjects() {
        var documentsFolderUrl: NSURL?
        do {
            documentsFolderUrl = try fileManager.URLForDirectory(.DocumentDirectory,
                inDomain: .UserDomainMask,
                appropriateForURL: nil,
                create: false)
            
            objects = try fileManager.contentsOfDirectoryAtURL(documentsFolderUrl!, includingPropertiesForKeys: nil, options: .SkipsHiddenFiles)
            
            objects.sortInPlace({(a: NSURL, b: NSURL) -> Bool
                in
                var date1: AnyObject?
                var date2: AnyObject?
                do {
                    try a.getResourceValue(&date1, forKey: NSURLCreationDateKey)
                    try b.getResourceValue(&date2, forKey: NSURLCreationDateKey)
                    if let d1 = date1 as? NSDate, d2 = date2 as? NSDate {
                        return d1.compare(d2) == NSComparisonResult.OrderedDescending
                    }
                } catch let error as NSError {
                    print("Error when sort audios: \(error.domain)")
                }
                
                return false
            })
            
            self.tableView.reloadData()
            print(objects)
        } catch _ {
            documentsFolderUrl = nil
        }
        
    }
    
    private func playAudio(index: NSIndexPath) {
        do {
            let fileData = try NSData(contentsOfURL: objects[index.row],
                options: .MappedRead)
            
            audioPlayer = try AVAudioPlayer(data: fileData)
            
            guard let player = audioPlayer else {
                return
            }
            
            player.delegate = self
            
            /* Prepare to play and start playing */
            if player.prepareToPlay() && player.play() {
                print("Started playing the recorded audio")
            } else {
                print("Could not play the audio")
            }
        } catch let error as NSError{
            print("Error = \(error)")
            audioPlayer = nil
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
        let cell = tableView.dequeueReusableCellWithIdentifier("AudioRecordCell", forIndexPath: indexPath) as!AudioRecordCell
        
        let object = objects[indexPath.row]
        cell.nameLabel.text = object.pathComponents?.last?.componentsSeparatedByString(".").first
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            do {
                try fileManager.removeItemAtURL(objects[indexPath.row])
                objects.removeAtIndex(indexPath.row)
            } catch let error as NSError {
                print("Error when delete audio: \(error.domain)")
            }
            
            tableView.reloadData()
        }
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        playAudio(indexPath)
//    }
    
    func didClickPlayButton(cell: AudioRecordCell, indexPath: NSIndexPath) {
        print("index: %d", indexPath.row)
        if let currentCell = self.currentCell {
            currentCell.playButton.setTitle("Play", forState: .Normal)
            self.audioPlayer?.stop()
        }
        
        if cell != self.currentCell {
            self.currentCell = cell
            self.currentCell?.playButton.setTitle("Stop", forState: .Normal)
            playAudio(indexPath)
        } else {
            self.currentCell = nil
        }
    }
    
    // MARK: - Audio Player
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print("in audioPlayerDidFinishPlaying")
        self.audioPlayer = nil
        if let currentCell = self.currentCell {
            currentCell.playButton.setTitle("Play", forState: .Normal)
            self.currentCell = nil
        }
    }
    
}
