//
//  DataController.swift
//  VirtualTourist
//
//  Created by Zakaria on 04/11/2021.
//

import Foundation
import CoreData

class DataController {
    
    // persistent container constant
    let persistentContainer: NSPersistentContainer
    
    
    // contextView declaration
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // initialize the persistentContainer of a given model
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    
    // MARK: - Functions for DataController class
    
    // load persistent store function
    func load(completion: (()->Void)? = nil){
        persistentContainer.loadPersistentStores { storeDescriptor, error in
            
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.autoSaveViewContext()
            completion?()
        }
    }
}



// MARK: - DataController Extension

extension DataController{
    // check for changes every 30 seconds and if there are changes save them
    func autoSaveViewContext(interval: TimeInterval = 30){
        
        guard interval > 0 else {
            print("Cannot save in negative intervals")
            return
        }
        
        // save if there are changes in the view context
        if viewContext.hasChanges{
            try? viewContext.save()
        }
        
        // dispatch
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
        //test
        print("autosaving")
        
    }
}
