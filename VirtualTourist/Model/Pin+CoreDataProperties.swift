//
//  Pin+Core.swift
//  VirtualTourist
//
//  Created by Zakaria on 06/11/2021.
//

import Foundation
import CoreData
// Pin class extension that contains its properties, methods \

extension Pin{
    // check for persistent instances of the object 'Pin'
    
    @nonobjc public class  func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin")
    }
    
    // attributes
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    
    // relationship
    @NSManaged public var photos: NSSet?
    
    
}

extension Pin{
    @objc (addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photo)
    
    @objc (removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photo)
    
    @objc (addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)
    
    @objc (removePhoto:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)
    
}
