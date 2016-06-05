//
//  Track.swift
//  PlaylistGenerator
//
//  Created by Owen LaRosa on 6/4/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import CoreData

class Track: NSManagedObject {
    
    @NSManaged var title: String
    @NSManaged var artist: Artist
    @NSManaged var type: Category
    @NSManaged var new: Bool
    @NSManaged var firstAdded: NSDate
    @NSManaged var lastPlayed: NSDate?
    @NSManaged var becomesOld: NSDate?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(title: String, artist: Artist, new: Bool, becomesOld: NSDate?, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("Track", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        self.title = title
        self.artist = artist
        self.new = new
        self.becomesOld = becomesOld
        self.type = Category(name: "Other", context: context)
        self.lastPlayed = nil
        self.firstAdded = NSDate()
    }
    
}
