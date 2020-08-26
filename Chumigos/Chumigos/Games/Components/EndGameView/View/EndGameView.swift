//
//  EndGameView.swift
//  Chumigos
//
//  Created by Annderson Packeiser Oreto on 25/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

struct EndGameView: View {
    
    // MARK: - View Model
    
    @ObservedObject var progressViewModel: ProgressBarViewModel = ProgressBarViewModel(questionAmount: 5)
    
    // MARK: - Drawing Contants
    
    private let screenWidth = UIScreen.main.bounds.width
    private let fontName = "Rubik"
    
    @State private var restart: Bool = false
    @State private var homeScreen: Bool = false
    // MARK: - View
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    
    var body: some View {
        
        ZStack {
            
            VStack {
                
                // Progress Bar
                ProgressBarView(viewModel: progressViewModel)
                    .padding(.top, screenWidth * 0.015)
                
                Spacer()
                
                Group {
                    Image("fruit-1")
                        .resizable().frame(width: screenWidth * 0.245, height: screenWidth * 0.245, alignment: .center)
                                        
                    // Label
                    Text("Parabéns! Você terminou a tarefa!")
                        .foregroundColor(Color.Eel)
                        .font(.custom(fontName, size: screenWidth * 0.023)).fontWeight(.bold)
                                        .padding(.top, screenWidth * 0.03)
                    
                }
                // Arte
                    
                Spacer()
                // Simbolo da trilha
                                
                TrailTile(game: GameObject(gameType: .pattern, gameName: "")).frame(width: screenWidth * 0.05, height: screenWidth * 0.05, alignment: .center)
//                    .padding(.vertical, screenWidth * 0.03)

                Spacer()
                
                NavigationLink(destination: SequenceGameView(), isActive: self.$restart, label: {
                    EmptyView()
                })
                
                NavigationLink(destination: ContentView(), isActive: self.$homeScreen, label: {
                    EmptyView()
                })
                
                // Inicio
                Button(action: {
                    self.homeScreen = true
                }) {
                    Text("Início")
                        .font(.custom(fontName, size: screenWidth * 0.016)).bold()
                }.buttonStyle(GameButtonStyle(buttonColor: Color.Humpback, pressedButtonColor: Color.Whale, buttonBackgroundColor: Color.Narwhal, isButtonEnable: true))
                
                // Recomecar
                Button(action: {
                    self.restart = true
                }) {
                    Text("Recomeçar")
                        .font(.custom(fontName, size: screenWidth * 0.016)).bold()
                }.buttonStyle(GameButtonStyle(buttonColor: Color.Bee, pressedButtonColor: Color.Duck, buttonBackgroundColor: Color.Fox, isButtonEnable: true))
                    .padding(.bottom, 30)
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct EndGameView_Previews: PreviewProvider {
    static var previews: some View {
        EndGameView()
    }
}
