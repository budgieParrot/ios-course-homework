//
//  AudioRecordCellDelegate.swift
//  Zrada
//
//  Created by ADM on 11/5/15.
//  Copyright © 2015 Anastasiia.Babicheva. All rights reserved.
//

import UIKit

protocol AudioRecordCellDelegate {
    
    func didClickPlayButton(cell: AudioRecordCell, indexPath: NSIndexPath)
    
}