//
//  DataController.swift
//  VirtualTourist
//
//  Created by Zakaria on 04/11/2021.
//

import Foundation
import CoreData

class DataController {
    let persistentContainer : NSPersistentContainer
    
    var viewContext : NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion:(()->Void)? = nil){
        persistentContainer.loadPersistentStores { storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.autoSaveViewContext()
            completion?()
        }
    }
    
}




extension DataController {
    func autoSaveViewContext(interval: TimeInterval = 30){
        guard interval > 0 else {
            print("cant save in negative time interval")
            return
        }
        
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
        
        print("autosaving in progress")
    }
}
