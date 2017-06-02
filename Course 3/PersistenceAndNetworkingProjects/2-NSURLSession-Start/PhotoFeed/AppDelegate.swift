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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UserDefaults.standard.register(defaults: ["PhotoFeedURLString": "https://api.flickr.com/services/feeds/photos_public.gne?tags=kitten&format=json&nojsoncallback=1"])
        return true
    }


    func applicationDidBecomeActive(_ application: UIApplication) {
        let urlString = UserDefaults.standard.string(forKey: "PhotoFeedURLString")
        guard let foundURLString = urlString else { return }
        
        if let url = URL(string: foundURLString) {
            loadOrUpdateFeed(url: url, completion: { (feed) in
                let viewController = application.windows[0].rootViewController as? ImageFeedTableViewController
                viewController?.feed = feed
            })
        }
    }
    
    func updateFeed(url: URL, completion: @escaping (_ feed: Feed?) -> ()) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil && data != nil {
                let feed = Feed(data: data!, sourceURL: url)
                
                if let goodFeed = feed {
                    if self.saveFeed(feed: goodFeed) {
                        UserDefaults.standard.set(Date(), forKey: "lastUpdate")
                    }
                }
                print("loaded remote feed!")
                
                OperationQueue.main.addOperation({
                    completion(feed)
                })
            }
        }
        task.resume() 
    }
    
    func loadOrUpdateFeed(url: URL, completion: @escaping (_ feed: Feed?) -> ()) {
        let lastUpdatedSetting = UserDefaults.standard.object(forKey: "lastUpdate") as? Date
        
        var shouldUpdate = true
        if let lastUpdated = lastUpdatedSetting, Date().timeIntervalSince(lastUpdated) < 20 {
            shouldUpdate = false
        }
        if shouldUpdate {
            updateFeed(url: url, completion: completion)
        } else {
            readFeed(completion: { (feed) in
                if let foundSavedFeed = feed, foundSavedFeed.sourceURL.absoluteString == url.absoluteString {
                    print("loaded saved feed")
                    OperationQueue.main.addOperation({ 
                        completion(foundSavedFeed)
                    })
                } else {
                    self.updateFeed(url: url, completion: completion)
                }
            })
        }
    }
    
    func feedFilePath() -> String {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let filePath = paths[0].appendingPathComponent("feedFile.plist")
        return filePath.path
    }
    
    func saveFeed(feed: Feed) -> Bool {
        let success = NSKeyedArchiver.archiveRootObject(feed, toFile: feedFilePath())
        assert(success, "failed to write archive")
        return success
    }
    
    func readFeed(completion: (_ feed: Feed?) -> ()) {
        let path = feedFilePath()
        let unarchivedObject = NSKeyedUnarchiver.unarchiveObject(withFile: path)
        completion(unarchivedObject as? Feed)
    }

}

