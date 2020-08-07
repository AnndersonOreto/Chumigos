//
//  ProgressBarView.swift
//  Chumigos
//
//  Created by Annderson Packeiser Oreto on 05/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation
import SwiftUI

struct ProgressBarView: View {
    
    @ObservedObject var viewModel: ProgressBarViewModel
    
    var body: some View {
        
        ZStack {
            
            HStack {
                
                ForEach(self.viewModel.progressStatusList.indices, id: \.self) { index in
                    Capsule()
                        .frame(width: index == self.viewModel.currentQuestion ? UIScreen.main.bounds.width*0.115 : UIScreen.main.bounds.width*0.1,
                               height: index == self.viewModel.currentQuestion ? UIScreen.main.bounds.width*0.022 : UIScreen.main.bounds.width*0.02)
                        .foregroundColor(self.viewModel.progressStatusList[index])
                }
            }
        }
    }
}
