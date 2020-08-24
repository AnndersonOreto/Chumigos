//
//  TrailSection.swift
//  Chumigos
//
//  Created by Marcus Vinicius Vieira Badiale on 24/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation

struct TrailSection: Identifiable {
    
    var id = UUID()
    var available = false
    var trail: [[GameObject]]
    
}
