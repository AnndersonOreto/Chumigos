//
//  UnderConstructionView.swift
//  Loggio
//
//  Created by Marcus Vinicius Vieira Badiale on 24/09/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import SwiftUI

struct UnderConstructionView: View {
    
    private var screenWidth: CGFloat = UIScreen.main.bounds.width
    
    var body: some View {
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            VStack {
                
                Image("underConstruction")
                    .resizable()
                    .frame(width: screenWidth * 0.247, height: screenWidth * 0.26)
                
                CustomText("OPS!")
                    .dynamicFont(size: 30, weight: .medium)
                    .foregroundColor(.Humpback)
                    .padding(.vertical, 20)
                
                CustomText("Esta seção do aplicativo ainda está\nem construção!")
                    .dynamicFont(size: 20, weight: .regular)
                    .foregroundColor(.textColor)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct UnderConstructionView_Previews: PreviewProvider {
    static var previews: some View {
        UnderConstructionView()
    }
}
