//
//  TotemPiece.swift
//  Loggio
//
//  Created by Annderson Packeiser Oreto on 23/09/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import Foundation

struct TotemPiece: Hashable, Identifiable {
    
    // *****************************
    // MARK: - Totem image variables
    // *****************************
    var id = UUID()
    var shape: String // If it is big, small or has wings
    var color: String // If big it has 5 colors
    var face: String // Totem's face
    var upTopShape: String // Up top totem view representation
    var imageName: String = ""
    var isBig: Bool = false
    
    init(shape: String, color: String, face: String, upTopShape: String) {
        self.shape = shape
        self.color = color
        self.face = face
        self.upTopShape = upTopShape
        imageName = "\(self.shape)/\(self.color)"
        self.isBig = shape.contains("big")
    }
}
