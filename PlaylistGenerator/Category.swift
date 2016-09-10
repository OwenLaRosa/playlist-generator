//
//  Category.swift
//  PlaylistGenerator
//
//  Created by Owen LaRosa on 6/5/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import Cocoa

class Category: NSManagedObject {
    
    @NSManaged var name: String
    @NSManaged var tracks: NSSet
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(name: String, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Category", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.name = name
    }
    
}
