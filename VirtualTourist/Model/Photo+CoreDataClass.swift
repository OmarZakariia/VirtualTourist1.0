//
//  Photo+CoreDataClass.swift
//  VirtualTourist
//
//  Created by Zakaria on 06/11/2021.
//

import Foundation
import CoreData
// Class for Photo object with a conveince initializer

public class Photo : NSManagedObject{

    
    // Create an initializer to create instances of photos, initializer will take url of image as the data
    convenience init(imageURL: String?, context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entity(forEntityName: "Photo", in: context){
            self.init(entity: entity, insertInto: context)
            self.imageURL = imageURL
        } else {
            fatalError("Unable to find entity name")
        }
    }
}
