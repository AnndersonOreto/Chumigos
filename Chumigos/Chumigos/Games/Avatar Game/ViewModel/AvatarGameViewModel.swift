//
//  AvatarGameViewModel.swift
//  Chumigos
//
//  Created by Marcus Vinicius Vieira Badiale on 09/09/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation

class AvatarGameViewModel: ObservableObject {
    
    @Published var model = createAvatarGame()
    
    @Published var eyeImage: String = ""
    @Published var mouthImage: String = ""
    @Published var eyebrowImage: String = ""
    
    private static func createAvatarGame() -> AvatarGameModel {
        return AvatarGameModel()
    }
    
    //Variables
    var feeling: Feelings {
        model.randomFeeling ?? Feelings.happy
    }
    
    var roundFaceParts: [FacePart] {
        model.roundFaceParts
    }
    
    //Functions
    func allOptionsSelected() -> Bool {
        let eyeSelected: Bool = eyeImage != ""
        let eyebrownSelected: Bool = eyebrowImage != ""
        let mouthSelected: Bool = mouthImage != ""
        return eyeSelected && eyebrownSelected && mouthSelected
    }
    
    func nextRound() {
        model = AvatarGameViewModel.createAvatarGame()
        eyeImage =  ""
        mouthImage = ""
        eyebrowImage = ""
    }
    
}
