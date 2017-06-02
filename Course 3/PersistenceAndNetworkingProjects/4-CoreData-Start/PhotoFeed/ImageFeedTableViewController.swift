//
//  ImageFeedTableViewController.swift
//  PhotoFeed
//
//  Created by Mike Spears on 2016-01-08.
//  Copyright © 2016 YourOganisation. All rights reserved.
//

import UIKit
import CoreData

class ImageFeedTableViewController: UITableViewController {

    var feed: Feed? {
        didSet {
            self.tableView.reloadData()
        }
    }

    var urlSession: URLSession!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = URLSessionConfiguration.default
        self.urlSession = URLSession(configuration: configuration)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.urlSession.invalidateAndCancel()
        self.urlSession = nil
    }
    
    // MARK: - Table View
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feed?.items.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageFeedItemTableViewCell", for: indexPath) as! ImageFeedItemTableViewCell
        
        let item = self.feed!.items[indexPath.row]
        cell.itemTitle.text = item.title
        
        let request = URLRequest(url: item.imageURL as URL)
        
        cell.dataTask = self.urlSession.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            OperationQueue.main.addOperation({ () -> Void in
                if error == nil && data != nil {
                    let image = UIImage(data: data!)
                    cell.itemImageView.image = image
                }
            })
            
        })
        
        cell.dataTask?.resume()
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? ImageFeedItemTableViewCell {
            cell.dataTask?.cancel()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = feed!.items[indexPath.row]
        
        let alertController = UIAlertController(title: "Add Tag", message: "Type your tag", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if let tagTitle = alertController.textFields![0].text {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.dataController.tagFeedItem(tagTitle: tagTitle, feedItem: item)
            }
        }
        alertController.addAction(defaultAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addTextField(configurationHandler: nil)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTags" {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let moc = appDelegate.dataController.managedObjectContext
            
            let tagsVC = segue.destination as! TagsTableViewController
            
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Tag")
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
            tagsVC.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        }
    }

}
