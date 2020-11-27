//
//  PostLaunchScreen.swift
//  Loggio
//
//  Created by Annderson Packeiser Oreto on 26/11/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import SwiftUI

struct PostLaunchView: View {
    
    @EnvironmentObject var environmentManager: EnvironmentManager
    
    var body: some View {
        Group {
            //Change screen here
            if self.environmentManager.profile != nil {
                MainView()
            } else {
                InitialScreen()
            }
        }
    }
}
