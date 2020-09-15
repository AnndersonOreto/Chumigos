//
//  ConfigurationView.swift
//  Chumigos
//
//  Created by Annderson Packeiser Oreto on 03/09/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI
import Combine

struct ConfigurationView: View {
    
    @Environment(\.colorScheme) var colorScheme
    // MARK: - CoreData variables
    @FetchRequest(entity: UserData.entity(), sortDescriptors: []) var result: FetchedResults<UserData>
    @Environment(\.managedObjectContext) var moc
    
    @State var avatarImageName: String = "Avatar 1"
    @State private var showAvatarSelection = false
    
    var notificationManager = NotificationManager()
    
    @ObservedObject var viewModel: ConfigurationViewModel = ConfigurationViewModel()
    
    // MARK: - Drawing Contants
    @State var toggleNotifications: Bool = false
    @State var toggleVibration: Bool = false
    //    @State var toggleDarkMode: Bool = SceneDelegate.shared?.window!.overrideUserInterfaceStyle
    @State var togglePreferences: Bool = false
    @State var sliderDynamicType: Double = 50.0
    @State var isAlert: Bool = false
    
    private let screenWidth = UIScreen.main.bounds.width
    private let fontName = "Rubik"
    
    // MARK: - View
    
    var body: some View {
        
        // Main stack
        ScrollView(showsIndicators: false) {
            ZStack {
                // Vertical configuration stack
                VStack {
                    // Avatar information
                    VStack {
                        // Avatar image
                        Image(avatarImageName)
                            .resizable()
                            .frame(width: screenWidth * 0.108, height: screenWidth * 0.108, alignment: .center)
                            .padding(.bottom, screenWidth * 0.008)
                        
                        // Avatar change button
                        Button(action: {
                            self.showAvatarSelection.toggle()
                        }) {
                            Text("Mudar Avatar")
                                .font(.custom(fontName, size: screenWidth * 0.016))
                                .foregroundColor(.Humpback)
                                .fontWeight(.medium)
                                .tracking(1)
                        }.sheet(isPresented: $showAvatarSelection) {
                            withAnimation {
                                AvatarSelectionView(closeModalAction: {
                                    self.showAvatarSelection = false
                                    self.saveAvatar()
                                }, avatarSelected: self.$avatarImageName)
                            }
                        }
                    }.padding(.top, screenWidth * 0.04)
                    .padding(.bottom, screenWidth * 0.05)
                    
                    // My Profile
                    VStack(alignment: .leading) {
                        
                        // My profile
                        Text("Meu Perfil")
                            .font(.custom(fontName, size: screenWidth * 0.023))
                            .foregroundColor(.textColor)
                            .fontWeight(.medium)
                            .tracking(1)
                        
                        // My profile description
                        Text("Em breve você poderá se cadastrar na plataforma e ter acesso às configurações de perfil.")
                            .font(.custom(fontName, size: screenWidth * 0.015))
                            .foregroundColor(.descriptionTextColor)
                            .fontWeight(.medium)
                            .tracking(1)
                            .padding(.top, screenWidth * 0.013)
                            .padding(.bottom, screenWidth * 0.0065)
                        
                        // Register button
                        Button(action: {
                            
                        }) {
                            Text("Cadastrar-se")
                                .font(.custom(fontName, size: screenWidth * 0.016))
                                .foregroundColor(.Hare)
                                .fontWeight(.medium)
                                .tracking(1)
                        }.buttonStyle(AppButtonStyle(buttonColor: .Swan, pressedButtonColor: .Swan, buttonBackgroundColor: .Hare, isButtonEnable: true, textColor: .Ghost, width: screenWidth * 0.39))
                    }.frame(width: screenWidth * 0.39)
                    .padding(.bottom, screenWidth * 0.015)
                    
                    // Config label
                    VStack(alignment: .leading) {
                        
                        Text("Configurações")
                            .font(.custom(fontName, size: screenWidth * 0.023))
                            .foregroundColor(.textColor)
                            .fontWeight(.medium)
                            .tracking(1)
                        
                        // Switch notification
                        Toggle(isOn: self.toggleNotificationValue()) {
                            Text("Notificações")
                                .font(.custom(fontName, size: screenWidth * 0.015))
                                .foregroundColor(.textColor)
                                .tracking(1)
                                .fontWeight(.medium)
                        }
                        .padding(.horizontal, screenWidth * 0.02)
                        .padding(.vertical, screenWidth * 0.008)
                        .background(RoundedRectangle(cornerRadius: screenWidth * 0.008)
                        .stroke(Color.Humpback, lineWidth: 2)
                        .background(Color.popUpBackground))
                        .onAppear {
                            UISwitch.appearance().onTintColor = UIColor(red: 0.169, green: 0.439, blue: 0.788, alpha: 1.0)
                        }.padding(.horizontal, 1)
                        .alert(isPresented: $isAlert) { () -> Alert in
                            Alert(title: Text("Notifications"), message: Text("Open settings to turn on notifications."), primaryButton: .default(Text("Open Settings"), action: {
                                self.notificationManager.openNotificationSettings()
                            }), secondaryButton: .default(Text("Dismiss")))
                        }
                        
                        // Switch theme
                        VStack(alignment: .leading) {
                            
                            Text("Tema")
                                .font(.custom(fontName, size: screenWidth * 0.015))
                                .foregroundColor(.textColor)
                                .fontWeight(.medium)
                                .kerning(1)
                                .padding(.horizontal, screenWidth * 0.02)
                                .padding(.top, screenWidth * 0.008)
                            
                            CustomDivider(color: Color.Humpback, width: 2)
                            
                            Toggle(isOn: toggleSystemThemePreference()) {
                                
                                Text("Preferências do Dispositivo")
                                    .font(.custom(fontName, size: screenWidth * 0.015))
                                    .foregroundColor(.textColor)
                                    .kerning(1)
                                    .fontWeight(.medium)
                            }.padding(.horizontal, screenWidth * 0.02)
                                .padding(.vertical, screenWidth * 0.008)
                                .onAppear {
                                    UISwitch.appearance().onTintColor = UIColor(red: 0.169, green: 0.439, blue: 0.788, alpha: 1.0)
                            }
                            
                            
                            Toggle(isOn: toggleDarkModeValue()) {
                                
                                Text("Dark Mode")
                                    .font(.custom(fontName, size: screenWidth * 0.015))
                                    .foregroundColor(.textColor)
                                    .fontWeight(.medium)
                                    .kerning(1)
                            }
                            .padding(.horizontal, screenWidth * 0.02)
                            .padding(.vertical, screenWidth * 0.008)
                            .onAppear {
                                UISwitch.appearance().onTintColor = UIColor(red: 0.169, green: 0.439, blue: 0.788, alpha: 1.0)
                            }
                        }.background(RoundedRectangle(cornerRadius: screenWidth * 0.008)
                            .stroke(Color.Humpback, lineWidth: 2)
                            .background(Color.popUpBackground))
                            .padding(.horizontal, 1)
                            .padding(.vertical, screenWidth * 0.0065)
                        
                        
                        // Dynamic type slider
                        //                        VStack(alignment: .leading) {
                        //
                        //                            Text("Dynamic Type")
                        //                                .font(.custom(fontName, size: screenWidth * 0.015))
                        //                                .foregroundColor(.textColor)
                        //                                .fontWeight(.medium)
                        //                                .kerning(1)
                        //                                .padding(.horizontal, screenWidth * 0.02)
                        //                                .padding(.top, screenWidth * 0.008)
                        //
                        //                            CustomDivider(color: Color.Humpback, width: 2)
                        //
                        //                            HStack {
                        //                                Text("A").font(.custom(fontName, size: 14))                                .fontWeight(.medium)
                        //                                    .foregroundColor(.textColor)
                        //                                Spacer()
                        //                                Text("A").font(.custom(fontName, size: 18))                                .fontWeight(.medium)
                        //                                    .foregroundColor(.textColor)
                        //                                    .padding(.leading, screenWidth * 0.0075)
                        //                                Spacer()
                        //                                Text("A").font(.custom(fontName, size: 26))                                .fontWeight(.medium)
                        //                                    .foregroundColor(.textColor)
                        //                            }.padding(.horizontal, screenWidth * 0.02)
                        //                                .padding(.top, screenWidth * 0.008)
                        //                                .padding(.bottom, -(screenWidth * 0.01))
                        //
                        //                            Slider(value: self.$sliderDynamicType, in: 0...100, step: 50.0)
                        //                                .padding(.horizontal, screenWidth * 0.02)
                        //                                .padding(.bottom, screenWidth * 0.008)
                        //
                        //                        }.background(RoundedRectangle(cornerRadius: screenWidth * 0.008)
                        //                            .stroke(Color.Humpback, lineWidth: 2)
                        //                            .background(Color.popUpBackground))
                        //                            .padding(.horizontal, 1)
                        //
                        //                    }.frame(width: screenWidth * 0.39)
                        //                    .padding(.bottom, screenWidth * 0.02)
                    }.frame(width: screenWidth * 0.39)
                    .padding(.bottom, screenWidth * 0.02)
                    // Logout button
                    Button(action: {
                        
                    }) {
                        Text("Sair")
                            .font(.custom(fontName, size: screenWidth * 0.016))
                            .foregroundColor(.Ghost)
                            .fontWeight(.medium)
                            .kerning(1)
                    }.buttonStyle(AppButtonStyle(buttonColor: .Cardinal, pressedButtonColor: .Crab, buttonBackgroundColor: .FireAnt, isButtonEnable: true, textColor: .Ghost, width: screenWidth * 0.39))
                    
                    
                    // Service terms button
                    Button(action: {
                        
                    }) {
                        Text("Termos de Serviço")
                            .font(.custom(fontName, size: screenWidth * 0.016))
                            .foregroundColor(.Humpback)
                            .fontWeight(.medium)
                            .kerning(1)
                    }.padding(.top, screenWidth * 0.03)
                        .padding(.bottom, screenWidth * 0.03)
                }
                
            }.onAppear(perform: {
                self.setAvatarName()
            })
            
        }.frame(width: screenWidth * 0.4)
            .navigationBarTitle("")
            .navigationBarHidden(true)
    }
    
    // MARK: - View Functions
    fileprivate func toggleDarkModeValue() -> Binding<Bool> {
        return Binding<Bool>(
            get: {
                self.colorScheme == .dark ? true : false
        },
            set: {
                SceneDelegate.shared?.window!.overrideUserInterfaceStyle = $0 ? .dark : .light
                //dark rawvalue = 2 ; light rawvalue = 1
                UserDefaults.standard.setValue($0 ? UIUserInterfaceStyle.dark.rawValue : UIUserInterfaceStyle.light.rawValue, forKey: "loggio_viewStyle")
        }
        )
    }
    
    fileprivate func toggleSystemThemePreference() -> Binding<Bool> {
        return Binding<Bool>(
            get: {
                let value = UserDefaults.standard.integer(forKey: "loggio_viewStyle")
                return value == 0
        },
            set: {
                SceneDelegate.shared?.window!.overrideUserInterfaceStyle = $0 ? .unspecified : .dark
                UserDefaults.standard.setValue($0 ? UIUserInterfaceStyle.unspecified.rawValue : UIUserInterfaceStyle.dark.rawValue, forKey: "loggio_viewStyle")
        }
        )
    }
    
    fileprivate func toggleNotificationValue() -> Binding<Bool> {
        return Binding<Bool>(
            get: {
                UserDefaults.standard.bool(forKey: "loggio_notification")
        },
            set: {
                //TODO
                if !$0 {
                    self.isAlert = false
                    UIApplication.shared.unregisterForRemoteNotifications()
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                    UserDefaults.standard.set(false, forKey: "loggio_notification")
                }
                else {
                    self.isAlert = true
                    //ler do sistema -> alterar o valor no user defaults
                    UserDefaults.standard.set(true, forKey: "loggio_notification")
                }
                
        })
    }
    
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
