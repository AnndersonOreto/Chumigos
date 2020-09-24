//
//  CoreDataService.swift
//  Loggio
//
//  Created by Arthur Bastos Fanck on 17/09/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import Foundation
import CoreData

class CoreDataService {
    
    static var shared = CoreDataService()
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentCloudKitContainer(name: "Chumigos")
        container.loadPersistentStores(completionHandler: { (_, error) in
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func retrieveMatrixTrail() -> [TrailSection] {
        
        let request: NSFetchRequest<UserData> = UserData.fetchRequest()
        
        do {
            let result = try self.persistentContainer.viewContext.fetch(request)
            let decodedResult = decode(result: result)
            
            return decodedResult
        } catch {
            fatalError("Não conseguiu fazer request!")
        }
    }
    
    func saveMatrixTrail(_ trail: TrailMatrixList) {
        let user = UserData(context: self.persistentContainer.viewContext)
        user.id = 0
        user.trail = encode(matrix: trail)
        self.saveContext()
    }
    
    func encode(matrix: TrailMatrixList) -> Data {
        let encoder = JSONEncoder()
        do {
            let encodedMatrix = try encoder.encode(matrix)
            return encodedMatrix
        } catch {
            fatalError("Não conseguiu encodar data!")
        }
    }
    
    func decode(result: [UserData]) -> [TrailSection] {
        let decoder = JSONDecoder()
        
        if result.isEmpty && result[0].trail != nil {
            
            guard let trailData = result[0].trail else { return [] }
            
            do {
                let matrixObjectList = try decoder.decode(TrailMatrixList.self, from: trailData)
                return matrixObjectList.matrixList
            } catch {
                fatalError("Não conseguiu decodar data!")
            }
        } else {
            let mockSections = self.mockSections()
            let matrixList = TrailMatrixList(matrixList: mockSections)
            self.saveMatrixTrail(matrixList)
            return mockSections
        }
    }
    
    func saveGameObject(_ gameObject: GameObject) {
        var sectionsTrail = self.retrieveMatrixTrail()
        
        #warning("Muitos for aninhados! Precisamos refatorar.")
        for section in 0..<sectionsTrail.count {
            for line in 0..<sectionsTrail[section].trail.count {
                for column in 0..<sectionsTrail[section].trail[line].count {
                    let game = sectionsTrail[section].trail[line][column]
                    if game.id == gameObject.id {
                        sectionsTrail[section].trail[line][column] = gameObject
                    }
                }
            }
        }
        let matrix = TrailMatrixList(matrixList: sectionsTrail)
        self.saveMatrixTrail(matrix)
    }
    
    // MARK: - MOCK
    
    // Just for test
    func mockSections() -> [TrailSection] {
        let linha1 = [GameObject(id: UUID(), gameType: .pattern, gameName: GameNames.sequenceGameName1)]

        let linha2 = [GameObject(id: UUID(), gameType: .abstraction, gameName: GameNames.shapeGameName1)]

        let linha3 = [GameObject(id: UUID(), gameType: .pattern, gameName: GameNames.sequenceGameName2),
                      GameObject(id: UUID(), gameType: .abstraction, gameName: GameNames.shapeGameName2)]
        
        let linha4 = [GameObject(id: UUID(), gameType: .decomposition, gameName: GameNames.avatarGameName)]

        let matrix = [linha1, linha2, linha3, linha4]

        return [TrailSection(available: true, trail: matrix)]
    }
}
