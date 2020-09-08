//
//  AvatarGameModel.swift
//  Chumigos
//
//  Created by Arthur Bastos Fanck on 08/09/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation

enum PartsOfFace {
    case eye, eyebrow, mouth
}

struct FacePart {
    var partOfFace: PartsOfFace
    var image: String
}
