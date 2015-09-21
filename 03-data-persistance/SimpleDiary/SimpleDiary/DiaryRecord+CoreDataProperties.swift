//
//  DiaryRecord+CoreDataProperties.swift
//  SimpleDiary
//
//  Created by ADM on 9/21/15.
//  Copyright © 2015 Buypass. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension DiaryRecord {

    @NSManaged var creationDate: NSDate?
    @NSManaged var name: String?
    @NSManaged var body: String?
    @NSManaged var weather: NSNumber?

}
