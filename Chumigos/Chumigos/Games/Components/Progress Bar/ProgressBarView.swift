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
                
//                ForEach(self.viewModel.progressStatusList.indices, id: \.self) { index in
//                    Capsule()
//                        .frame(width: index == self.viewModel.currentQuestion ? UIScreen.main.bounds.width*0.115 : UIScreen.main.bounds.width*0.086,
//                               height: index == self.viewModel.currentQuestion ? UIScreen.main.bounds.width*0.022 : UIScreen.main.bounds.width*0.017)
//                        .foregroundColor(index == self.viewModel.currentQuestion ? Color.secondaryBlue : self.viewModel.progressStatusList[index] )
//                }
                
                ForEach(self.viewModel.progressStatusList.indices, id: \.self) { index in
                    Capsule()
                        .frame(width: UIScreen.main.bounds.width*0.115,
                               height: UIScreen.main.bounds.width*0.022)
                        .foregroundColor(Color.clear)
                        .overlay(
                            Capsule()
                                .frame(width: index == self.viewModel.currentQuestion ?
                                            UIScreen.main.bounds.width*0.115 :
                                            UIScreen.main.bounds.width*0.086,
                                       height: index == self.viewModel.currentQuestion ?
                                            UIScreen.main.bounds.width*0.022 :
                                            UIScreen.main.bounds.width*0.017)
                            .foregroundColor(index == self.viewModel.currentQuestion ? Color.Humpback : self.viewModel.progressStatusList[index] )
                    )
                }
            }
        }
    }
}
