//
//  TotemGameModel.swift
//  Loggio
//
//  Created by Annderson Packeiser Oreto on 17/09/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import Foundation

enum TotemShape: String, CaseIterable {
    case big = "big"
    case small = "small"
    case cupwing = "cupwing"
    case bigwing = "bigwing"
    case smallwing = "smallwing"
    case cup = "cup"
}

class TotemGameModel {
    
    final let MAX_TOTEM_PIECES: Int = 5
    final let TOTEM_ALTERNATIVES: Int = 4
    
    //TODO: Da pra usar isso pra trabalhar o esquema de level
    let NUM_WINGS = 1
    
    private var shapeArray: [TotemShape] = []
    private var faceArray: [[String]] = []
    private var colorArray: [String] = []
    
    init() {
        faceArray = [["face/big/01", "face/big/02", "face/big/03", "face/big/04", "face/big/05"],
                    ["face/small/01", "face/small/02", "face/small/03", "face/small/04", "face/small/05"]]
        shapeArray = TotemShape.allCases
        colorArray = ["01", "02", "03", "04", "05"]
    }
    
    func generateTotem() -> [TotemPiece] {
        var totemPieceList: [TotemPiece] = []
        var amountWings = 0
        var index = 0
        while index < MAX_TOTEM_PIECES {
            
            let shape = generateRandomTotemShape()
            
            if shape == .bigwing || shape == .cupwing || shape == .smallwing {
                if amountWings == NUM_WINGS {
                    continue
                }
                else {
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
    
    func generateAlternatives(with totemPieces: [TotemPiece]) -> [[String]] {
        
        var totemAlternativeList: [[String]] = []
        var index: Int = 0
        
        var totemPieceList = totemPieces
        
        while index < TOTEM_ALTERNATIVES {
            
            let totemUpTopImageNameList: [String] = totemPieceList.map( { $0.upTopShape } )
            
            totemAlternativeList.append(totemUpTopImageNameList)
            
            index += 1
            
            totemPieceList.shuffle()
        }
        
        totemAlternativeList.shuffle()
        return totemAlternativeList
    }
    
    func generateRandomTotemColor() -> String{
        return colorArray.randomElement() ?? "01"
    }
    
    func generateRandomTotemShape() -> TotemShape {
        return shapeArray.randomElement() ?? .big
    }
    
    func generateRandomTotemFace(totemShape: TotemShape) -> String{
        switch totemShape {
        case .big, .bigwing:
            return faceArray[0].randomElement() ?? "face/big/01"
        default:
            return faceArray[1].randomElement() ?? "face/small/01"
        }
    }
    
}
