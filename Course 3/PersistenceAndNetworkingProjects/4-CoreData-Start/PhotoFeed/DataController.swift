//
//  DataController.swift
//  PhotoFeed
//
//  Created by Daniel Alejandro Carriola on 02.06.17.
//  Copyright © 2017 YourOganisation. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    let managedObjectContext: NSManagedObjectContext
    
    init(moc: NSManagedObjectContext) {
        self.managedObjectContext = moc
    }
    
    convenience init?() {
        guard let modelURL = Bundle.main.url(forResource: "Model", withExtension: "momd") else { return nil }
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else { return nil }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = psc
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let persistantStoreFileURL = urls[0].appendingPathComponent("Bookmarks.sqlite")
        
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: persistantStoreFileURL, options: nil)
        } catch {
            fatalError("Error adding store.")
        }
        
        self.init(moc: moc)
    }
    
    func tagFeedItem(tagTitle: String, feedItem: FeedItem) {
        let tagsFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Tag")
        tagsFetch.predicate = NSPredicate(format: "title == %@", tagTitle)
        
        var fetchedTags: [Tag]!
        do {
            fetchedTags = try managedObjectContext.fetch(tagsFetch) as! [Tag]
        } catch {
            fatalError("fetch failed")
        }
        
        var tag: Tag
        if fetchedTags.count == 0 {
            tag = NSEntityDescription.insertNewObject(forEntityName: "Tag", into: managedObjectContext) as! Tag
            tag.title = tagTitle
        } else {
            tag = fetchedTags[0]
        }
        
        let newImage = NSEntityDescription.insertNewObject(forEntityName: "Image", into: managedObjectContext) as! Image
        newImage.title = feedItem.title
        newImage.imageURL = feedItem.imageURL.absoluteString
        newImage.tag = tag
        
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("couldn't save context")
        }
    }
}
