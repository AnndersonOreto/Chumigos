////
////  User.swift
////  Chumigos
////
////  Created by Marcus Vinicius Vieira Badiale on 24/08/20.
////  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
////
//
//import Foundation
//
//// Not using this class yet!
//class User {
//
//    var environmentManager: EnvironmentManager!
//    static let shared = User()
//
////    var name: String
////    var lines: [TrailSection]
////
////    init(name: String, lines: [TrailSection]) {
////        self.name = name
////        self.lines = lines
////        self.shared = User(name: name, lines: lines)
////    }
//
//    private init() { }
//
//    var profile: AuthenticationProfile? {
//        guard let profile = environmentManager.profile else {
//            return nil
//        }
//        return profile
//    }
//
//    var name: String {
//        return profile?.name ?? ""
//    }
//
//    var email: String {
//        return profile?.email ?? ""
//    }
//
//    var lives: Int {
//        return profile?.lives ?? 5
//    }
//
//    var bonusLives: Int {
//        return profile?.bonusLives ?? 0
//    }
//
//    var isLogged: Bool {
//        guard let profile = environmentManager.profile else {
//            return false
//        }
//        return !profile.name.isEmpty
//    }
//
//    //Available next section
////    func makeNextSectionAvailable() {
////
////        //Get first section where isnt available
////        let nextSectionIndex = self.lines.firstIndex(where: {
////            $0.available == false
////        })
////
////        //set section for available
////        self.trail[nextSectionIndex ?? 0].available = true
////    }
//
//}
