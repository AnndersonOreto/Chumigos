//
//  SignInWithAppleView.swift
//  Loggio
//
//  Created by Annderson Packeiser Oreto on 05/10/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import SwiftUI
import AuthenticationServices

struct SignInWithAppleView: View {
    
    @EnvironmentObject var signInWithAppleManager: SignInWithAppleManager
    
    var body: some View {
        
        ZStack {
            
            if signInWithAppleManager.isUserAuthenticated == .signedIn {
                MainView()
            } else if signInWithAppleManager.isUserAuthenticated == .signedOut {
                LoginLoginView()
            } else {
                LoginView()
            }
        }
    }
}

struct SignInWithAppleView_Previews: PreviewProvider {
    static var previews: some View {
        SignInWithAppleView()
    }
}
