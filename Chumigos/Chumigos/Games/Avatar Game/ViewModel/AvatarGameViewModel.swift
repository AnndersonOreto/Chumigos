//
//  AvatarGameViewModel.swift
//  Chumigos
//
//  Created by Marcus Vinicius Vieira Badiale on 09/09/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation
import UIKit

class AvatarGameViewModel: ObservableObject {
    
    @Published var model = createAvatarGame()
    
    @Published var eyeImage: String = ""
    @Published var mouthImage: String = ""
    @Published var eyebrowImage: String = ""
    @Published var confirmPressed: Bool = false
    @Published var finishedPrediction: Bool = false
    
    var gameState: GameState = .NORMAL
    var gameScore: GameScore = GameScore()
    var mostLikelyFeeling: String?
    
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
        // Compare the round feeling with the feeling that the model has predicted.
        let feeling = self.feeling.rawValue.lowercased()
        let mostLikely = self.mostLikelyFeeling?.lowercased()
        return feeling == mostLikely
    }
    
    func getRecapIndex() -> Int {
        return -1
    }
    
    func resetGame() {
        model = AvatarGameViewModel.createAvatarGame()
        eyeImage =  ""
        mouthImage = ""
        eyebrowImage = ""
        confirmPressed = false
        finishedPrediction = false
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
        performPediction(avatarFaceImage)
    }
    
    
    func performPediction(_ image: UIImage?) {
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
