//
//  CheckView.swift
//  Loggio
//
//  Created by Guilherme Piccoli on 05/10/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import SwiftUI

struct CheckView: View {
    
    @State var isChecked: Bool = false
    var title: String?
    
    func toggle() {
        isChecked = !isChecked
        
    }
    
    var body: some View {
        HStack {
            Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                .foregroundColor(Color.Humpback)
            if title != nil {
                CustomText(title ?? "").dynamicFont(size: 16, weight: .regular)
                    .foregroundColor(Color.Eel)
            }
        }.onTapGesture {
            self.toggle()
        }
    }
}
