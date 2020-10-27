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
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding(10)
            .padding(.leading, 20)
            .dynamicFont(size: 18, weight: .regular)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.textFieldColor))
            .foregroundColor(Color.textColor)
    }
}
