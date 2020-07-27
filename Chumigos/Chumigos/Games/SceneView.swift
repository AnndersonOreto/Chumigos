//
//  SceneView.swift
//  Chumigos
//
//  Created by Guilherme Piccoli on 17/07/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation
import SpriteKit
import SwiftUI

/// Creates an SKView to contain the GameScene. This conforms to UIViewRepresentable, and so can be used within SwiftUI.
struct SceneView: UIViewRepresentable {
    
    let scene: SKScene
    
    func makeUIView(context: Context) -> SKView {
        // Let SwiftUI handle the sizing
        return SKView(frame: .zero)
    }
    
    func updateUIView(_ uiView: SKView, context: Context) {
        uiView.presentScene(scene)
    }
}
