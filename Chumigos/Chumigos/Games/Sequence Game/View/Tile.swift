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
    var size: CGSize
    
    var body: some View {
        ZStack{
            
            Rectangle()
                .fill(Color.clear)
                .frame(width: self.size.width * 1.2, height: self.size.width * 1.3)
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.init(red: 165/255, green: 102/255, blue: 68/255))
                .frame(width:size.width, height: size.height)
                .offset(y: 9)
                
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.init(red: 255/255, green: 206/255, blue: 142/255))
                .frame(width:size.width, height: size.height)
            
            Image(image)
            .resizable()
                .frame(width: self.size.width * 0.53, height: self.size.width * 0.53)
        }
    }
}

struct Tile_Previews: PreviewProvider {
    static var previews: some View {
        Tile(image: "", size: CGSize.zero)
    }
}