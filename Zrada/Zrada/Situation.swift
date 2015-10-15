//
//  Situation.swift
//  Zrada
//
//  Created by ADM on 10/13/15.
//  Copyright © 2015 Anastasiia.Babicheva. All rights reserved.
//

class Situation {
    
    let shortName: String?
    let description: String?
    let steps:[Step]?
    let place: Place?
    
    init(shortName: String, description: String, steps: [Step],
        place: Place) {
        self.shortName = shortName
        self.description = description
        self.steps = steps
        self.place = place
    }
    
}
