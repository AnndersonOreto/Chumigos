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
    @State var geometryRect: CGRect = .zero
    
    @State var answersFrames: [CGRect] = []
    
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
                        PatternForm(viewModel: self.viewModel, answersFrames: self.$answersFrames, index: index)
                    }
                }
                
                // Alternatives
                HStack {
                    
                    // Build every form in the horizontal based on parameters of pattern
                    ForEach(viewModel.alternativeList.indices, id: \.self) { (index) in
                        
                        // Cell that represents the pattern list as a form
                        DraggableObject(content: {
                            GenericForm(form: .POLYGON, sides: self.viewModel.alternativeList[index].formSizes)
                                .fill(self.viewModel.alternativeList[index].color)
                                .frame(width: 94, height: 94)
                            },
                            onChanged: self.objectMoved, onEnded: self.objectDropped)
                    }
                }
            }
        }
    }
    
    func objectMoved(location: CGPoint) -> DragState {
        
        if answersFrames.firstIndex(where: {
            $0.contains(location) }) != nil {
            return .good
        } else {
            return .unknown
        }
    }
    
    func objectDropped(location: CGPoint, rect: CGRect) -> (x: CGFloat, y: CGFloat) {
        
        if let match = answersFrames.firstIndex(where: {
            $0.contains(location) }) {
            
            let newX = rect.midX.distance(to: answersFrames[match].midX)
            let newY = rect.midY.distance(to: answersFrames[match].midY)
            
            let newCGpoint = (x: newX, y: newY)
            
            return newCGpoint
            
        } else {
            return (x: CGFloat.zero, y: CGFloat.zero)
        }
    }
}

struct PatternForm: View {
    
    @ObservedObject var viewModel: ShapeGameViewModel
    @Binding var answersFrames: [CGRect]
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
                .overlay(GeometryReader { geo in
                    Color.clear
                    .onAppear {
                        self.answersFrames.append(geo.frame(in: .global))
                    }
                })
            }
        }
    }
}

struct ShapeGameView_Previews: PreviewProvider {
    static var previews: some View {
        ShapeGameView()
    }
}
