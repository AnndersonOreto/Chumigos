//
//  LifeComponent.swift
//  Loggio
//
//  Created by Guilherme Piccoli on 03/11/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import SwiftUI

struct LifeComponent: View {
    
    @ObservedObject var viewModel = LifeComponentViewModel()
    @Binding var showLifeBanner: Bool
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        HStack {
            Image("icon-life")
                .resizable()
                .frame(width: screenWidth * 0.01088777219, height: screenWidth * 0.02177554439)
            CustomText("\(viewModel.totalLifes)")
                .dynamicFont(size: 30, weight: .medium)
                .foregroundColor(self.showLifeBanner ? .Ghost : .textColor)
                .padding(.trailing)
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(6)
            .background(
                Group {
                    if self.showLifeBanner {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.Humpback)
                            .padding(.trailing)
                    }
                }
            )
            .onTapGesture {
                self.showLifeBanner.toggle()
            }
    }
}

//struct LifeComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        LifeComponent()
//    }
//}
