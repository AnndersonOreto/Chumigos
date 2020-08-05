//
//  Tile.swift
//  Chumigos
//
//  Created by Marcus Vinicius Vieira Badiale on 04/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

struct Tile: View {
    
    var image: String
    
    var body: some View {
        ZStack{
            
            Rectangle()
                .fill(Color.clear)
                .frame(width: 104, height: 112)
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.init(red: 165/255, green: 102/255, blue: 68/255))
                .frame(width:81, height: 81.22)
                .offset(y: 9)
                
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.init(red: 255/255, green: 206/255, blue: 142/255))
                .frame(width:81, height: 81.22)
            
            Image(image)
            .resizable()
                .frame(width: 43, height: 43)
        }
    }
}

struct Tile_Previews: PreviewProvider {
    static var previews: some View {
        Tile(image: "")
    }
}
