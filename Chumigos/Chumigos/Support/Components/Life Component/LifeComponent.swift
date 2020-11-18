//
//  LifeComponent.swift
//  Loggio
//
//  Created by Guilherme Piccoli on 03/11/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import SwiftUI

struct LifeComponent: View {
    
    @EnvironmentObject var environmentManager: EnvironmentManager
    @Binding var showLifeBanner: Bool
    let screenWidth = UIScreen.main.bounds.width
    @State var life: Int = 0
    
    var body: some View {
        HStack {
            Image("icon-life")
                .resizable()
                .frame(width: screenWidth * 0.01088777219, height: screenWidth * 0.02177554439)
            CustomText("\(self.life)")
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
        .onAppear {
            self.life = self.environmentManager.profile?.lifeManager.totalLifes ?? 0
        }
    }
}
