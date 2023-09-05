//
//  AvatarGameViewModel.swift
//  Chumigos
//
//  Created by Marcus Vinicius Vieira Badiale on 09/09/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

class AvatarGameViewModel: ObservableObject {
    
    @Published var model: AvatarGameModel
    @Published var eyeImage: String = ""
    @Published var mouthImage: String = ""
    @Published var eyebrowImage: String = ""
    @Published var confirmPressed: Bool = false
    @Published var finishedPrediction: Bool = false
    @Published var environmentManager: EnvironmentManager?
    @Published var haveLifeToPlay: Bool = true
    
    let difficulty: Difficulty
    
    var game: GameObject
    var gameState: GameState = .NORMAL
    var gameScore: GameScore = GameScore()
    var mostLikelyFeeling: String?
    var randomFeelings: [Feelings]
    var round: Int = 0
    var wrongAnswers: [(model: AvatarGameModel, index: Int)] = []
    
    init(game: GameObject, difficulty: Difficulty) {
        self.randomFeelings = Feelings.randomFeelings(quantity: 5)
        self.model = AvatarGameModel(feeling: randomFeelings[round])
        self.game = game
        self.difficulty = difficulty
    }
    
    // MARK: - Access the model
    var feeling: Feelings {
        model.randomFeeling
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
    
    // MARK: - Function(s)
    
    func allOptionsSelected() -> Bool {
        let eyeSelected: Bool = !eyeImage.isEmpty
        let eyebrownSelected: Bool = !eyebrowImage.isEmpty
        let mouthSelected: Bool = !mouthImage.isEmpty
        return eyeSelected && eyebrownSelected && mouthSelected
    }
    
    func faceIsCorrect() -> Bool {
        // Compare the round feeling with the feeling that the model has predicted.
        let feeling = self.feeling.rawValue.lowercased()
        let mostLikely = self.mostLikelyFeeling?.lowercased()
        return feeling == mostLikely
    }
    
    // MARK: - Reset & Restart Game
    func resetGame() {
        if gameState == .NORMAL {
            round += 1
            model = AvatarGameModel(feeling: randomFeelings[round])
        } else {
            if wrongAnswers.isEmpty { return }
            
            if let first = wrongAnswers.first {
                round = first.index
                model = first.model
            }
        }
        resetVariables()
    }
    
    func restartGame() {
        self.round = 0
        self.randomFeelings = Feelings.randomFeelings(quantity: 5)
        self.model = AvatarGameModel(feeling: randomFeelings[round])
        self.wrongAnswers = []
        self.gameState = .NORMAL
        self.gameScore = GameScore()
        self.resetVariables()
    }
    
    func resetVariables() {
        eyeImage =  ""
        mouthImage = ""
        eyebrowImage = ""
        confirmPressed = false
        finishedPrediction = false
    }
    
    // MARK: - Recap function(s)
    func getRecapIndex() -> Int {
        if gameState == .RECAP && !wrongAnswers.isEmpty {
            return wrongAnswers.first!.index
        }
        return -1
    }
    
    func removeRecapGame() {
        if gameState == .RECAP && !wrongAnswers.isEmpty {
            wrongAnswers.removeFirst()
        }
    }
    
    func ifWrongAddAnswer(with index: Int) {
        if !faceIsCorrect() && gameState == .NORMAL {
            wrongAnswers.append((model: self.model, index: index))
        }
    }
    
    // MARK: - Score function(s)
    func changeGameScore() {
        if self.faceIsCorrect() {
            if self.gameState == .NORMAL {
                self.gameScore.incrementDefaultScore()
            } else {
                self.gameScore.incrementRecapScore()
            }
        } else {
            self.gameScore.disableStreak()
            self.environmentManager?.profile?.lifeManager.decreaseLife()
            self.haveLifeToPlay = environmentManager?.profile?.lifeManager.haveLifeToPlay ?? true
        }
    }
    
    // MARK: - ML auxiliary function(s)
    
    // only show answer when confirm is pressed and prediction has ended
    func canShowResult() -> Bool {
        return confirmPressed && finishedPrediction
    }
    
    // Crop just the face of the avatar
    func cropFaceOfAvatar(image: UIImage) {
        let imageWidth = image.size.width
        let width: CGFloat = imageWidth*0.4
        let height: CGFloat = imageWidth*0.4
        let origin = CGPoint(x: (imageWidth - width)/2.15, y: height/1.7)
        let size = CGSize(width: width, height: height)
        let avatarFaceImage = image.crop(rect: CGRect(origin: origin, size: size))
        
        // calling prediction
        performPrediction(avatarFaceImage)
    }
    
    func performPrediction(_ image: UIImage?) {
        // make sure that conversion of the image works as we expected.
        guard let imageToConvert =  image,
        let resizedImage = imageToConvert.resizeTo(CGSize(width: 299, height: 299)),
        let buffer = resizedImage.toBuffer() else {
            return
        }
        // performing prediction of the most likelu feeling and saving
        self.mostLikelyFeeling = FeelingClassificator.mostLikely(buffer)
        
        // make sure that the View only updates when prediction has ended
        self.finishedPrediction = true
    }
}
