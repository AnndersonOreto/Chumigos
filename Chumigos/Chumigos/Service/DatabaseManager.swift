//
//  DatabaseManager.swift
//  Loggio
//
//  Created by Annderson Packeiser Oreto on 14/10/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DatabaseManager {
    
    private var ref: DatabaseReference!
    
    init() {
        
        ref = Database.database().reference()
    }
    
    func saveNewProfile(email: String, name: String, userUid: String) {
        
        let post = ["name": name, "user_life": ["current_life": 5]] as [String : Any]
        
        ref.child("users").child(email).setValue(post) { (error, _) in
            
            if let error = error {
                
                print(error.localizedDescription)
            }
        }
    }
    
    func saveLastErrorDate(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .medium
        dateFormatter.locale = Locale.current
        let dateFormatted = dateFormatter.string(from: date)

        let post = ["lastError_date": dateFormatted]

        ref.child("users").child(User.shared.email.replaceEmail()).child("user_life").updateChildValues(post) { (error, _) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func updateUserLifes() {
        
    }
    
    func getUserLifes(completion: @escaping(Int) -> Void)  {
        var currentLife = 0
        ref.child("users").child(User.shared.email.replaceEmail()).child("user_life").observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            currentLife = value?["current_life"] as? Int ?? 0
            completion(currentLife)
        }
    }

    func sendPending(source: String, target: String) {
        
        let post = ["pending": source]
        
        ref.child("users").child(target).updateChildValues(post) { (error, ret) in
            
            if let error = error {
                
                print(error.localizedDescription)
            }
        }
    }
    
    func acceptPending(source: String, target: String, name: String, phone: String) {
        
        var post = ["pending": ""]
        
        ref.child("users").child(source).updateChildValues(post) { (error, ret) in
            
            if let error = error {
                
                print(error.localizedDescription)
            }
        }
        
        post = ["email": source,
                "name": name,
                "phone": phone]
        
        ref.child("users").child(target).child("professional_list").childByAutoId().setValue(post) { (error, ret) in
            
            if let error = error {
                
                print(error.localizedDescription)
            }
        }
    }
    
    func getUserProfile(userUid: String, completion: @escaping(AuthenticationProfile) -> Void) {

        ref.child("users").child(userUid).observeSingleEvent(of: .value, with: { (snapshopt) in

            let value = snapshopt.value as? NSDictionary
            let email = userUid.replacingOccurrences(of: "(dot)", with: ".").lowercased()
            let name = value?["name"] as? String ?? ""

            let profile = AuthenticationProfile(id: userUid, email: email)
            profile.name = name

            completion(profile)
        })
    }
    
    func getPendingStatus(userUid: String, completion: @escaping(String) -> Void) {
        ref.child("users").child(userUid).observeSingleEvent(of: .value) { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                if let pendingEmail = value["pending"] as? String {
                    completion(pendingEmail)
                } else {
                    completion("")
                }
            }
        }
    }
}
