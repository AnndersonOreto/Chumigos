//
//  DatabaseManager.swift
//  Loggio
//
//  Created by Annderson Packeiser Oreto on 14/10/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol NoSuchEmailError: LocalizedError {

    var title: String? { get }
}

struct MissingEmailError: NoSuchEmailError {

    var title: String?

    init(title: String?) {
        self.title = title ?? "Error"
    }
}

class DatabaseManager {
    
    // MARK: - Init
    
    private var ref: DatabaseReference!
    
    init() {
        ref = Database.database().reference()
    }
    
    // ====================================
    // MARK: - Database save functions
    // ====================================
    
    /// Save a new profile to the database
    /// - Parameters:
    ///   - email: email to be saved
    ///   - name: name to be saved
    ///   - userUid: id of the user
    func saveNewProfile(email: String, name: String, userUid: String, lives: Int) {
        
        let post = ["name": name, "user_life": ["current_life": 5, "bonus_life": 0]] as [String : Any]
        let profileRef = ref.child("users").child(email)

        profileRef.setValue(post) { (error, _) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        let trailMockup = CoreDataService.shared.mockSections()
        createTrail(trailMockup, profileRef: profileRef)
    }
    
    func saveLastErrorDate(date: Date, email: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium
        dateFormatter.locale = Locale.current
        let dateFormatted = dateFormatter.string(from: date)

        let post = ["lastError_date": dateFormatted]

        ref.child("users").child(email.replaceEmail()).child("user_life").updateChildValues(post) { (error, _) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func updateUserLifes(newLives: Int, email: String) {
        
        let post = ["current_life": newLives]
        
        ref.child("users").child(email.replaceEmail()).child("user_life").updateChildValues(post) { (err, _) in
            if let error = err {
                print(error.localizedDescription)
            }
        }
    }
    
    func updateUserBonusLife(newLives: Int, email: String) {
        
        let post = ["bonus_life": newLives]
        
        ref.child("users").child(email.replaceEmail()).child("user_life").updateChildValues(post) { (err, _) in
            if let error = err {
                print(error.localizedDescription)
            }
        }
    }

    func getUserLifes(email: String, completion: @escaping(Int, Int) -> Void) {
        var currentLife = 0
        var bonusLife = 0
        ref.child("users").child(email.replaceEmail()).child("user_life").observe(.value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            currentLife = value?["current_life"] as? Int ?? 0
            bonusLife = value?["bonus_Life"] as? Int ?? 0
            completion(currentLife, bonusLife)
        }
    }
    
    func acceptPending(source: String, target: String, name: String, phone: String) {
        
        var post = ["pending": ""]
        
        ref.child("users").child(source).updateChildValues(post) { (error, _) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        post = ["email": source,
                "name": name,
                "phone": phone]
        
        ref.child("users").child(target).child("professional_list").childByAutoId().setValue(post) { (error, _) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    /// Creates a default trail strucure
    /// - Parameters:
    ///   - trail: trail to be created
    ///   - profileRef: profile in which you want to save the trail
    func createTrail(_ trail: [TrailSection], profileRef: DatabaseReference) {
        var sectionsRef = profileRef.child("trail/sections")
        
        // Primeiro "for" percorre as seções da trilha
        for (index01,section) in trail.enumerated() {
            sectionsRef = sectionsRef.child("\(index01)")
            sectionsRef.setValue([
                "id": section.id.uuidString,
                "available": section.available,
                "currentLine": section.currentLine
            ])
            sectionsRef = sectionsRef.child("lines")
            
            // Segundo "for" percorre as linhas dentro de cada seção
            for (index02,line) in section.lines.enumerated() {
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
    
    /// Creates a default trail strucure
    /// - Parameters:
    ///   - trail: trail to be created
    ///   - userUid: id to append information
    func createTrail(_ trail: [TrailSection], userUid: String) {
        var sectionsRef = ref.child("users/\(userUid)/trail/sections")
        
        sectionsRef.keepSynced(true)
        
        // Primeiro "for" percorre as seções da trilha
        for (index01,section) in trail.enumerated() {
            sectionsRef = sectionsRef.child("\(index01)")
            sectionsRef.setValue([
                "id": section.id.uuidString,
                "available": section.available,
                "currentLine": section.currentLine
            ])
            sectionsRef = sectionsRef.child("lines")
            
            // Segundo "for" percorre as linhas dentro de cada seção
            for (index02,line) in section.lines.enumerated() {
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
    
    // ====================================
    // MARK: - Database fetch functions
    // ====================================
    
    func getUserProfile(userUid: String, completion: @escaping(AuthenticationProfile) -> Void) {
        var matrixList: [TrailSection] = []

        ref.child("users").child(userUid).observe(.value, with: { (snapshopt) in

            let value = snapshopt.value as? NSDictionary
            let email = userUid.replacingOccurrences(of: "(dot)", with: ".").lowercased()
            let name = value?["name"] as? String ?? ""
            let userLife = value?["user_life"] as? NSDictionary
            let lives = userLife?["current_life"] as? Int ?? 0
            let bonusLives = userLife?["bonus_life"] as? Int ?? 0
            let lastErrorDate = userLife?["lastError_date"] as? String ?? ""

            self.requestTrail(of: userUid) { (result) in
                switch result {
                case .success(let trail):
                    matrixList = trail
                case .failure:
                    matrixList = []
                }
                
                let profile = AuthenticationProfile(name: name, id: userUid, email: email,
                                                    lives: lives, bonusLife: bonusLives, trail: matrixList,
                                                    lastErrorDate: lastErrorDate)

                completion(profile)
            }
        })
    }
    
    func getPendingStatus(userUid: String, completion: @escaping(String) -> Void) {
        ref.child("users").child(userUid).observe(.value) { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                if let pendingEmail = value["pending"] as? String {
                    completion(pendingEmail)
                } else {
                    completion("")
                }
            }
        }
    }
    
    /// Request the user trail
    /// - Parameter profile: profile email
    func requestTrail(of profile: String, completion: @escaping(Result<[TrailSection], Error>) -> Void) {
        var trail = [TrailSection]()
        
        if profile.isEmpty {
            completion(.failure(MissingEmailError(title: "No such email")))
            return
        }
        
        //let handle =
            ref.child("users/\(profile)/trail").observe(.value, with: { (snapshot) in
            
            // Transforma snapshot vindo do Firebase para um dicionário
            if let value = snapshot.value as? [String: Any] {
                
                // Pega as seções como um array de dicinário
                if let sectionsDict = value["sections"] as? [[String: Any]] {
                    
                    // Itera sobre as seções existentes
                    for section in sectionsDict {
                        // Obtém os respectivos valores de cada seção
                        let available = section["available"] as? Bool ?? true
                        let currentLine = section["currentLine"] as? Int ?? 0
                        let id = section["id"] as? String ?? ""
                        let sectionId = UUID(uuidString: id)!
                        
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
                            
                            // Cria a seção com as respectivas linhas
                            let section = TrailSection(id: sectionId,
                                                       lines: linesObjects,
                                                       available: available,
                                                       currentLine: currentLine)
                            
                            // Adiciona a seção criada na trail
                            trail.append(section)
                        }
                    }
                }
            }
            
            completion(.success(trail))
        })
        
        // If does not want to update data in real time
        // ref.removeObserver(withHandle: handle)
    }
}
