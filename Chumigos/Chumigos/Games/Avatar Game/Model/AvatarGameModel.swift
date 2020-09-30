//
//  AvatarGameModel.swift
//  Chumigos
//
//  Created by Arthur Bastos Fanck on 08/09/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation

enum Feelings: String, CaseIterable {
    case angry = "Raivoso"
    case calm = "Calmo"
    case embarrassed = "Envergonhado"
    case fearful = "Medroso"
    case happy = "Feliz"
    case indifferent = "Indiferente"
    case sad = "Triste"
    case sick = "Enjoado"
    case sleepy = "Sonolento"
    case surprised = "Surpreso"
    case uncertain = "Incerto"
}

class AvatarGameModel {
    
    let randomFeeling = Feelings.allCases.randomElement()
    
    var allEyes: [FacePart] {
        let eye1 = FacePart(partOfFace: .eye, image: "01", feelings: [.angry, .fearful, .happy, .sad, .sick, .surprised, .uncertain])
        let eye2 = FacePart(partOfFace: .eye, image: "02", feelings: [.angry, .embarrassed, .fearful, .happy, .sad, .sick, .surprised])
        let eye3 = FacePart(partOfFace: .eye, image: "03", feelings: [.angry, .happy, .sad])
        let eye4 = FacePart(partOfFace: .eye, image: "04", feelings: [.sad])
        let eye5 = FacePart(partOfFace: .eye, image: "05", feelings: [.calm, .happy, .indifferent, .sad])
        let eye6 = FacePart(partOfFace: .eye, image: "06", feelings: [.angry])
        let eye7 = FacePart(partOfFace: .eye, image: "07", feelings: [.angry, .calm, .happy, .sad, .sleepy])
        let eye8 = FacePart(partOfFace: .eye, image: "08", feelings: [.angry, .fearful, .sad, .sick, .surprised])
        let eye9 = FacePart(partOfFace: .eye, image: "09", feelings: [.indifferent, .uncertain])
        let eye10 = FacePart(partOfFace: .eye, image: "10", feelings: [.angry, .fearful, .sick, .surprised, .uncertain])
        let eye11 = FacePart(partOfFace: .eye, image: "11", feelings: [.calm, .indifferent, .sleepy, .uncertain])
        let eye12 = FacePart(partOfFace: .eye, image: "12", feelings: [.calm, .sad, .sick, .sleepy])
        let eye13 = FacePart(partOfFace: .eye, image: "13", feelings: [.angry, .embarrassed, .fearful, .happy, .sad, .sick, .surprised, .uncertain])
        return [eye1, eye2, eye3, eye4, eye5, eye6, eye7, eye8, eye9, eye10, eye11, eye12, eye13]
    }
    var allEyebrows: [FacePart] {
        let eyebrow1 = FacePart(partOfFace: .eyebrow, image: "01",
                                feelings: [.calm, .embarrassed, .fearful, .happy,
                                           .indifferent, .sad, .sick, .sleepy, .surprised])
        let eyebrow2 = FacePart(partOfFace: .eyebrow, image: "02", feelings: [.embarrassed, .fearful, .indifferent, .sad, .sick, .surprised])
        let eyebrow3 = FacePart(partOfFace: .eyebrow, image: "03", feelings: [.indifferent, .uncertain])
        let eyebrow4 = FacePart(partOfFace: .eyebrow, image: "04", feelings: [.angry])
        let eyebrow5 = FacePart(partOfFace: .eyebrow, image: "05", feelings: [.happy, .indifferent, .sleepy])
        let eyebrow6 = FacePart(partOfFace: .eyebrow, image: "06", feelings: [.calm, .embarrassed, .happy, .indifferent, .sick, .sleepy, .surprised])
        return [eyebrow1, eyebrow2, eyebrow3, eyebrow4, eyebrow5, eyebrow6]
    }
    var allMouths: [FacePart] {
        let mouth1 = FacePart(partOfFace: .mouth, image: "01", feelings: [.calm, .happy])
        let mouth2 = FacePart(partOfFace: .mouth, image: "02", feelings: [.calm, .happy])
        let mouth3 = FacePart(partOfFace: .mouth, image: "03", feelings: [.angry, .surprised])
        let mouth4 = FacePart(partOfFace: .mouth, image: "04", feelings: [.sleepy, .surprised])
        let mouth5 = FacePart(partOfFace: .mouth, image: "05", feelings: [.sad])
        let mouth6 = FacePart(partOfFace: .mouth, image: "06", feelings: [.surprised])
        let mouth7 = FacePart(partOfFace: .mouth, image: "07", feelings: [.embarrassed, .indifferent, .sad, .uncertain])
        let mouth8 = FacePart(partOfFace: .mouth, image: "08", feelings: [.calm, .embarrassed, .happy])
        let mouth9 = FacePart(partOfFace: .mouth, image: "09", feelings: [.calm, .embarrassed, .happy])
        let mouth10 = FacePart(partOfFace: .mouth, image: "10", feelings: [.embarrassed, .fearful])
        let mouth11 = FacePart(partOfFace: .mouth, image: "11", feelings: [.sad])
        let mouth12 = FacePart(partOfFace: .mouth, image: "12", feelings: [.angry, .embarrassed, .indifferent, .sad, .uncertain])
        let mouth13 = FacePart(partOfFace: .mouth, image: "13", feelings: [.angry, .sad])
        let mouth14 = FacePart(partOfFace: .mouth, image: "14", feelings: [.sick])
        return [mouth1,  mouth2,  mouth3,  mouth4, mouth5, mouth6, mouth7, mouth8, mouth9, mouth10, mouth11,  mouth12, mouth13, mouth14]
    }
    
    var roundFaceParts: [FacePart] = []
    
    init() {
        generateRoundFaceParts()
    }
    
    func generateRoundFaceParts() {
        
        var facePartsArray: [FacePart] = []
        
        // Generating each part
        let eyebrows = self.generate(faceParts: self.allEyebrows)
        let eyes = self.generate(faceParts: self.allEyes)
        let mouths = self.generate(faceParts: self.allMouths)
        
        facePartsArray.append(contentsOf: eyebrows)
        facePartsArray.append(contentsOf: eyes)
        facePartsArray.append(contentsOf: mouths)
        
        self.roundFaceParts = facePartsArray
    }
    
    func generate(faceParts: [FacePart]) -> [FacePart] {
        // Generating Correct Part
        let part = faceParts.filter({$0.feelings.contains(randomFeeling ?? .happy)}).randomElement()!
        var parts: [FacePart] = [part]
        
        // Removing correct part of the array
        var filteredParts = faceParts.filter({$0 != part})
        
        //Generating Random Parts
        for _ in 0...2 {
            let randomPartIndex = Int.random(in: 0..<filteredParts.count)
            let randomPart = filteredParts.remove(at: randomPartIndex)
            parts.append(randomPart)
        }
        
        return parts
    }
}

enum PartsOfFace {
    case eye, eyebrow, mouth
}

struct FacePart: Hashable {
    var partOfFace: PartsOfFace
    var image: String
    var feelings: [Feelings]
}
