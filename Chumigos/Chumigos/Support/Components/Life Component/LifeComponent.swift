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
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        HStack {
            Image("icon-life").frame(width: screenWidth * 0.01, height: screenWidth * 0.021)
            CustomText("\(viewModel.totalLifes)")
                .dynamicFont(size: 30, weight: .medium)
                .foregroundColor(.textColor)
                .padding(.trailing)
        }
    }
}

struct LifeComponent_Previews: PreviewProvider {
    static var previews: some View {
        LifeComponent()
    }
}
