//
//  CustomDivider.swift
//  Chumigos
//
//  Created by Guilherme Piccoli on 04/09/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

struct CustomDivider: View {
    var color: Color 
    var width: CGFloat
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: width)
            .edgesIgnoringSafeArea(.horizontal)
    }
}
