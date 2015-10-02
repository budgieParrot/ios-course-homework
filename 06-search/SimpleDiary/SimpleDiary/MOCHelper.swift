//
//  MOCHelper.swift
//  SimpleDiary
//
//  Created by ADM on 10/2/15.
//  Copyright © 2015 Buypass. All rights reserved.
//

import CoreData

class MOCHelper {
    
    static let sharedInstance: MOCHelper = MOCHelper()
    
    var moc:NSManagedObjectContext?
    
    init() {
    }
    
    func saveObjects() {
        do {
            try self.moc!.save()
        } catch {
            fatalError("Failure to save diary records: \(error)")
        }
        
    }
    
    func deleteObject(object: NSManagedObject) {
        self.moc?.deleteObject(object)
    }
    
}
