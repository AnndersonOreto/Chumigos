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
        ZStack{
            
            if isOccupied && buttonPressed {
                RoundedRectangle(cornerRadius: 18)
                    .fill(isCorrect ? Color.green : Color.red)
                    .frame(width: self.size.width * 1.2, height: self.size.width * 1.3)
                    .offset(y: 4.5)
            } else if isOccupied {
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.yellow)
                    .frame(width: self.size.width * 1.2, height: self.size.width * 1.3)
                    .offset(y: 4.5)
            } else {
                Rectangle()
                .fill(Color.clear)
                .frame(width: self.size.width * 1.2, height: self.size.width * 1.3)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .offset(y: 4.5)
                        .stroke(Color.init(red: 43/255, green: 112/255, blue: 201/255), style: StrokeStyle(lineWidth: 3, dash: [12,5]))
                )
            }
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.init(red: 20/255, green: 83/255, blue: 163/255))
                .frame(width:size.width, height: size.height)
                .offset(y: 9)
                
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.init(red: 43/255, green: 112/255, blue: 201/255))
                .frame(width:size.width, height: size.height)
            
            Text("?")
                .foregroundColor(.white)
                .font(.custom("Rubik", size: self.size.width * 0.74)).bold()
            
        }.padding(.horizontal, 5)
    }
}

//struct QuestionTile_Preview: PreviewProvider {
//    static var previews: some View {
//        QuestionTile(size: CGSize.zero, question: )
//    }
//}
