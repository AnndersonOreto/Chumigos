//
//  ShapeGameView.swift
//  Chumigos
//
//  Created by Annderson Packeiser Oreto on 24/07/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

struct ShapeGameView: View {
    
    @ObservedObject var viewModel = ShapeGameViewModel()
    
    var body: some View {
        
        // Main stack
        ZStack {
            
            // Horizontal stack to show elements aligned
            HStack {
                
                // Build every form in the horizontal based on parameters of pattern
                ForEach(viewModel.roundList.indices, id: \.self) { (index) in
                    
                    // Generic form to build sided forms
                    GenericForm(form: .POLYGON, sides: self.viewModel.roundList[index])
                        .fill(self.viewModel.colorList[index])
                        .rotationEffect(Angle.randomDefinedAngle())
                    .frame(width: 94, height: 94)
                }
            }
        }
    }
}

struct ShapeGameView_Previews: PreviewProvider {
    static var previews: some View {
        ShapeGameView()
    }
}
