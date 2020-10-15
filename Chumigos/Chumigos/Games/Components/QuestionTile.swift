//
//  Tile.swift
//  Chumigos
//
//  Created by Marcus Vinicius Vieira Badiale on 04/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

struct QuestionTile: View {
    
    var size: CGSize
    var isOccupied: Bool
    var isCorrect: Bool
    var buttonPressed: Bool
    
    var body: some View {
        ZStack {
            
            if isOccupied && buttonPressed {
                RoundedRectangle(cornerRadius: 18)
                    .fill(isCorrect ? Color.TreeFrog : Color.FireAnt)
                    .frame(width: self.size.width * 1.25, height: self.size.width * 1.35)
                    .offset(y: 4.5)
            } else if isOccupied {
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.Bee)
                    .frame(width: self.size.width * 1.25, height: self.size.width * 1.35)
                    .offset(y: 4.5)
            } else {
                Rectangle()
                .fill(Color.clear)
                .frame(width: self.size.width * 1.25, height: self.size.width * 1.35)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .offset(y: 4.5)
                        .stroke(Color.Humpback, style: StrokeStyle(lineWidth: 3, dash: [12,5]))
                )
            }
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.Narwhal)
                .frame(width:size.width, height: size.height)
                .offset(y: 9)
                
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.Humpback)
                .frame(width:size.width, height: size.height)
            
            Text("?")
                .foregroundColor(.white)
                .dynamicFont(name: "Rubik", size: 70, weight: .bold)
            
        }.padding(.horizontal, 5)
        
    }
}

//struct QuestionTile_Preview: PreviewProvider {
//    static var previews: some View {
//        QuestionTile(size: CGSize.zero, question: )
//    }
//}
