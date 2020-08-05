//
//  Tile.swift
//  Chumigos
//
//  Created by Marcus Vinicius Vieira Badiale on 04/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

struct QuestionTile: View {
    
    var body: some View {
        ZStack{

            Rectangle()
                .fill(Color.clear)
                .frame(width: 104, height: 112)
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .offset(y: 4.5)
                        .stroke(Color.init(red: 43/255, green: 112/255, blue: 201/255), style: StrokeStyle(lineWidth: 3, dash: [12,5]))
                )
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.init(red: 20/255, green: 83/255, blue: 163/255))
                .frame(width:81, height: 81.22)
                .offset(y: 9)
                
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.init(red: 43/255, green: 112/255, blue: 201/255))
                .frame(width:81, height: 81.22)
            
            Text("?")
                .foregroundColor(.white)
                .font(.system(size: 70)).bold()
                .kerning(5)
        }
    }
}

struct QuestionTile_Preview: PreviewProvider {
    static var previews: some View {
        QuestionTile()
    }
}
