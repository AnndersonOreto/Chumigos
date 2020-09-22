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
    @Published var avatarFaceImage: UIImage?
    
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
    
    func cropFaceOfAvatar(image: UIImage) {
        let imageWidth = image.size.width
        let width: CGFloat = imageWidth*0.4
        let height: CGFloat = imageWidth*0.4
        let origin = CGPoint(x: (imageWidth - width)/2.15, y: height/1.7)
        let size = CGSize(width: width, height: height)
        self.avatarFaceImage = image.crop(rect: CGRect(origin: origin, size: size))
    }
    
    func testingMLModel() {
        if let faceImage = avatarFaceImage, let cgFaceImage = faceImage.cgImage {
            let rawValue = UInt32(faceImage.imageOrientation.rawValue)
            if let orientation = CGImagePropertyOrientation(rawValue: rawValue) {
                FeelingsClassifier.classifyImage(cgFaceImage, orientation: orientation)
            }
        }
    }
    
}
