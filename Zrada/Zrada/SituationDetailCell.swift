//
//  SituationDetailCell.swift
//  Zrada
//
//  Created by ADM on 10/17/15.
//  Copyright © 2015 Anastasiia.Babicheva. All rights reserved.
//

import UIKit

class SituationDetailCell: UITableViewCell {
    
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var lawLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
