//
//  UserData.swift
//  Loggio
//
//  Created by Guilherme Piccoli on 30/09/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import Foundation

/// Represents the details about the user which were provided during initial registration.
struct UserDataProfile: Codable {
    /// The email address to use for user communications.  Remember it might be a relay!
    let email: String
    
    /// The components which make up the user's name.  See `displayName(style:)`
    let name: PersonNameComponents
    
    /// The team scoped identifier Apple provided to represent this user.
    let identifier: String
    
    /// Returns the localized name for the person
    /// - Parameter style: The `PersonNameComponentsFormatter.Style` to use for the display.
    func displayName(style: PersonNameComponentsFormatter.Style = .default) -> String {
        PersonNameComponentsFormatter.localizedString(from: name, style: style)
    }
}

//
//struct UserDataKeychain: Keychain {
//    // Make sure the account name doesn't match the bundle identifier!
//    var account = "com.mc.Chumigos.SignInWithApple.Details"
//    var service = "userIdentifier"
//
//    typealias DataType = UserData
//}
