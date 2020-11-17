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
    @EnvironmentObject var environmentManager: EnvironmentManager
    
    @State var avatarImageName: String = "Avatar 1"
    @State private var showAvatarSelection = false
        
    var notificationManager = NotificationManager()
    
    @ObservedObject var viewModel: ConfigurationViewModel = ConfigurationViewModel()
    
    // MARK: - Drawing Contants
    @State var toggleNotifications: Bool = false
    @State var toggleVibration: Bool = false
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
                // Stack to increase scrollView width
                HStack {
                    Spacer()
                    VStack {
                        // Vertical configuration stack
                        VStack {
                            // Avatar image
                            Image(avatarImageName)
                                .resizable()
                                .frame(width: screenWidth * 0.108, height: screenWidth * 0.108, alignment: .center)
                                .padding(.bottom, screenWidth * 0.008)
                            
                            // Avatar change button
                            Button(action: {
                                AppAnalytics.shared.logEvent(of: .launchAvatarScreen)
                                self.showAvatarSelection.toggle()
                            }) {
                                CustomText("Mudar Avatar")
                                    .dynamicFont(size: screenWidth * 0.016, weight: .medium)
                                    .foregroundColor(.Humpback)
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
                            headerConfigView()
                        }.frame(width: screenWidth * 0.39)
                            .padding(.bottom, screenWidth * 0.015)
                        
                        // Config label
                        VStack(alignment: .leading) {
                            
                            CustomText("Configurações")
                                .dynamicFont(size: screenWidth * 0.023, weight: .medium)
                                .foregroundColor(.textColor)
                            
                            // Switch notification
                            Toggle(isOn: self.toggleNotificationValue()) {
                                CustomText("Notificações")
                                    .dynamicFont(size: screenWidth * 0.015, weight: .medium)
                                    .foregroundColor(.textColor)
                            }
                            .padding(.horizontal, screenWidth * 0.02)
                            .padding(.vertical, screenWidth * 0.008)
                            .background(RoundedRectangle(cornerRadius: screenWidth * 0.008)
                            .stroke(Color.Humpback, lineWidth: 2)
                            .background(Color.popUpBackground))
                            .onAppear {
                                UISwitch.appearance().onTintColor = UIColor(red: 0.169, green: 0.439, blue: 0.788, alpha: 1.0)
                            }.padding(.horizontal, 1)
                            
                            // Config label
                            VStack(alignment: .leading) {
                                CustomText("Tema")
                                    .dynamicFont(size: screenWidth * 0.015, weight: .medium)
                                    .foregroundColor(.textColor)
                                    .padding(.horizontal, screenWidth * 0.02)
                                    .padding(.top, screenWidth * 0.008)
                                
                                CustomDivider(color: Color.Humpback, width: 2)
                                
                                Toggle(isOn: toggleSystemThemePreference()) {
                                    
                                    CustomText("Preferências do Dispositivo")
                                        .dynamicFont(size: screenWidth * 0.015, weight: .medium)
                                        .foregroundColor(.textColor)
                                    
                                }.padding(.horizontal, screenWidth * 0.02)
                                    .padding(.vertical, screenWidth * 0.008)
                                    .onAppear {
                                        UISwitch.appearance().onTintColor = UIColor(red: 0.169, green: 0.439, blue: 0.788, alpha: 1.0)
                                }
                                
                                // Switch theme
                                Toggle(isOn: toggleDarkModeValue()) {
                                    
                                    CustomText("Dark Mode")
                                        .dynamicFont(size: screenWidth * 0.015, weight: .medium)
                                        .foregroundColor(.textColor)
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
                        }.frame(width: screenWidth * 0.39)
                            .padding(.bottom, screenWidth * 0.02)
                        
                        // Logout button
                        Button(action: {
                            self.environmentManager.logout()
                        }) {
                            CustomText("Sair")
                                .dynamicFont(size: screenWidth * 0.016, weight: .medium)
                                .foregroundColor(.Ghost)
                        }.buttonStyle(
                            AppButtonStyle(buttonColor: .Cardinal, pressedButtonColor: .Crab,
                                           buttonBackgroundColor: .FireAnt, isButtonEnable: true,
                                           textColor: .Ghost, width: screenWidth * 0.39)
                        )
                        
                        // Service terms button
                        Button(action: {
                            // TODO: show terms of service
                        }) {
                            CustomText("Termos de Serviço")
                                .dynamicFont(size: screenWidth * 0.016, weight: .medium)
                                .foregroundColor(.Humpback)
                        }.padding(.top, screenWidth * 0.03)
                            .padding(.bottom, screenWidth * 0.03)
                    }
                    
                    Spacer()
                }
            }.onAppear(perform: {
                self.setAvatarName()
            })
            
        }
            .navigationBarTitle("")
            .navigationBarHidden(true)
    }
    
    func headerConfigView() -> some View {
        return (
            Group {
                
                CustomText("Meu Perfil")
                    .dynamicFont(size: screenWidth * 0.023, weight: .medium)
                    .foregroundColor(.textColor)
                    .padding(.bottom, screenWidth * 0.014)
                
                //User not logged
                if !(self.environmentManager.profile != nil) {
                    CustomText("Para ter acesso às configurações de perfil, é necessário realizar login ou cadastrar-se no aplicativo")
                        .dynamicFont(size: screenWidth * 0.015, weight: .medium)
                        .foregroundColor(.descriptionTextColor)
                        .padding(.top, screenWidth * 0.013)
                        .padding(.bottom, screenWidth * 0.0075)
                    
                    // Register button
                    Button(action: {
                        withAnimation(.easeInOut) {
                            self.environmentManager.logout()
                        }
                    }) {
                        CustomText("Cadastrar-se")
                            .dynamicFont(size: screenWidth * 0.016, weight: .medium)
                    }.buttonStyle(
                        AppButtonStyle(buttonColor: .Owl, pressedButtonColor: .Turtle,
                                       buttonBackgroundColor: .TreeFrog, isButtonEnable: true,
                                       textColor: .Ghost, width: screenWidth * 0.39)
                    )
                // User is logged
                } else {
                    VStack(spacing: screenWidth * 0.0135) {
                        HStack {
                            CustomText("Nome")
                                .dynamicFont(size: screenWidth * 0.015 , weight: .medium)
                                .foregroundColor(.Humpback)
                                .padding(.trailing, screenWidth * 0.041)
                            CustomText(self.environmentManager.profile?.name ?? "")
                                .dynamicFont(size: screenWidth * 0.015 , weight: .medium)
                                .foregroundColor(.textColor)
        
                            Spacer()
                            
                        }.padding(.horizontal, screenWidth * 0.02)
                        .padding(.vertical, screenWidth * 0.008)
                        .background(RoundedRectangle(cornerRadius: screenWidth * 0.008)
                        .stroke(Color.Humpback, lineWidth: 2)
                        .background(Color.popUpBackground))
                        .padding(.horizontal, 1)

                        HStack {
                            CustomText("E-mail")
                                .dynamicFont(size: screenWidth * 0.015 , weight: .medium)
                                .foregroundColor(.Humpback)
                                .padding(.trailing, screenWidth * 0.035)
                            CustomText(self.environmentManager.profile?.email ?? "")
                                .dynamicFont(size: screenWidth * 0.015 , weight: .medium)
                                .foregroundColor(.textColor)
                            
                            Spacer()
                            
                        }.padding(.horizontal, screenWidth * 0.02)
                        .padding(.vertical, screenWidth * 0.008)
                        .background(RoundedRectangle(cornerRadius: screenWidth * 0.008)
                        .stroke(Color.Humpback, lineWidth: 2)
                        .background(Color.popUpBackground))
                        .padding(.horizontal, 1)

                        // Register button
                        Button(action: {
                            // TODO: change password
                        }) {
                            CustomText("Alterar Senha")
                                .dynamicFont(size: screenWidth * 0.016, weight: .medium)
                        }.buttonStyle(
                            AppButtonStyle(buttonColor: .Humpback, pressedButtonColor: .Whale,
                                           buttonBackgroundColor: .Narwhal, isButtonEnable: true,
                                           textColor: .Ghost, width: screenWidth * 0.39)
                        )
                    }.frame(width: screenWidth * 0.39)
                }
            }
        )
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
                UserDefaults.standard.setValue(
                    $0 ? UIUserInterfaceStyle.dark.rawValue : UIUserInterfaceStyle.light.rawValue,
                    forKey: "loggio_viewStyle")
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
                UserDefaults.standard.setValue(
                    $0 ? UIUserInterfaceStyle.unspecified.rawValue : UIUserInterfaceStyle.dark.rawValue,
                    forKey: "loggio_viewStyle")
        }
        )
    }
    
    fileprivate func toggleNotificationValue() -> Binding<Bool> {
        return Binding<Bool>(
            get: {
                UserDefaults.standard.bool(forKey: "loggio_notification")
        },
            set: {
                if !$0 {
                    self.isAlert = false
                    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                    UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                    UserDefaults.standard.set(false, forKey: "loggio_notification")
                } else {
                    self.isAlert = true
                    UserDefaults.standard.set(true, forKey: "loggio_notification")
                }
                
        })
    }
    
    func setAvatarName() {
        
        if result.isEmpty {
            self.avatarImageName = "Avatar 12"
        } else {
            self.avatarImageName = self.result[0].imageName ?? "Avatar 12"
        }
    }
    
    func saveAvatar() {
        
        var user: UserData
        
        if result.isEmpty {
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
