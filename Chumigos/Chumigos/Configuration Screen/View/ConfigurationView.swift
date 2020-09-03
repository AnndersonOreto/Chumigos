//
//  ConfigurationView.swift
//  Chumigos
//
//  Created by Annderson Packeiser Oreto on 03/09/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

struct ConfigurationView: View {
    
    // MARK: - CoreData variables
    
    @FetchRequest(entity: UserData.entity(), sortDescriptors: []) var result: FetchedResults<UserData>
    @Environment(\.managedObjectContext) var moc
    
    @State var avatarImageName: String = "Avatar 1"
    @State private var showAvatarSelection = false
    
    // MARK: - Drawing Contants
    
    private let screenWidth = UIScreen.main.bounds.width
    private let fontName = "Rubik"
    
    @State var toggleNotifications: Bool = false
    @State var toggleVibration: Bool = false
    @State var toggleDarkMode: Bool = false
    @State var togglePreferences: Bool = false
    @State var sliderDynamicType: Double = 50.0
    
    // MARK: - View
    
    var body: some View {
        
        // Main stack
        ZStack {
            
            // Vertical configuration stack
            VStack {
                
                // Avatar information
                VStack {
                    
                    // Avatar image
                    Image(avatarImageName)
                        .resizable()
                        .frame(width: screenWidth * 0.108, height: screenWidth * 0.108, alignment: .center)
                    
                    // Avatar change button
                    Button(action: {
                        self.showAvatarSelection.toggle()
                    }) {
                        Text("Mudar Avatar")
                            .font(.custom(fontName, size: screenWidth * 0.016))
                            .foregroundColor(.Humpback)
                            .fontWeight(.medium)
                    }.sheet(isPresented: $showAvatarSelection) {
                        withAnimation {
                            AvatarSelectionView(closeModalAction: {
                                self.showAvatarSelection = false
                                self.saveAvatar()
                            }, avatarSelected: self.$avatarImageName)
                        }
                    }
                }
                
                // My Profile
                VStack(alignment: .leading) {
                    
                    // My profile
                    Text("Meu Perfil")
                        .font(.custom(fontName, size: screenWidth * 0.023))
                        .foregroundColor(.Eel)
                        .fontWeight(.medium)
                    
                    // My profile description
                    Text("Para ter acesso às configurações de perfil, é necessário realizar login ou cadastrar-se no aplicativo.")
                        .font(.custom(fontName, size: screenWidth * 0.015))
                        .foregroundColor(.Wolf)
                        .fontWeight(.medium)
                    
                    // Register button
                    Button(action: {
                        
                    }) {
                        Text("Cadastrar-se")
                            .font(.custom(fontName, size: screenWidth * 0.016))
                            .foregroundColor(.Ghost)
                            .fontWeight(.medium)
                    }.buttonStyle(AppButtonStyle(buttonColor: .Owl, pressedButtonColor: .Turtle, buttonBackgroundColor: .TreeFrog, isButtonEnable: true, textColor: .Ghost, width: screenWidth * 0.39))
                }.frame(width: screenWidth * 0.39)
                
                // Config label
                VStack(alignment: .leading) {
                    
                    Text("Configurações")
                        .font(.custom(fontName, size: screenWidth * 0.023))
                        .foregroundColor(.Eel)
                        .fontWeight(.medium)
                    
                    // Switch notification
                    Toggle(isOn: self.$toggleNotifications) {
                        
                        Text("Notificações")
                            .font(.custom(fontName, size: screenWidth * 0.015))
                            .foregroundColor(.Eel)
                            .fontWeight(.medium)
                    }.padding()
                        .overlay(RoundedRectangle(cornerRadius: screenWidth * 0.008).stroke(Color.Humpback, lineWidth: 2))
                        .onAppear {
                            UISwitch.appearance().onTintColor = UIColor(red: 0.169, green: 0.439, blue: 0.788, alpha: 1.0)
                    }
                    
                    // Switch vibration
                    Toggle(isOn: self.$toggleVibration) {
                        
                        Text("Vibração")
                            .font(.custom(fontName, size: screenWidth * 0.015))
                            .foregroundColor(.Eel)
                            .fontWeight(.medium)
                    }.padding()
                        .overlay(RoundedRectangle(cornerRadius: screenWidth * 0.008).stroke(Color.Humpback, lineWidth: 2))
                        .onAppear {
                            UISwitch.appearance().onTintColor = UIColor(red: 0.169, green: 0.439, blue: 0.788, alpha: 1.0)
                    }
                    
                    // Switch theme
                    VStack(alignment: .leading) {
                        
                        Text("Tema")
                            .font(.custom(fontName, size: screenWidth * 0.015))
                            .foregroundColor(.Eel)
                            .fontWeight(.medium)
                            .padding(.horizontal)
                        
                        Divider()
                        
                        Toggle(isOn: self.$toggleVibration) {
                            
                            Text("Dark Mode")
                                .font(.custom(fontName, size: screenWidth * 0.015))
                                .foregroundColor(.Eel)
                                .fontWeight(.medium)
                        }.padding(.horizontal)
                            .onAppear {
                                UISwitch.appearance().onTintColor = UIColor(red: 0.169, green: 0.439, blue: 0.788, alpha: 1.0)
                        }
                        
                        Toggle(isOn: self.$toggleVibration) {
                            
                            Text("Preferências do Dispositivo")
                                .font(.custom(fontName, size: screenWidth * 0.015))
                                .foregroundColor(.Eel)
                                .fontWeight(.medium)
                        }.padding(.horizontal)
                            .onAppear {
                                UISwitch.appearance().onTintColor = UIColor(red: 0.169, green: 0.439, blue: 0.788, alpha: 1.0)
                        }
                    }.overlay(RoundedRectangle(cornerRadius: screenWidth * 0.008).stroke(Color.Humpback, lineWidth: 2))
                    
                    // Dynamic type slider
                    VStack(alignment: .leading) {
                        
                        Text("Dynamic Type")
                            .font(.custom(fontName, size: screenWidth * 0.015))
                            .foregroundColor(.Eel)
                            .fontWeight(.medium)
                            .padding(.horizontal)
                        
                        Divider()
                        
                        Slider(value: self.$sliderDynamicType, in: 0...100, step: 50.0)
                    }
                }.frame(width: screenWidth * 0.39)
                
                // Logout button
                
                // Service terms button
            }.onAppear(perform: {
                self.setAvatarName()
            })
        }
    }
    
    // MARK: - View Functions
    
    func setAvatarName() {
        
        if result.count <= 0 {
            self.avatarImageName = "Avatar 12"
        } else {
            self.avatarImageName = self.result[0].imageName ?? "Avatar 12"
        }
    }
    
    func saveAvatar() {
        
        var user: UserData
        
        if result.count <= 0 {
            user = UserData(context: self.moc)
        } else {
            user = result[0]
        }
        
        user.imageName = avatarImageName
        
        do {
            try self.moc.save()
        } catch {
            fatalError("fudeu2")
        }
    }
}

struct ConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationView()
    }
}
