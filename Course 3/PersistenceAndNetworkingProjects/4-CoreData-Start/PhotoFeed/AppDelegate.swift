//
//  AppDelegate.swift
//  PhotoFeed
//
//  Created by Mike Spears on 2016-01-07.
//  Copyright © 2016 YourOganisation. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var dataController: DataController!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UserDefaults.standard.register(defaults: ["PhotoFeedURLString": "https://api.flickr.com/services/feeds/photos_public.gne?tags=kitten&format=json&nojsoncallback=1"])
        dataController = DataController()
        return true
    }


    func applicationDidBecomeActive(_ application: UIApplication) {
        let urlString = UserDefaults.standard.string(forKey: "PhotoFeedURLString")
        
        guard let foundURLString = urlString else {
            return
        }
        
        if let url = URL(string: foundURLString) {
            self.loadOrUpdateFeed(url, completion: { (feed) -> Void in
                let navController = application.windows[0].rootViewController as? UINavigationController
                let viewController = navController?.viewControllers[0] as? ImageFeedTableViewController
                viewController?.feed = feed
            })
        }
    }
    

    func updateFeed(_ url: URL, completion: @escaping (_ feed: Feed?) -> Void) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            if error == nil && data != nil {
                let feed = Feed(data: data!, sourceURL: url)
                
                if let goodFeed = feed {
                    if self.saveFeed(goodFeed) {
                        UserDefaults.standard.set(Date(), forKey: "lastUpdate")
                    }
                }
                
                print("loaded Remote feed!")
                
                OperationQueue.main.addOperation({ () -> Void in
                    completion(feed)
                })
            }

        }) 
        
        task.resume()
    }
    
    func feedFilePath() -> String {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let filePath = paths[0].appendingPathComponent("feedFile.plist")
        return filePath.path
    }
    
    func saveFeed(_ feed: Feed) -> Bool {
        let success = NSKeyedArchiver.archiveRootObject(feed, toFile: feedFilePath())
        assert(success, "failed to write archive")
        return success
    }
    
    func readFeed(_ completion: (_ feed: Feed?) -> Void) {
        let path = feedFilePath()
        let unarchivedObject = NSKeyedUnarchiver.unarchiveObject(withFile: path)
        completion(unarchivedObject as? Feed)
    }

    
    func loadOrUpdateFeed(_ url: URL, completion: @escaping (_ feed: Feed?) -> Void) {

        let lastUpdatedSetting = UserDefaults.standard.object(forKey: "lastUpdate") as? Date
        
        var shouldUpdate = true
        if let lastUpdated = lastUpdatedSetting, Date().timeIntervalSince(lastUpdated) < 20 {
            shouldUpdate = false
        }
        if shouldUpdate {
            self.updateFeed(url, completion: completion)
        } else {
            self.readFeed { (feed) -> Void in
                if let foundSavedFeed = feed, foundSavedFeed.sourceURL.absoluteString == url.absoluteString {
                    print("loaded saved feed!")
                    OperationQueue.main.addOperation({ () -> Void in
                        completion(foundSavedFeed)
                    })
                } else {
                    self.updateFeed(url, completion: completion)
                }
                
                
            }
        }
        
        
        
    }

}

