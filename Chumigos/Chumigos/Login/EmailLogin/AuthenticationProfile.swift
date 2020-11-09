//
//  AuthenticationManager.swift
//  Loggio
//
//  Created by Annderson Packeiser Oreto on 14/10/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import Foundation
import Combine

class AuthenticationProfile {
    
    var id: String
    var email: String?
    var name: String = ""
    var phone: String = ""
    var role: String = ""
    var pending: String = ""
    var lives: Int = 0
    var trail: [TrailSection] = []
//    @Published var feelings: FeelingsInfoArray = FeelingsInfoArray(user_array: [])
//    @Published var patients: [Patient] = []
    
    init(id: String, email: String?, lives: Int, trail: [TrailSection]) {
        
        self.id = id
        self.email = email
        self.trail = trail
        self.lives = lives
    }
    
    init(id: String, email: String?, name: String, phone: String, role: String, pending: String) {
        
        self.id = id
        self.email = email
        self.name = name
        self.phone = phone
        self.role = role
        self.pending = pending
    }
    
    func saveGameObject(_ gameObject: GameObject) {
        
        #warning("Muitos for aninhados! Precisamos refatorar.")
        for section in 0..<trail.count {
            for line in 0..<trail[section].lines.count {
                for column in 0..<trail[section].lines[line].count {
                    let game = trail[section].lines[line][column]
                    if game.id == gameObject.id {
                        trail[section].lines[line][column] = gameObject
                    }
                }
            }
        }
    }
    
//    init(id: String, email: String?, name: String, phone: String, role: String, pending: String, patients: [Patient]) {
//        
//        self.id = id
//        self.email = email
//        self.name = name
//        self.phone = phone
//        self.role = role
//        self.pending = pending
//        self.patients = patients
//    }
//    
//    func setPatients(_ patients: [Patient]) {
//        self.patients = patients
//    }
}
