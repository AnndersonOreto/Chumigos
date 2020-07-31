//
//  MarcusSequenceView.swift
//  Chumigos
//
//  Created by Marcus Vinicius Vieira Badiale on 31/07/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

struct MarcusSequenceView: View {
    
    @ObservedObject var viewModel = SequenceViewModel(difficulty: .MEDIUM)
    
    @State var answersFrames: [CGRect] = []
    
    var body: some View {
        VStack(spacing: 80) {
            
            HStack {
                ForEach(viewModel.sequence.indices, id: \.self) { index in
                    MarcusSequenceRectangle(index: index, number: self.viewModel.sequence[index], answersFrames: self.$answersFrames)
                }
            }
            HStack {
                ForEach(viewModel.alternatives.indices, id: \.self) { index in
                    MarcusDraggableObj(onChanged: self.objectMoved, onEnded: self.objectDropped)
                }
            }
        }.id(UUID())
    }
    
    func objectMoved(location: CGPoint) -> DragState {
        
        if answersFrames.firstIndex(where: {
            $0.contains(location) }) != nil {
            return .good
        } else {
            return .unknown
        }
    }
    
    func objectDropped(location: CGPoint) -> CGPoint {
        //OnEnded
        
        if let match = answersFrames.firstIndex(where: {
            $0.contains(location) }) {
            
            let newX = location.x.distance(to: answersFrames[match].midX)
            let newY = location.y.distance(to: answersFrames[match].midY)
            
            let newCGpoint = CGPoint(x: newX, y: newY)
            
            return newCGpoint
            
        } else {
            return CGPoint.zero
        }
    }
}

struct MarcusSequenceRectangle: View {
    
    var index: Int
    var number: Int
    @Binding var answersFrames: [CGRect]
    
    var body: some View {
        ZStack {
            if number == -1 {
                Rectangle()
                    .fill(Color.black)
                    .frame(width: 70, height: 70)
                    .overlay(GeometryReader { geo in
                        Color.darkPurple
                        .onAppear{
                            self.answersFrames.append(geo.frame(in: .global))
                        }
                    }
                    )
            }
            else {
                Rectangle()
                    .fill(getRandomColor())
                    .frame(width: 70, height: 70)
            }
        }
        
    }
    
    func getRandomColor() -> Color {
        switch number {
        case 1:
            return Color.blue
        case 2:
            return Color.orange
        case 3:
            return Color.red
        case 4:
            return Color.yellow
        case 5:
            return Color.green
        default:
            return Color.black
        }
    }
}


//struct MarcusSequenceView_Previews: PreviewProvider {
//    static var previews: some View {
//        MarcusSequenceView()
//    }
//}
