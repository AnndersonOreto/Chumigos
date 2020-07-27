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
            
            // Stack to separate forms and alternatives list
            VStack {
                
                // Horizontal stack to show form pattern
                HStack {
                    
                    // Build every form in the horizontal based on parameters of pattern
                    ForEach(viewModel.roundList.indices, id: \.self) { (index) in
                        
                        // Cell that represents the pattern list as a form
                        PatternForm(viewModel: self.viewModel, index: index)
                    }
                }
                
                // Horizontal stack to show alternatives
                HStack {
                    
                    // Build every form in the horizontal based on parameters of pattern
                    ForEach(viewModel.alternativeList.indices, id: \.self) { (index) in
                        
                        // Cell that represents the pattern list as a form
                        GenericForm(form: .POLYGON, sides: self.viewModel.alternativeList[index].formSizes)
                            .fill(self.viewModel.alternativeList[index].color)
                        .frame(width: 94, height: 94)
                    }
                }
            }
        }
    }
}

struct PatternForm: View {
    
    @ObservedObject var viewModel: ShapeGameViewModel
    var index: Int
    
    var body: some View {
        
        // Main pattern form stack
        ZStack {
            
            if self.viewModel.roundList[index] != self.viewModel.answer {
                
                // Generic form to build sided forms
                GenericForm(form: .POLYGON, sides: self.viewModel.roundList[index].formSizes)
                    .fill(self.viewModel.roundList[index].color)
                    .frame(width: 94, height: 94)
            } else {
                
                // Form to guess
                Rectangle().frame(width: 94, height: 94)
            }
        }
    }
}

struct ShapeGameView_Previews: PreviewProvider {
    static var previews: some View {
        ShapeGameView()
    }
}
