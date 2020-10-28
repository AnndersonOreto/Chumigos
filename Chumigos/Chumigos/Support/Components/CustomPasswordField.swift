//
//  CustomPasswordField.swift
//  Loggio
//
//  Created by Marcus Vinicius Vieira Badiale on 27/10/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import SwiftUI

struct CustomPasswordField: View {
    
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        //i did this way to not change the color of the placeholder
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder).foregroundColor(.Wolf)
                .padding(10)
                .padding(.leading, 20)
                .dynamicFont(size: 18, weight: .regular)
            }
            SecureField("", text: $text)
            .padding(10)
            .padding(.leading, 20)
            .dynamicFont(size: 18, weight: .regular)
            .foregroundColor(Color.Wolf)
        }.background(RoundedRectangle(cornerRadius: 10).fill(Color.Swan))
    }
}
