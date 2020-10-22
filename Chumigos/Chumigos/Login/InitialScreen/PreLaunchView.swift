//
//  PreLaunchView.swift
//  Loggio
//
//  Created by Annderson Packeiser Oreto on 15/10/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import SwiftUI

struct PreLaunchView: View {
    
    @EnvironmentObject var environmentManager: EnvironmentManager
    
    func getUser() {
        
        environmentManager.listen()
    }
    
    var body: some View {
        
        ZStack {
            if environmentManager.profile != nil {
                MainView()
            } else {
                InitialScreen()
            }
        }.onAppear(perform: getUser)
    }
}

struct PreLaunchView_Previews: PreviewProvider {
    static var previews: some View {
        PreLaunchView()
    }
}
