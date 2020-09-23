//
//  TotemGameView.swift
//  Loggio
//
//  Created by Annderson Packeiser Oreto on 17/09/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import SwiftUI

struct TotemGameView: View {
    
    // MARK: - View Models
    
    @ObservedObject var progressViewModel = ProgressBarViewModel(questionAmount: 5)
    @ObservedObject var viewModel: TotemGameViewModel = TotemGameViewModel()
    
    
    // MARK: - State variables
    
    @State var buttonIsPressed: Bool = false
    //@State var totemPieces: [String] = ["big/01", "big/04", "bigwing/02", "cup/03", "big/05"]
    @State var showPopUp: Bool = false
    @Binding var isTabBarActive: Bool
    
    
    // MARK: - Flag Variables
    
    // MARK: - Drawing Constants
    
    private let screenWidth = UIScreen.main.bounds.width
    private let fontName = "Rubik"
    
    var body: some View {
        
        // Main stack
        ZStack {
            
            // Dark light mode
            Color.background.edgesIgnoringSafeArea(.all)
            
            VStack {
                
                // Progress Bar
                ZStack {
                    
                    // Leave game button
                    HStack {
                        Button(action: {
                            self.showPopUp = true
                        }) {
                            Image(systemName: "xmark")
                                .dynamicFont(name: fontName, size: 34, weight: .bold)
                                .foregroundColor(.xMark)
                        }.buttonStyle(PlainButtonStyle())
                        
                        Spacer()
                    }.padding(.leading, screenWidth * 0.0385)
                    
                    HStack {
                        ProgressBarView(viewModel: progressViewModel)
                    }
                }.padding(.top, screenWidth * 0.015)
                
                Spacer()
                
                // Stack containing totem and alternatives
                HStack {
                    
                    // Totem
                    VStack(spacing: 0) {
                        
                        ForEach(self.viewModel.totemPieceList, id: \.self) { piece in
                            ZStack {
                                Image(piece.imageName).resizable()
                                Image(piece.face)
                            }
                        }
                    }.frame(width: screenWidth * 0.3, height: screenWidth * 0.43)
                    
                    Spacer()
                    
                    // Alternatives text
                    VStack {
                        
                        Spacer()
                        
                        #warning("offset seria a melhor solucao? fica a duvida")
                        CustomText("Selecione como as peças apareceriam caso estivesse as observando de cima:")
                            .dynamicFont(name: fontName, size: 20, weight: .medium)
                            .foregroundColor(.textColor)
                            .multilineTextAlignment(.center)
                            .frame(width: screenWidth * 0.42)
                            .offset(y: -(screenWidth * 0.053))
                        
                        // Alternatives grid
                        Grid<TotemGameTile>(rows: 2, columns: 2, spacing: screenWidth * 0.0175, content: { (row, column) in
                            TotemGameTile(size: self.screenWidth, imageNameList: self.viewModel.totemAlternativeList[(row * 2) + column])
                        })
                        
                        Spacer()
                    }
                }.padding(.horizontal, screenWidth * 0.1)
                
                Spacer()
                
                // Confirm button
                ZStack {
                    
                    // Continue Button
                    if buttonIsPressed {
                        Button(action: {
                            
                        }) {
                            Text("Continuar")
                                .dynamicFont(name: fontName, size: 20, weight: .bold)
                        }.buttonStyle(
                            GameButtonStyle(buttonColor: Color.Owl,
                                            pressedButtonColor: Color.Turtle,
                                            buttonBackgroundColor: Color.TreeFrog,
                                            isButtonEnable: true))
                        .padding(.bottom, 10)
                    } else {
                        //Confirm Button
                        Button(action: {
                            self.buttonIsPressed = true
                        }) {
                            Text("Confirmar")
                                .dynamicFont(name: fontName, size: 20, weight: .bold)
                        }
                        .buttonStyle(GameButtonStyle(buttonColor: Color.Whale,
                                                     pressedButtonColor: Color.Macaw,
                                                     buttonBackgroundColor: Color.Narwhal,
                                                     isButtonEnable: true))
                        .disabled(false)
                        .padding(.bottom, 10)
                        
                    }
                }
            }
        }.onAppear {
            self.isTabBarActive = false
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct TotemGameTile: View {
    
    // 1366
    var size: CGFloat
    var imageNameList: [String]
    
    var body: some View {
        
        ZStack {
            
            ForEach(imageNameList.reversed(), id: \.self) { image in
                Image(image)
                    .resizable()
                    .padding(.horizontal, size * 0.0146)
                    .padding(.vertical, size * 0.025)
                    .frame(width: size * 0.186, height: size * 0.142)
            }
        }.overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.optionBorder, lineWidth: 2)
        )
    }
}
