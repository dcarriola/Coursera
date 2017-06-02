//
//  Feed.swift
//  PhotoFeed
//
//  Created by Mike Spears on 2016-01-08.
//  Copyright © 2016 YourOganisation. All rights reserved.
//

import Foundation



func fixJsonData (_ data: Data) -> Data {
    var dataString = String(data: data, encoding: String.Encoding.utf8)!
    dataString = dataString.replacingOccurrences(of: "\\'", with: "'")
    return dataString.data(using: String.Encoding.utf8)!
    
}


class Feed :NSObject {
    
    let items: [FeedItem]
    let sourceURL: URL
    
    init (items newItems: [FeedItem], sourceURL newURL: URL) {
        self.items = newItems
        self.sourceURL = newURL
        super.init()
    }
    
    func encodeWithCoder(_ aCoder: NSCoder) {
        aCoder.encode(self.items, forKey: "feedItems")
        aCoder.encode(self.sourceURL, forKey: "feedSourceURL")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let storedItems = aDecoder.decodeObject(forKey: "feedItems") as? [FeedItem]
        let storedURL = aDecoder.decodeObject(forKey: "feedSourceURL") as? URL
        
        guard storedItems != nil && storedURL != nil  else {
            return nil
        }
        self.init(items: storedItems!, sourceURL: storedURL! )
        
    }
    
    convenience init? (data: Data, sourceURL url: URL) {
        
        var newItems = [FeedItem]()
        
        let fixedData = fixJsonData(data)
        
        var jsonObject: Dictionary<String, AnyObject>?
        
        do {
            jsonObject = try JSONSerialization.jsonObject(with: fixedData, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? Dictionary<String,AnyObject>
        } catch {
            
        }
        
        guard let feedRoot = jsonObject else {
            return nil
        }
        
        guard let items = feedRoot["items"] as? Array<AnyObject>  else {
            return nil
        }
        
        
        for item in items {
            
            guard let itemDict = item as? Dictionary<String,AnyObject> else {
                continue
            }
            guard let media = itemDict["media"] as? Dictionary<String, AnyObject> else {
                continue
            }
            
            guard let urlString = media["m"] as? String else {
                continue
            }
            
            guard let url = URL(string: urlString) else {
                continue
            }
            
            let title = itemDict["title"] as? String
            
            newItems.append(FeedItem(title: title ?? "(no title)", imageURL: url))
            
        }
        
        self.init(items: newItems, sourceURL: url)
    }
    
}
