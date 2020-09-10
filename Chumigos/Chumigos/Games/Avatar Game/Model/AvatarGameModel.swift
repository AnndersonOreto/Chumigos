//
//  AvatarGameModel.swift
//  Chumigos
//
//  Created by Arthur Bastos Fanck on 08/09/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation

enum Feelings: String, CaseIterable {
    case happy = "Feliz"
    case sad = "Triste"
    case angry = "Raivoso"
    case fearful = "Medroso"
    case uncertain = "Incerto"
    case calm = "Calmo"
    case sleepy = "Sonolento"
    case surprised = "Surpreso"
    case embarrassed = "Envergonhado"
    case sick = "Enjoado"
    case indifferent = "Indiferente"
}

class AvatarGameModel {
    
    let randomFeeling = Feelings.allCases.randomElement()
    
    var allEyes: [FacePart] {
        let eye1 = FacePart(partOfFace: .eye, image: "01")
        let eye2 = FacePart(partOfFace: .eye, image: "02")
        let eye3 = FacePart(partOfFace: .eye, image: "03")
        let eye4 = FacePart(partOfFace: .eye, image: "04")
        let eye5 = FacePart(partOfFace: .eye, image: "05")
        let eye6 = FacePart(partOfFace: .eye, image: "06")
        let eye7 = FacePart(partOfFace: .eye, image: "07")
        let eye8 = FacePart(partOfFace: .eye, image: "08")
        let eye9 = FacePart(partOfFace: .eye, image: "09")
        let eye10 = FacePart(partOfFace: .eye, image: "10")
        let eye11 = FacePart(partOfFace: .eye, image: "11")
        let eye12 = FacePart(partOfFace: .eye, image: "12")
        let eye13 = FacePart(partOfFace: .eye, image: "13")
        return [eye1, eye2, eye3, eye4, eye5, eye6, eye7, eye8, eye9, eye10, eye11, eye12, eye13]
    }
    var allEyebrows: [FacePart] {
        let eyebrow1 = FacePart(partOfFace: .eyebrow, image: "01")
        let eyebrow2 = FacePart(partOfFace: .eyebrow, image: "02")
        let eyebrow3 = FacePart(partOfFace: .eyebrow, image: "03")
        let eyebrow4 = FacePart(partOfFace: .eyebrow, image: "04")
        let eyebrow5 = FacePart(partOfFace: .eyebrow, image: "05")
        let eyebrow6 = FacePart(partOfFace: .eyebrow, image: "06")
        return [eyebrow1, eyebrow2, eyebrow3, eyebrow4, eyebrow5, eyebrow6]
    }
    var allMouths: [FacePart] {
        let mouth1 = FacePart(partOfFace: .mouth, image: "01")
        let mouth2 = FacePart(partOfFace: .mouth, image: "02")
        let mouth3 = FacePart(partOfFace: .mouth, image: "03")
        let mouth4 = FacePart(partOfFace: .mouth, image: "04")
        let mouth5 = FacePart(partOfFace: .mouth, image: "05")
        let mouth6 = FacePart(partOfFace: .mouth, image: "06")
        let mouth7 = FacePart(partOfFace: .mouth, image: "07")
        let mouth8 = FacePart(partOfFace: .mouth, image: "08")
        let mouth9 = FacePart(partOfFace: .mouth, image: "09")
        let mouth10 = FacePart(partOfFace: .mouth, image: "10")
        let mouth11 = FacePart(partOfFace: .mouth, image: "11")
        let mouth12 = FacePart(partOfFace: .mouth, image: "12")
        let mouth13 = FacePart(partOfFace: .mouth, image: "13")
        let mouth14 = FacePart(partOfFace: .mouth, image: "14")
        return [mouth1,  mouth2,  mouth3,  mouth4, mouth5, mouth6, mouth7, mouth8, mouth9, mouth10, mouth11,  mouth12, mouth13, mouth14]
    }
    var roundFaceParts: [FacePart] = []
    
    init() {
        generateRoundFaceParts()
    }
    
    func generateRoundFaceParts() {
        
        var facePartsArray: [FacePart] = []
        
        var allEyes = self.allEyes
        var allEyebrows = self.allEyebrows
        var allMouths = self.allMouths
        
        for _ in 0...3{
            //Generate Random Eye
            let randomEyeIndex = Int.random(in: 0..<allEyes.count)
            let randomEye = allEyes.remove(at: randomEyeIndex)
            facePartsArray.append(randomEye)
            
            //Generate Random Eyebrow
            let randomEyebrowIndex = Int.random(in: 0..<allEyebrows.count)
            let randomEyebrow = allEyebrows.remove(at: randomEyebrowIndex)
            facePartsArray.append(randomEyebrow)
            
            //Generate Random Mouth
            let randomMouthIndex = Int.random(in: 0..<allMouths.count)
            let randomMouth = allMouths.remove(at: randomMouthIndex)
            facePartsArray.append(randomMouth)
        }
        
        self.roundFaceParts = facePartsArray
    }
}


enum PartsOfFace {
    case eye, eyebrow, mouth
}

struct FacePart: Hashable {
    var partOfFace: PartsOfFace
    var image: String
}

