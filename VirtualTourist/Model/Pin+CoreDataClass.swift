//
//  Pin+CoreDataClass.swift
//  VirtualTourist
//
//  Created by Zakaria on 06/11/2021.
//

import Foundation
import CoreData

// Class for representing Pin object with a convenience initializer


// create an initializer to generate Pin instances, initializer will take coordinates from the pin input
public class Pin:  NSManagedObject{
    convenience init(latitude: Double, longitude: Double, context: NSManagedObjectContext) {
        
        if let entity = NSEntityDescription.entity(forEntityName: "Pin", in: context){
            self.init(entity: entity, insertInto: context)
            self.latitude = latitude
            self.longitude = longitude
        } else {
            fatalError("Cannot find entity name")
        }
    }
}
