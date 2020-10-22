//
//  TotemGameModel.swift
//  Loggio
//
//  Created by Annderson Packeiser Oreto on 17/09/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import Foundation

enum TotemShape: String, CaseIterable {
    case big
    case small
    case cupwing
    case bigwing
    case smallwing
    case cup
}

class TotemGameModel {
    
    private let maxTotemPieces: Int = 5
    private let totemAlternatives: Int = 4
    
    private var difficulty: Difficulty
    private var colorArray: [String] = []
    private var faceArray: [[String]] = []
    private var numWings: Int = 0
    private var shapeArray: [TotemShape] = []
    
    private(set) var totemPieceList: [TotemPiece] = []
    private(set) var totemAlternativeList: [[String]] = []
    private(set) var correctUpTopTotem: [String] = []
    
    init(difficulty: Difficulty) {
        self.difficulty = difficulty
        
        setNumOfWings()
        
        faceArray = [["face/big/01", "face/big/02", "face/big/03", "face/big/04", "face/big/05"],
                     ["face/small/01", "face/small/02", "face/small/03", "face/small/04", "face/small/05"]]
        shapeArray = TotemShape.allCases
        colorArray = ["01", "02", "03", "04", "05"]
        
        totemPieceList = generateTotem()
        
        let response = generateAlternatives(with: totemPieceList)
        totemAlternativeList = response.alternatives
        correctUpTopTotem = response.correctAnswer
    }
    
    func setNumOfWings() {
        switch difficulty {
        case .easy:
            self.numWings = 0
        case .medium:
            self.numWings = 1
        case .hard:
            self.numWings = Bool.random() ? 1 : 2
        }
    }
    
    func generateTotem() -> [TotemPiece] {
        var totemPieceList: [TotemPiece] = []
        var amountWings = 0
        var index = 0
        while index < maxTotemPieces {
            
            let shape = generateRandomTotemShape()
            
            if shape == .bigwing || shape == .cupwing || shape == .smallwing {
                if amountWings == numWings {
                    continue
                } else {
                    amountWings += 1
                }
            }
            
            let color = colorArray[index]
            let face = generateRandomTotemFace(totemShape: shape)
            
            let piece = TotemPiece(shape: shape.rawValue, color: color, face: face, upTopShape: "topview/\(shape.rawValue)up/\(color)")
            
            if totemPieceList.contains(piece) {
                continue
            }
            
            totemPieceList.append(piece)
            index += 1
        }
        
        totemPieceList.shuffle()
        return totemPieceList
    }
    
    func generateAlternatives(with totemPieces: [TotemPiece]) -> (alternatives: [[String]], correctAnswer: [String]) {
        
        var totemAlternativeList: [[String]] = []
        var totemSmallPieceList: [String] = totemPieces.filter({ !$0.isBig }).map({ $0.upTopShape })
        var totemBigPieceList: [String] = totemPieces.filter({ $0.isBig }).map({ $0.upTopShape })
        var index: Int = 0
        
        let rightAnswer = totemPieces.map({ $0.upTopShape })
        totemAlternativeList.append(rightAnswer)
        
        var isElementEqualTo: Bool = false
        
        // Generate all alternatives except for the correct alternative
        while index < totemAlternatives-1 {
            
            totemSmallPieceList.shuffle()
            totemBigPieceList.shuffle()
            
            let totemUpTopImageNameList: [String] = totemSmallPieceList + totemBigPieceList
            
            if totemBigPieceList.isEmpty {
                
                let totemSmallPieceFirstElement: String = totemSmallPieceList[0]
                let smallAlternativeListFirstElements: [String] = totemAlternativeList.map({ $0[0] })
                
                for index in 0..<smallAlternativeListFirstElements.count {
                    if smallAlternativeListFirstElements[index] == totemSmallPieceFirstElement {
                        
                        isElementEqualTo = true
                        break
                    }
                }
            } else {
                guard let totemSmallPieceFirstElement: String = totemSmallPieceList.first else {
                    return self.generateAlternatives(with: totemPieces)
                }
                let totemBigPieceFirstElement: String = totemBigPieceList[0]
                let smallAlternativeListFirstElements: [String] = totemAlternativeList.map({ $0[0] })
                let bigAlternativeListFirstElements: [String] = totemAlternativeList.map({ $0.first {$0.contains("big")}! })
                
                for index in 0..<smallAlternativeListFirstElements.count {   
                    if smallAlternativeListFirstElements[index] == totemSmallPieceFirstElement &&
                        bigAlternativeListFirstElements[index] == totemBigPieceFirstElement {
                        isElementEqualTo = true
                        break
                    }
                }
            }
            
            if isElementEqualTo {
                isElementEqualTo = false
                continue
            }
            totemAlternativeList.append(totemUpTopImageNameList)
            
            index += 1
        }
        
        totemAlternativeList.shuffle()
        return (totemAlternativeList, rightAnswer)
    }
    
    /*
     // Generate all alternatives except for the correct alternative
     while index < TOTEM_ALTERNATIVES-1 {
     
     totemSmallPieceList.shuffle()
     totemBigPieceList.shuffle()
     
     let totemUpTopImageNameList: [String] = totemSmallPieceList + totemBigPieceList
     
     let totemSmallPieceFirstElement: String = totemSmallPieceList[0]
     let totemBigPieceFirstElement: String = totemBigPieceList[0]
     let smallAlternativeListFirstElements: [String] = totemAlternativeList.map( { $0[0] } )
     let bigAlternativeListFirstElements: [String] = totemAlternativeList.map( { $0[totemSmallPieceList.count] } )
     
     if smallAlternativeListFirstElements.contains(totemSmallPieceFirstElement) &&
     bigAlternativeListFirstElements.contains(totemBigPieceFirstElement) { continue }
     
     totemAlternativeList.append(totemUpTopImageNameList)
     
     index += 1
     }
     */
    
    func generateRandomTotemColor() -> String {
        return colorArray.randomElement() ?? "01"
    }
    
    func generateRandomTotemShape() -> TotemShape {
        return shapeArray.randomElement() ?? .big
    }
    
    func generateRandomTotemFace(totemShape: TotemShape) -> String {
        switch totemShape {
        case .big, .bigwing:
            return faceArray[0].randomElement() ?? "face/big/01"
        default:
            return faceArray[1].randomElement() ?? "face/small/01"
        }
    }
}
