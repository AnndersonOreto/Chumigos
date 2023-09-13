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
                #warning("REMOVER ON APPEAR E BLOCO DE CÓDIGO DENTRO DO ONAPPEAR QUANDO TERMINAR DEBUG")
                InitialScreen()
                    .onAppear {
                        let trailMockup = CoreDataService.shared.mockSections()
                        self.environmentManager.profile = AuthenticationProfile(name: "JORGE", id: "0001", email: "jorge@jorge.com", lives: 6, bonusLife: 2, trail: trailMockup, lastErrorDate: "")
                    }
            }
        }
    }
}
