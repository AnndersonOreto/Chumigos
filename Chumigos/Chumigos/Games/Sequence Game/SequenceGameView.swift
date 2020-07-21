//
//  SequenceGameView.swift
//  Chumigos
//
//  Created by Guilherme Piccoli on 17/07/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

struct SequenceGameView: View {
    
    var body: some View {
//        SceneView(scene: SequenceGameScene()).edgesIgnoringSafeArea(.all)
        SequenceView()
    }
}

struct SequenceGameView_Previews: PreviewProvider {
    static var previews: some View {
        SequenceGameView()
    }
}
