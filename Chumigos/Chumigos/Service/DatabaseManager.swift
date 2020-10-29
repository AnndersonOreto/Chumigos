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
            if let value = snapshot.value as? [String: Any] {
                if let sectionsDict = value["sections"] as? [[String: Any]] {
                    var sectionsObjects = [TrailSection]()
                    for section in sectionsDict {
                        guard let available = section["available"] as? Bool else { return }
                        guard let currentLine = section["currentLine"] as? Int else { return }
                        guard let id = section["id"] as? UUID else { return }
                        
                        if let lines = section["lines"] as? [[[String: Any]]] {
                            var linesObjects = [[GameObject]]()
                            for line in lines {
                                var games = [GameObject]()
                                for game in line {
                                    guard let currentProgress = game["currentProgress"] as? Float else { return }
                                    guard let id = game["id"] as? UUID else { return }
                                    guard let isAvailable = game["isAvailable"] as? Bool else { return }
                                    guard let isCompleted = game["isCompleted"] as? Bool else { return }
                                    guard let gameName = game["gameName"] as? String else { return }
                                    guard let gameType = game["gameType"] as? GameType else { return }
                                    
                                    let gameObject = GameObject(id: id,
                                                                gameType: gameType,
                                                                gameName: gameName,
                                                                isAvailable: isAvailable,
                                                                isCompleted: isCompleted,
                                                                currentProgress: currentProgress)
                                    games.append(gameObject)
                                }
                                linesObjects.append(games)
                            }
                            sectionsObjects.append(TrailSection(available: available, trail: linesObjects))
                        }
                    }
                }
            }
        }
    }
}
