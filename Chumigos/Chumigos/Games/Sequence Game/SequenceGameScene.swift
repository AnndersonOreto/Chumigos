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
        let box = SKSpriteNode(color: UIColor.red, size: CGSize(width: 0.90, height: 0.90))
        box.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        addChild(box)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
}
