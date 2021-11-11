//
//  Photo+CoreDataProperties .swift
//  VirtualTourist
//
//  Created by Zakaria on 06/11/2021.
//

import Foundation
import CoreData
// Photo class extension that contains its properties and methods

//extension Photo{
//    // look for persistent instances of the "Photo" object
//    @nonobjc public class  func fetchRequest() -> NSFetchRequest<Photo> {
//        return NSFetchRequest<Photo>(entityName: "Photo")
//    }
//
//    // attributes
//    @NSManaged public var imageData: NSData?
//    @NSManaged public var imageURL: String?
//
//    // relationship
//    @NSManaged public var pin: Pin?
//}

extension Photo {
    
        // busca si hay instancias persistidas del objeto 'Photo'
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var imageData: NSData? // attribute
    @NSManaged public var imageURL: String? // attribute
    @NSManaged public var pin: Pin? // relationship

}
