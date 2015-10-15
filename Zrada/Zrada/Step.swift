//
//  Step.swift
//  Zrada
//
//  Created by ADM on 10/13/15.
//  Copyright © 2015 Anastasiia.Babicheva. All rights reserved.
//

class Step {
    
    let index: Int?
    let description: String?
    let lawLink: String?
    
    init(index: Int, description: String, lawLink: String) {
        self.index = index
        self.description = description
        self.lawLink = lawLink
    }
    
}