//
//  Tile.swift
//  Chumigos
//
//  Created by Marcus Vinicius Vieira Badiale on 04/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

struct Tile<Content>: View where Content: View {
    
    var content: Content
    var size: CGSize
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .fill(Color.clear)
                .frame(width: self.size.width * 1.15, height: self.size.width * 1.25)
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.init(red: 165/255, green: 102/255, blue: 68/255))
                .frame(width:size.width, height: size.height)
                .offset(y: 9)
                
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.init(red: 255/255, green: 206/255, blue: 142/255))
                .frame(width:size.width, height: size.height)
            
            content
                .frame(width: self.size.width * 0.53, height: self.size.width * 0.53)
        }
    }
}

struct Tile_Previews: PreviewProvider {
    static var previews: some View {
        Tile<Image>(content: Image(""), size: CGSize.zero)
    }
}
