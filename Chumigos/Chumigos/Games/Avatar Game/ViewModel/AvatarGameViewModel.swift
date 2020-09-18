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
    
    var gameState: GameState = .NORMAL
    var gameScore: GameScore = GameScore()
    
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
    
    var allEyes: [FacePart] {
        model.allEyes
    }
    
    var allEyebrows: [FacePart] {
        model.allEyebrows
    }
    
    var allMouths: [FacePart] {
        model.allMouths
    }
    
    //Functions
    func allOptionsSelected() -> Bool {
        let eyeSelected: Bool = eyeImage != ""
        let eyebrownSelected: Bool = eyebrowImage != ""
        let mouthSelected: Bool = mouthImage != ""
        return eyeSelected && eyebrownSelected && mouthSelected
    }
    
    func faceIsCorrect() -> Bool {
        return model.verifyFace()
    }
    
    func getRecapIndex() -> Int {
        return -1
    }
    
    func resetGame() {
        model = AvatarGameViewModel.createAvatarGame()
        eyeImage =  ""
        mouthImage = ""
        eyebrowImage = ""
    }
    
    func changeGameScore() {
        if self.faceIsCorrect() {
            if self.gameState == .NORMAL {
                self.gameScore.incrementDefaultScore()
            } else {
                self.gameScore.incrementRecapScore()
            }
        } else {
            self.gameScore.disableStreak()
        }
    }
    
}
