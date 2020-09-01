//
//  CoreDataPersistence.swift
//  Chumigos
//
//  Created by Annderson Packeiser Oreto on 01/09/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation
import CoreData

public class CoreDataPersistence {
    
    // MARK: - Singleton
    
    private init() { }
    static let shared: CoreDataPersistence = CoreDataPersistence()
    
    // MARK: - Variables
    
    var context: NSManagedObjectContext { return persistentContainer.viewContext }
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        // Get reference JSON container
        let container = NSPersistentContainer(name: "Chumigos")
        
        // Try loading container data
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err as NSError? {
                fatalError("Description: \(err)")
            }
        }
        
        return container
    }()
    
    // MARK: - Functions
    
    /// Try to load app data and save it if has changes
    func save() {
        
        // Get container context
        let context = persistentContainer.viewContext
        
        // Try to save if has changes
        if context.hasChanges {
            
            do {
                try context.save()
            } catch {
                let err = error as NSError
                fatalError("Description: \(err)")
            }
        }
    }
}
