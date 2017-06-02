//
//  TagsTableViewController.swift
//  PhotoFeed
//
//  Created by Mike Spears on 2016-01-10.
//  Copyright © 2016 YourOganisation. All rights reserved.
//

import UIKit
import CoreData

class TagsTableViewController: UITableViewController {

    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>!
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("tags fetch failed")
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections!.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagCell", for: indexPath)
        let tag = fetchedResultsController.object(at: indexPath) as! Tag
        
        cell.textLabel?.text = tag.title
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showImages" {
            let indexPath = tableView.indexPathForSelectedRow!
            let destination = segue.destination as! ImageFeedTableViewController
            
            let tag = fetchedResultsController.object(at: indexPath) as! Tag
            if let images = tag.images?.allObjects as? [Image] {
                var feedItems = [FeedItem]()
                for image in images {
                    let imageURL = URL(string: image.imageURL ?? "")
                    
                    let newFeedItem = FeedItem(title: image.title ?? "(no title)", imageURL: imageURL!)
                    feedItems.append(newFeedItem)
                }
                let feed = Feed(items: feedItems, sourceURL: NSURL() as URL)
                destination.feed = feed
            }
        }
    }

}
