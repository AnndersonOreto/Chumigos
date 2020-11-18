//
//  CustomTextField.swift
//  Loggio
//
//  Created by Guilherme Piccoli on 05/10/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import SwiftUI

struct CustomTextField: View {
    
    var placeholder: String
    @Binding var text: String
    @EnvironmentObject var environmentManager: EnvironmentManager
    
    var body: some View {
        //i did this way to not change the color of the placeholder
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder).foregroundColor(.Wolf)
                .padding(10)
                .padding(.leading, 20)
                .dynamicFont(size: 18, weight: .regular)
            }
            TextField("", text: $text) { _ in
                environmentManager.signInError = false
                environmentManager.signUpError = ""
            }
            .padding(10)
            .padding(.leading, 20)
            .dynamicFont(size: 18, weight: .regular)
            .foregroundColor(Color.Wolf)
        }.background(RoundedRectangle(cornerRadius: 10).fill(Color.Swan))
    }
}
