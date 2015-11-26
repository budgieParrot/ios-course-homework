//
//  AudioRecordCell.swift
//  Zrada
//
//  Created by ADM on 11/5/15.
//  Copyright © 2015 Anastasiia.Babicheva. All rights reserved.
//

import UIKit

class AudioRecordCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func didPlayButtonClicked(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.didClickPlayButton(self, indexPath: self.indexPath!)
        }
    }
    
    var indexPath: NSIndexPath?
    var delegate: AudioRecordCellDelegate?
    var isPlaying = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


