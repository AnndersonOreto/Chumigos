//
//  ContentView.swift
//  Chumigos
//
//  Created by Annderson Packeiser Oreto on 14/07/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI
import SpriteKit
import CoreData

struct ContentView: View {
    
    @ObservedObject var viewModel = HomeScreenViewModel()
    
    @State private var showAvatarSelection = false
    
    @State var avatarName: String = "Avatar 1"
    
    @FetchRequest(entity: UserData.entity(), sortDescriptors: []) var result: FetchedResults<UserData>
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        NavigationView {
            VStack {
                
                Image(avatarName)
                
                
                NavigationLink(destination: SequenceGameView()) {
                    Text("Jogo da Sequencia")
                }
                
                NavigationLink(destination: ShapeGameView()) {
                    Text("Jogo da Forma")
                }
                
                Button(action: {
                    self.showAvatarSelection.toggle()
                }) {
                    Text("Show Detail")
                }.sheet(isPresented: $showAvatarSelection) {
                    withAnimation {
                        AvatarSelectionView(closeModalAction: {
                            self.showAvatarSelection = false
                            self.saveAvatar()
                        }, avatarSelected: self.$avatarName)
                    }
                }
            }.onAppear(perform: {
                self.setAvatarName()
            })
        }.navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    func setAvatarName() {
        
        if result.count <= 0 {
            self.avatarName = ""
        } else {
            self.avatarName = self.result[0].imageName ?? ""
        }
    }
    
    func saveAvatar() {
        
        var user: UserData
        
        if result.count <= 0 {
            user = UserData(context: self.moc)
        } else {
            user = result[0]
        }
        
        user.imageName = avatarName
        
        do {
            try self.moc.save()
        } catch {
            fatalError("fudeu2")
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.locale, .init(identifier: "en"))
    }
}
