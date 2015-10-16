//
//  Apps.swift
//  test
//
//  Created by Mohammad Awwad on 10/16/15.
//  Copyright © 2015 Awwadeto. All rights reserved.
//

import Foundation
import CoreData
import UIKit
@objc(Apps)

class Apps : NSManagedObject {
    
    struct Keys {
        static let Path = "image"
        static let Category = "category"
        static let Name = "name"
        static let Price = "price"
        static let Title = "title"
        static let Artist = "artist"
        static let Release = "releaseDate"
    }
    
    @NSManaged var path: String
    @NSManaged var name: String
    @NSManaged var category: String
    @NSManaged var price: String
    @NSManaged var title: String
    @NSManaged var artist: String
    @NSManaged var releaseDate: String
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        
        let entity =  NSEntityDescription.entityForName("Apps", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        path = dictionary[Keys.Path] as! String
        name = dictionary[Keys.Name] as! String
        category = dictionary[Keys.Category] as! String
        price = dictionary[Keys.Price] as! String
        title = dictionary[Keys.Title] as! String
        artist = dictionary[Keys.Artist] as! String
        releaseDate = dictionary[Keys.Release] as! String
    }
    
    var appImage: UIImage? {
        
        get {
            return iTunes.Caches.imagecache.imageWithIdentifier(path)
        }
        
        set {
            self.sharedContext.performBlockAndWait({
                iTunes.Caches.imagecache.storeImage(newValue, withIdentifier: self.path)
            })
        }
    }
    
    var sharedContext: NSManagedObjectContext {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }
}