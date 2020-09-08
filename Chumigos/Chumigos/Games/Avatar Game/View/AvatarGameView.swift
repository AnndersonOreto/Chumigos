//
//  AvatarGameView.swift
//  Chumigos
//
//  Created by Marcus Vinicius Vieira Badiale on 04/09/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

struct AvatarGameView: View {
    
    // MARK: - View Model
    @ObservedObject var progressViewModel = ProgressBarViewModel(questionAmount: 5)
    
    private var screenWidth = UIScreen.main.bounds.width
    
    // MARK: - State variables
    @State var buttonIsPressed: Bool = true
    @State var isFinished: Bool = false
    @State var showPopUp: Bool = false
    
    var body: some View {
        
        ZStack{
            
            //POLVO
            HStack{
                VStack{
                    Spacer()
                    Image("shape-1")
                    .resizable()
                    .frame(width: screenWidth * 0.63, height: UIScreen.main.bounds.height * 0.85)
                    
                }.edgesIgnoringSafeArea(.all)
                Spacer()
            }
            
            //Feedback massage and confirm buttons
            VStack {
                Spacer()
                    if buttonIsPressed {
                        GameFeedbackMessage(feedbackType: .CORRECT)
                            .padding(.bottom, -(screenWidth * 0.035))
                    }
            }
            
            //VStack geral
            VStack {
                
                //Progress bar and leave button
                ZStack {
                    if !isFinished {
                        HStack {
                            Button(action: {
                                self.showPopUp = true
                            }) {
                                Image(systemName: "xmark")
                                    .dynamicFont(name: "Rubik", size: 34, weight: .bold)
                                    .foregroundColor(.xMark)
                            }.buttonStyle(PlainButtonStyle())
                            
                            Spacer()
                        }.padding(.leading, screenWidth*0.0385)
                    }
                    
                    HStack {
                        ProgressBarView(viewModel: progressViewModel)
                    }
                }.padding(.top, screenWidth * 0.015)
                
                //Options
                HStack{
                    Spacer()
                    
                    VStack(spacing: 22){
                        
                        CustomText("Selecione os elementos que correspondem\na como o Logginho está se sentindo:")
                            .dynamicFont(size: 20, weight: .medium)
                        .foregroundColor(.textColor)
                        .multilineTextAlignment(.center)
                        
                        //spacing 0.2 for this game
                        Grid<AvatarGameTile>(rows: 4, columns: 3) { (row, column) in
                            AvatarGameTile()
                        }
                        
                        Spacer()
                    }
                    .padding(.trailing, screenWidth * 0.087)
                    .padding(.top, screenWidth * 0.051)
                }
                
                if buttonIsPressed {
                    Button(action: {
                        //TODO CONFIRM QUESTION
                    }) {
                        Text("Continuar")
                            .dynamicFont(name: "Rubik", size: 20, weight: .bold)
                    }.buttonStyle(
                        true ?
                            //correct answer
                            GameButtonStyle(buttonColor: Color.Owl, pressedButtonColor: Color.Turtle, buttonBackgroundColor: Color.TreeFrog, isButtonEnable: true) :
                            //wrong answer
                            GameButtonStyle(buttonColor: Color.white, pressedButtonColor: Color.Swan, buttonBackgroundColor: Color.Swan, isButtonEnable: true, textColor: Color.Humpback) )
                        .padding(.bottom, screenWidth * 0.019)
                }
                else {
                    //Confirm Button
                    Button(action: {
                        self.buttonIsPressed = true
                    }) {
                        Text("Confirmar")
                            .dynamicFont(name: "Rubik", size: 20, weight: .bold)
                    }.buttonStyle(GameButtonStyle(buttonColor: Color.Whale, pressedButtonColor: Color.Macaw, buttonBackgroundColor: Color.Narwhal, isButtonEnable: true))
                        .disabled(true)
                        .padding(.bottom, screenWidth * 0.019)
                }
            }
        }
    }
}

struct AvatarGameTile: View {
    
    private var screenWidth = UIScreen.main.bounds.width
    private let tileWidth = UIScreen.main.bounds.width * 0.084
    private let tileHeight = UIScreen.main.bounds.width * 0.077
    
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.init(red: 165/255, green: 102/255, blue: 68/255))
                .frame(width: tileWidth, height: tileHeight)
                .offset(y: 9)
                
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.init(red: 255/255, green: 206/255, blue: 142/255))
                .frame(width: tileWidth, height: tileHeight)
            
            Image("")
                .resizable()
                .frame(width: tileWidth * 0.85, height: tileWidth * 0.76)
//                .offset(y: 9)
        }
    }
}

struct AvatarGameView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarGameView()
    }
}
