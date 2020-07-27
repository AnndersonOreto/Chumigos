//
//  SequenceGameView.swift
//  Chumigos
//
//  Created by Guilherme Piccoli on 17/07/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI
import SpriteKit

struct SequenceGameView: View {
    
    @State var scene: SKScene = {
        let scene = SequenceGameScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .aspectFit
        return scene
    }()
    
    var body: some View {
//        SceneView(scene: scene).edgesIgnoringSafeArea(.all)
        SequenceView()
    }
}

struct SequenceGameView_Previews: PreviewProvider {
    static var previews: some View {
        SequenceGameView()
    }
}
