//
//  SequenceView.swift
//  Chumigos
//
//  Created by Guilherme Piccoli on 21/07/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

struct SequenceView: View {
    
    @ObservedObject var viewModel = SequenceViewModel(difficulty: .MEDIUM)
    
    @State var questionRect: CGRect = .zero
    
    var body: some View {
        VStack(spacing: 80) {
            HStack {
                ForEach(viewModel.sequence.indices, id: \.self) { index in
                    SequenceRectangle(index: index, number: self.viewModel.sequence[index], questionRect: self.$questionRect, viewModel: self.viewModel)
                }
            }
            HStack {
                ForEach(viewModel.alternatives, id: \.self) { element in
                    DraggableAlternative(content: { Rectangle() }, viewModel: self.viewModel, answer: element)
                }
            }
        }.id(UUID())
    }
}

struct SequenceRectangle: View {
    
    var index: Int
    var number: Int
    @Binding var questionRect: CGRect
    @ObservedObject var viewModel: SequenceViewModel
    
    var body: some View {
        ZStack {
            if number == -1 {
                Text("?")
                    .padding()
                    .border(Color.black)
                    .background(GeometryGetter(rect: self.$questionRect, viewModel: viewModel, isQuestion: true, number: getCorrectAnswer()))
            }
            else {
                Rectangle()
                    .fill(getRandomColor())
                    .frame(width: 50, height: 50)
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
    
    func getCorrectAnswer() -> Int {
        let size = self.viewModel.functions.getSize()
        var multiplier = 0
        var aux = 0
        
        
        if index < size {
            aux = index
        } else if index < size*2 {
            multiplier = 1
        } else if index < size*3 {
            multiplier = 2
        } else {
            multiplier = 3
        }
        
         aux = index - (size * multiplier)
        
        return self.viewModel.sequence[aux]
        
    }
}

struct SequenceView_Previews: PreviewProvider {
    static var previews: some View {
        SequenceView()
    }
}
