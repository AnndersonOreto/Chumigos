//
//  LifeComponentViewModel.swift
//  Loggio
//
//  Created by Guilherme Piccoli on 03/11/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import Foundation
import SwiftUI

class LifeComponentViewModel: ObservableObject {
    
    @Published var totalLifes: Int = 0
    
    init(totalLifes: Int) {
        self.totalLifes = totalLifes
    }
}
