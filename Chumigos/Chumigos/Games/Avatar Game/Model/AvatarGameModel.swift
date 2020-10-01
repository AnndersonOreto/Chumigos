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
        let eye1 = FacePart(partOfFace: .eye, image: "01", feelings: [.happy, .surprised, .uncertain])
        let eye2 = FacePart(partOfFace: .eye, image: "02", feelings: [.embarrassed, .happy, .sad])
        let eye3 = FacePart(partOfFace: .eye, image: "03", feelings: [.happy])
        let eye4 = FacePart(partOfFace: .eye, image: "04", feelings: [.fearful, .sad])
        let eye5 = FacePart(partOfFace: .eye, image: "05", feelings: [.calm, .sad])
        let eye6 = FacePart(partOfFace: .eye, image: "06", feelings: [.angry])
        let eye7 = FacePart(partOfFace: .eye, image: "07", feelings: [])
        let eye8 = FacePart(partOfFace: .eye, image: "08", feelings: [.fearful])
        let eye9 = FacePart(partOfFace: .eye, image: "09", feelings: [.indifferent])
        let eye10 = FacePart(partOfFace: .eye, image: "10", feelings: [.sick, .surprised, .uncertain])
        let eye11 = FacePart(partOfFace: .eye, image: "11", feelings: [.calm])
        let eye12 = FacePart(partOfFace: .eye, image: "12", feelings: [.calm, .sleepy])
        let eye13 = FacePart(partOfFace: .eye, image: "13", feelings: [.embarrassed])
        return [eye1, eye2, eye3, eye4, eye5, eye6, eye7, eye8, eye9, eye10, eye11, eye12, eye13]
    }
    var allEyebrows: [FacePart] {
        let eyebrow1 = FacePart(partOfFace: .eyebrow, image: "01",
                                feelings: [.embarrassed, .happy])
        let eyebrow2 = FacePart(partOfFace: .eyebrow, image: "02", feelings: [.fearful, .sad])
        let eyebrow3 = FacePart(partOfFace: .eyebrow, image: "03", feelings: [.uncertain])
        let eyebrow4 = FacePart(partOfFace: .eyebrow, image: "04", feelings: [.angry])
        let eyebrow5 = FacePart(partOfFace: .eyebrow, image: "05", feelings: [.indifferent])
        let eyebrow6 = FacePart(partOfFace: .eyebrow, image: "06", feelings: [.calm, .embarrassed, .happy, .sleepy, .surprised])
        return [eyebrow1, eyebrow2, eyebrow3, eyebrow4, eyebrow5, eyebrow6]
    }
    var allMouths: [FacePart] {
        let mouth1 = FacePart(partOfFace: .mouth, image: "01", feelings: [.calm, .happy])
        let mouth2 = FacePart(partOfFace: .mouth, image: "02", feelings: [.happy])
        let mouth3 = FacePart(partOfFace: .mouth, image: "03", feelings: [.surprised])
        let mouth4 = FacePart(partOfFace: .mouth, image: "04", feelings: [.sleepy])
        let mouth5 = FacePart(partOfFace: .mouth, image: "05", feelings: [.sad])
        let mouth6 = FacePart(partOfFace: .mouth, image: "06", feelings: [.surprised])
        let mouth7 = FacePart(partOfFace: .mouth, image: "07", feelings: [.indifferent, .uncertain])
        let mouth8 = FacePart(partOfFace: .mouth, image: "08", feelings: [.calm])
        let mouth9 = FacePart(partOfFace: .mouth, image: "09", feelings: [.embarrassed])
        let mouth10 = FacePart(partOfFace: .mouth, image: "10", feelings: [.embarrassed, .fearful])
        let mouth11 = FacePart(partOfFace: .mouth, image: "11", feelings: [.sad])
        let mouth12 = FacePart(partOfFace: .mouth, image: "12", feelings: [.indifferent, .uncertain])
        let mouth13 = FacePart(partOfFace: .mouth, image: "13", feelings: [.angry])
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
        #warning("Random element sometimes crash")
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
        
        return parts.shuffled()
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
