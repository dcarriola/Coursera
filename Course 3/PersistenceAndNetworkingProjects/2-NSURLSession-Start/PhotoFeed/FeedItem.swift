//
//  FeedItem.swift
//  PhotoFeed
//
//  Created by Mike Spears on 2016-01-08.
//  Copyright © 2016 YourOganisation. All rights reserved.
//

import Foundation

class FeedItem: NSObject, NSCoding {
    
    let title: String
    let imageURL: URL
    
    init (title: String, imageURL: URL) {
        self.title = title
        self.imageURL = imageURL
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "itemTitle")
        aCoder.encode(imageURL, forKey: "itemURL")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let storedTitle = aDecoder.decodeObject(forKey: "itemTitle") as? String
        let storedURL = aDecoder.decodeObject(forKey: "itemURL") as? URL
        
        guard storedTitle != nil && storedURL != nil else { return nil }
        self.init(title: storedTitle!, imageURL: storedURL!)
    }
}
