//
//  LifeComponentViewModel.swift
//  Loggio
//
//  Created by Guilherme Piccoli on 03/11/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import Foundation

class LifeComponentViewModel: ObservableObject {
    
    @Published var totalLifes: Int = User.shared.lifeManager.totalLifes
    
    init() {
        
    }
}
