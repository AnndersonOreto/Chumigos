//
//  User.swift
//  Chumigos
//
//  Created by Marcus Vinicius Vieira Badiale on 24/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation

class User {
    
    var name: String
    var trail: [TrailSection]
    
    init(name: String, trail: [TrailSection]) {
        self.name = name
        self.trail = trail
    }
    
    //Available next section
    func makeNextSectionAvailable() {
        
        //Get first section where isnt available
        let nextSectionIndex = self.trail.firstIndex(where: {
            $0.available == false
        })
        
        //set section for available
        self.trail[nextSectionIndex ?? 0].available = true
    }
    
}
