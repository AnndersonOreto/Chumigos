//
//  AvatarSelectionView.swift
//  Chumigos
//
//  Created by Guilherme Piccoli on 01/09/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

struct Grid<Content: View>: View {
    
    let rows: Int
    let columns: Int
    let spacing: CGFloat
    let content: (Int, Int) -> Content
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        VStack(alignment: .leading, spacing: self.spacing) {
            ForEach(0..<rows) { row in
                HStack(alignment: .center, spacing: self.spacing) {
                    ForEach(0..<self.columns) { (column) in
                        self.content(row, column)
                    }
                }
            }
        }
    }
}

struct AvatarView: View {
    @State var avatarName: String
    @Binding var avatarSelected: String
    var isSelected: Bool = false
    
    let screenWidth = UIScreen.main.bounds.width
    var body: some View {
        
        Button(action: {
            self.avatarSelected = self.avatarName
        }, label: {
            Image(self.avatarName)
                .renderingMode(.original)
                .resizable()
                .frame(width: self.screenWidth * 0.163, height: self.screenWidth * 0.163, alignment: .center)
                .overlay(
                    Circle()
                        .stroke(Color.Humpback, lineWidth: 10)
                        .frame(width: self.screenWidth * 0.163, height: self.screenWidth * 0.163, alignment: .center)
                        .opacity(self.isSelected ? 1 : 0)
            )
        })
        
    }
}

struct AvatarSelectionView: View {
  
    var closeModalAction: () -> Void
    let screenWidth = UIScreen.main.bounds.width
    
    var numberOfColumns: Int = 2
    var numberOfRows: Int {
        Int(ceil(Double(avatarGrid.count)/Double(numberOfColumns)))
    }

    let avatarGrid = ["Avatar 1", "Avatar 2", "Avatar 3", "Avatar 4", "Avatar 5",
                      "Avatar 6", "Avatar 7", "Avatar 8", "Avatar 9", "Avatar 10",
                      "Avatar 11", "Avatar 12"]
    
    @Binding var avatarSelected: String
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.popUpBackground
                VStack {
                    Text("Selecione o seu avatar:")
                        .tracking(1)
                        .foregroundColor(Color.Humpback)
                        .font(.custom("Rubik", size: self.screenWidth * 0.018)).fontWeight(.medium)
                        .padding(.top, self.screenWidth * 0.02)
                        .padding(.bottom, self.screenWidth * 0.01)

                    ScrollView(showsIndicators: false) {
                        Grid<AvatarView>(rows: self.numberOfRows, columns: self.numberOfColumns,
                                         spacing:  self.screenWidth * 0.057) { (row, column) in
                            if self.avatarSelected == self.getAvatarName(of: row, column: column) {
                                return AvatarView(avatarName: self.getAvatarName(of: row, column: column),
                                                  avatarSelected: self.$avatarSelected, isSelected: true)
                            } else {
                                return AvatarView(avatarName: self.getAvatarName(of: row, column: column),
                                                  avatarSelected: self.$avatarSelected)
                            }
                        }
                        .padding()
                    }.padding(.bottom, geometry.size.width * 0.12)
                    
                }
                
                VStack {
                    Spacer()
                    if !self.avatarSelected.isEmpty {
                        ZStack {
                            RoundedRectangle(cornerRadius: 42).fill(Color.Humpback)
                                .frame(width: geometry.size.width + 5, height: geometry.size.width * 0.16)
                                .padding(.bottom, -(geometry.size.width * 0.035))
                            Button(action: {
                                self.closeModalAction()
                            }) {
                                Text("Confirmar")
                                    .font(.custom("Rubik", size: 20)).bold()
                                .tracking(1)
                            }.buttonStyle(
                                GameButtonStyle(buttonColor: Color.Owl,
                                                pressedButtonColor: Color.Turtle,
                                                buttonBackgroundColor: Color.TreeFrog,
                                                isButtonEnable: true))
                                .padding(.bottom, 10)
                        }
                        
                    }
                }
            }
        }
    }
    
    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < numberOfRows && column >= 0 && column < numberOfColumns
    }
    
    func getAvatarName(of row: Int, column: Int) -> String {
        if indexIsValid(row: row, column: column) {
            return avatarGrid[(row * self.numberOfColumns) + column]
        }
        return "Avatar 1"
        
        // row = 1 numberscolumn = 2 column = 1
    }
}
