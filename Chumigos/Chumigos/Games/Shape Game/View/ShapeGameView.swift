//
//  ShapeGameNewView.swift
//  Chumigos
//
//  Created by Arthur Bastos Fanck on 13/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

struct ShapeGameView: View {
    @ObservedObject var viewModel = ShapeGameViewModel()
    @State private var questionsFrames: [CGRect] = []
    
    var body: some View {
        // Main stack
        ZStack {
            // Stack to separate forms and alternatives list
            VStack {
                // Horizontal stack to show form pattern
                HStack {
                    // Build every form in the horizontal based on parameters of pattern
                    ForEach(viewModel.round) { (element) in
                        // Cell that represents the pattern list as a form
                        self.patternView(for: element)
                    }
                }
                
                // Alternatives
                HStack {
                    // Build every form in the horizontal based on parameters of pattern
                    ForEach(viewModel.alternatives) { (alternative) in
                        // Cell that represents the pattern list as a form
                        GenericForm(form: .POLYGON, sides: alternative.sides)
                            .fill(self.viewModel.randomColors[alternative.colorIndex])
                            .frame(width: UIScreen.main.bounds.width*0.1, height: UIScreen.main.bounds.height*0.1)
                            .draggable(onChanged: self.objectMoved, onEnded: self.objectDropped, answer: alternative.sides)
                    }
                }
            }
        }
    }
    
    func objectMoved(location: CGPoint, alternative: Int) -> DragState {
        
        if questionsFrames.firstIndex(where: {
            $0.contains(location) }) != nil {
            return .good
        } else {
            return .unknown
        }
    }
    
    func objectDropped(location: CGPoint, rect: CGRect, alternative: Int, dragState: DragState) -> (x: CGFloat, y: CGFloat) {
        
        if let match = questionsFrames.firstIndex(where: {
            $0.contains(location) }) {
            
            let newX = rect.midX.distance(to: questionsFrames[match].midX)
            let newY = rect.midY.distance(to: questionsFrames[match].midY)
            
            let newCGpoint = (x: newX, y: newY)
            
            return newCGpoint
            
        } else {
            return (x: CGFloat.zero, y: CGFloat.zero)
        }
    }
}

extension ShapeGameView {
    func patternView(for piece: ShapeGameModel.Shape) -> some View {
        ZStack {
            if !piece.isAQuestion {
                
                // Generic form to build sided forms
                GenericForm(form: .POLYGON, sides: piece.sides)
                    .fill(self.viewModel.randomColors[piece.colorIndex])
                    .frame(width: 94, height: 94)
            } else {
                
                // Form to guess
                Rectangle().frame(width: 94, height: 94)
                    .overlay(GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                self.questionsFrames.append(geo.frame(in: .global))
                        }
                    })
            }
        }
    }
}



struct ShapeGameNewView_Previews: PreviewProvider {
    static var previews: some View {
        ShapeGameView()
    }
}
