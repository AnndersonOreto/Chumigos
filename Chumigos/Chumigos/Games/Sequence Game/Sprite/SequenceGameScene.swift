//
//  SequenceGameScene.swift
//  Chumigos
//
//  Created by Guilherme Piccoli on 17/07/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SpriteKit

class SequenceGameScene: SKScene {
    
    override func didMove(to view: SKView) {
        setupGame()
    }
    
    func setupGame() {
        
        if let sequence = Functions().generateSequence(num_of_patterns: 2, sizes: [3,2], repetition: 2) {
            
            var xPosition = self.frame.minX
            let yPosition = self.frame.midY
            
            for array in sequence {
                for item in array {
                    switch item {
                    case 1:
                        createSquare(color: .red, position: CGPoint(x: xPosition, y: yPosition))
                        xPosition += 120
                    case 2:
                        createSquare(color: .blue, position: CGPoint(x: xPosition, y: yPosition))
                        xPosition += 120
                    default:
                        createSquare(color: .green, position: CGPoint(x: xPosition, y: yPosition))
                        xPosition += 120
                    }
                }
            }
        }
    }
    
    func createSquare(color: UIColor, position: CGPoint) {
        let box = SKSpriteNode(color: color, size: CGSize(width: 100, height: 100))
        box.anchorPoint = CGPoint(x: 0, y: 0.5)
        box.position = position
        addChild(box)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
}
