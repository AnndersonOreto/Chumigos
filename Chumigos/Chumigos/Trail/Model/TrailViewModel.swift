//
//  TrailViewModel.swift
//  Chumigos
//
//  Created by Annderson Packeiser Oreto on 08/09/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

class TrailViewModel: ObservableObject {
    
    @Environment(\.managedObjectContext) var moc
    
    @Published var matrixObjectList: TrailMatrixList = TrailMatrixList()
    @Published var matrixList: [TrailSection] = []
    
    // MARK: - Init
    
    init() {
        
    }
    
    // MARK: - Functions
    
    func retrieveMatrixTrail(result: FetchedResults<UserData>) {
        
        let decoder = JSONDecoder()
        
        if result.count > 0 && result[0].trail != nil {
            
            guard let trailData = result[0].trail else { return }
            
            do {
                self.matrixObjectList = try decoder.decode(TrailMatrixList.self, from: trailData)
                self.matrixList = matrixObjectList.matrixList
            } catch {
                fatalError("fudeu0")
            }
            
        } else {
            self.matrixList = TrailViewModel.mockSections()
        }
    }
    
    func saveMatrixTrail(result: FetchedResults<UserData>) {
        
        var user: UserData
        
        // Override save on first position to prevent creation of multiple instances
        if result.count <= 0 {
            user = UserData(context: self.moc)
        } else {
            user = result[0]
        }
        
        let encoder = JSONEncoder()
        
        do {
            user.trail = try encoder.encode(matrixList)
        } catch {
            fatalError("fudeu1")
        }
        
        do {
            try self.moc.save()
        } catch {
            fatalError("fudeu2")
        }
    }
    
    // MARK: - Static(s)
    
    // Just for test
    static func mockSections() -> [TrailSection] {
        let linha1 = [GameObject(gameType: .pattern, gameName: GameNames.sequenceGameName)]

        let linha2 = [GameObject(gameType: .pattern, gameName: GameNames.shapeGameName), GameObject(gameType: .abstraction, gameName: "Abstraction")]

        let linha3 = [GameObject(gameType: .algorithm, gameName: "Algorithm"), GameObject(gameType: .decomposition, gameName: "Decomposition"), GameObject(gameType: .abstraction, gameName: "Abstraction")]

        let matrix = [linha1, linha2, linha3, linha2]

        return [TrailSection(available: true, trail: matrix), TrailSection(available: false, trail: matrix)]
    }
}
