//
//  DatabaseManager.swift
//  Loggio
//
//  Created by Annderson Packeiser Oreto on 14/10/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DatabaseManager {
    
    private var ref: DatabaseReference!
    
    init() {
        
        ref = Database.database().reference()
    }
    
    func saveNewProfile(email: String, name: String, userUid: String) {
        
        let post = ["name": name]
        let profileRef = ref.child("users").child(email)
        profileRef.setValue(post) { (error, _) in
            
            if let error = error {
                
                print(error.localizedDescription)
            }
        }
        let trailMockup = CoreDataService.shared.mockSections()
        createTrail(trailMockup, profileRef: profileRef)
    }

    func sendPending(source: String, target: String) {
        
        let post = ["pending": source]
        
        ref.child("users").child(target).updateChildValues(post) { (error, ret) in
            
            if let error = error {
                
                print(error.localizedDescription)
            }
        }
    }
    
    func acceptPending(source: String, target: String, name: String, phone: String) {
        
        var post = ["pending": ""]
        
        ref.child("users").child(source).updateChildValues(post) { (error, ret) in
            
            if let error = error {
                
                print(error.localizedDescription)
            }
        }
        
        post = ["email": source,
                "name": name,
                "phone": phone]
        
        ref.child("users").child(target).child("professional_list").childByAutoId().setValue(post) { (error, ret) in
            
            if let error = error {
                
                print(error.localizedDescription)
            }
        }
    }
    
    func getUserProfile(userUid: String, completion: @escaping(AuthenticationProfile) -> Void) {

        ref.child("users").child(userUid).observeSingleEvent(of: .value, with: { (snapshopt) in

            let value = snapshopt.value as? NSDictionary
            let email = userUid.replacingOccurrences(of: "(dot)", with: ".").lowercased()
            let name = value?["name"] as? String ?? ""

            let profile = AuthenticationProfile(id: userUid, email: email)
            profile.name = name

            completion(profile)
        })
    }
    
    func getPendingStatus(userUid: String, completion: @escaping(String) -> Void) {
        ref.child("users").child(userUid).observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                if let pendingEmail = value["pending"] as? String {
                    completion(pendingEmail)
                } else {
                    completion("")
                }
            }
        }
    }
    
    func createTrail(_ trail: [TrailSection], profileRef: DatabaseReference) {
        var sectionsRef = profileRef.child("trail/sections")
        
        // Primeiro "for" percorre as seções da trilha
        for (index01,section) in trail.enumerated() {
            sectionsRef = sectionsRef.child("\(index01)")
            sectionsRef.setValue([
                "id": section.id,
                "available": section.available,
                "currentLine": section.currentLine
            ])
            sectionsRef = sectionsRef.child("lines")
            
            // Segundo "for" percorre as linhas dentro de cada seção
            for (index02,line) in section.trail.enumerated() {
                let lineRef = sectionsRef.child("\(index02)")
                var games = [[String: Any]]()
                
                // Terceiro "for" percorre os jogos dentro de cada linha
                for game in line {
                    let gameDict = ["id": game.id.uuidString,
                                    "gameName": game.gameName,
                                    "gameType": game.gameType.rawValue,
                                    "isAvailable": game.isAvailable,
                                    "isCompleted": game.isCompleted,
                                    "currentProgress": game.currentProgress] as [String : Any]
                    games.append(gameDict)
                }
                
                lineRef.setValue(games)
            }
        }
    }
    
    func requestTrail() {
        let email = "arthur@gmail(dot)com"
        ref.child("users/\(email)/trail").observeSingleEvent(of: .value) { (snapshot) in
            
            // Transforma snapshot vindo do Firebase para um dicionário
            if let value = snapshot.value as? [String: Any] {
                
                // Pega as seções como um array de dicinário
                if let sectionsDict = value["sections"] as? [[String: Any]] {
                    var sectionsObjects = [TrailSection]()
                    
                    // Itera sobre as seções existentes
                    for section in sectionsDict {
                        // Obtém os respectivos valores de cada seção
                        let available = section["available"] as? Bool ?? true
                        let currentLine = section["currentLine"] as? Int ?? 0
                        let id = section["id"] as? String ?? ""
                        
                        // Pega as linhas de cada seção como um array de array de dicinário
                        if let lines = section["lines"] as? [[[String: Any]]] {
                            var linesObjects = [[GameObject]]()
                            
                            // Itera sobre as linhas de cada seção
                            for line in lines {
                                var games = [GameObject]()
                                
                                // Itera sobre os jogos de cada linha
                                for game in line {
                                    // Obtém os respectivos valores de cada jogo
                                    let currentProgress = game["currentProgress"] as? Float ?? 0
                                    let uuidString = game["id"] as? String ?? ""
                                    let id = UUID(uuidString: uuidString) ?? UUID()
                                    let isAvailable = game["isAvailable"] as? Bool ?? false
                                    let isCompleted = game["isCompleted"] as? Bool ?? false
                                    let gameName = game["gameName"] as? String ?? ""
                                    let rawValue = game["gameType"] as? String ?? ""
                                    let gameType = GameType(rawValue: rawValue) ?? GameType.pattern
                                    
                                    // Cria o jogo
                                    let gameObject = GameObject(id: id,
                                                                gameType: gameType,
                                                                gameName: gameName,
                                                                isAvailable: isAvailable,
                                                                isCompleted: isCompleted,
                                                                currentProgress: currentProgress)
                                    // Adiciona na lista de jogos da linha
                                    games.append(gameObject)
                                }
                                // Adiciona a lista de jogos na respectiva linha
                                linesObjects.append(games)
                            }
                            // Adiciona cada linha na respectiva seção
                            sectionsObjects.append(TrailSection(available: available, trail: linesObjects))
                        }
                    }
                }
            }
        }
    }
}
