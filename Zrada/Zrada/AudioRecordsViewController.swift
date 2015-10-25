//
//  AudioRecordsViewController.swift
//  Zrada
//
//  Created by ADM on 10/22/15.
//  Copyright © 2015 Anastasiia.Babicheva. All rights reserved.
//

import UIKit
import AVFoundation

class AudioRecordsViewController: UITableViewController, AVAudioPlayerDelegate {
    
    var objects = [NSURL]()
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        setupObjects()
    }
    
    private func setupObjects() {
        let fileManager = NSFileManager()
        
        var documentsFolderUrl: NSURL?
        do {
            documentsFolderUrl = try fileManager.URLForDirectory(.DocumentDirectory,
                inDomain: .UserDomainMask,
                appropriateForURL: nil,
                create: false)
            
            objects = try fileManager.contentsOfDirectoryAtURL(documentsFolderUrl!, includingPropertiesForKeys: nil, options: .SkipsHiddenFiles)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("AudioRecordCell", forIndexPath: indexPath)
        
        let object = objects[indexPath.row]
        cell.textLabel!.text = object.pathComponents?.last
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        playAudio(indexPath)
    }
    
    // MARK: - Audio Player
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print("in audioPlayerDidFinishPlaying")
        self.audioPlayer = nil
    }
    
}
