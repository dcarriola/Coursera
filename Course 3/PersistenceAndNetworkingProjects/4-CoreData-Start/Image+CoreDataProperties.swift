//
//  Image+CoreDataProperties.swift
//  PhotoFeed
//
//  Created by Daniel Alejandro Carriola on 02.06.17.
//  Copyright © 2017 YourOganisation. All rights reserved.
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var imageURL: String?
    @NSManaged public var title: String?
    @NSManaged public var tag: Tag?

}
