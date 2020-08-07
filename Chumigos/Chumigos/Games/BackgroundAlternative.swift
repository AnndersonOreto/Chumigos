//
//  BackgroundAlternative.swift
//  Chumigos
//
//  Created by Marcus Vinicius Vieira Badiale on 07/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

struct BackgroundAlternative<Content: View>: View {
    
    let content: Content
    let size: CGSize
    
    init(@ViewBuilder content: () -> Content, size: CGSize) {
        self.content = content()
        self.size = size
    }
    
    var body: some View {
        
        ZStack {
            content
            //BackgroundStroke
            Rectangle()
            .fill(Color.white)
            .opacity(0.75)
            .frame(width: self.size.width * 1.42, height: self.size.width * 1.42)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .offset(y: 4.5)
                    .stroke(Color.hareColor, lineWidth: 2)
                    
            )
        }
    }
}

//struct BackgroundAlternative_Previews: PreviewProvider {
//    static var previews: some View {
//        BackgroundAlternative()
//    }
//}
