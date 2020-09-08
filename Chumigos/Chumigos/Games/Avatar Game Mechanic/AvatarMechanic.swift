//
//  AvatarGameView.swift
//  Chumigos
//
//  Created by Arthur Bastos Fanck on 04/09/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

struct AvatarMechanic: View {
    
    @State private var eyeSelected: (row: Int, column: Int)?
    @State private var eyebrowSelected: (row: Int, column: Int)?
    @State private var mouthSelected: (row: Int, column: Int)?
    
    @State var eyeImage: String?
    @State var mouthImage: String?
    @State var eyebrowImage: String?
    
    var body: some View {
        HStack {
            FaceImageView(eyePiece: $eyeImage, mouthPiece: $mouthImage, eyebrowPiece: $eyebrowImage)
            
            VStack {
                ForEach(1..<5) { row in
                    HStack {
                        ForEach(1..<4) { column in
                            
                            Button(action: {
                                self.selectTile(row: row, column: column)
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(self.colorFor(row: row, column: column))
                                    
                                    VStack {
                                        Image("Avatar \(row * column)")
                                            .resizable()
                                            .frame(width: 150, height: 150)
                                        
                                        Text("\(row) x \(column)")
                                        .foregroundColor(.white)
                                        .font(.largeTitle)
                                    }
                                    
                                }
                            }.buttonStyle(PlainButtonStyle())
                        }
                    }
                }
            }
        }
        
    }
}

extension AvatarMechanic {
    
    func selectTile(row: Int, column: Int) {
        if column == 1 {
            if let eyeSelected = self.eyeSelected,
                eyeSelected == (row, column) {
                self.eyeSelected = nil
                self.eyeImage = nil
            } else {
                self.eyeSelected = (row, column)
                self.setEyeImage()
            }
        } else if column == 2 {
            if let mouthSelected = self.mouthSelected,
                mouthSelected == (row, column) {
                self.mouthSelected = nil
                self.mouthImage = nil
            } else {
                self.mouthSelected = (row, column)
                self.setMouthImage()
            }
        } else {
            if let eyebrowSelected = self.eyebrowSelected,
                eyebrowSelected == (row, column) {
                self.eyebrowSelected = nil
                self.eyebrowImage = nil
            } else {
                self.eyebrowSelected = (row, column)
                self.setEyebrowImage()
            }
        }
    }
    
    func colorFor(row: Int, column: Int) -> Color {
        if column == 1 {
            if let eyeSelected = self.eyeSelected {
                if eyeSelected == (row, column) {
                    return .orange
                }
            }
        } else if column == 2 {
            if let mouthSelected = self.mouthSelected {
                if mouthSelected == (row, column) {
                    return .orange
                }
            }
        } else {
            if let eyebrowSelected = self.eyebrowSelected {
                if eyebrowSelected == (row, column) {
                    return .orange
                }
            }
        }
        return .purple
    }
    
    func setEyeImage() {
        if let eye = self.eyeSelected {
            self.eyeImage = "Avatar \(eye.row * eye.column)"
        }
    }
    
    func setMouthImage() {
        if let mouth = self.mouthSelected {
            self.mouthImage = "Avatar \(mouth.row * mouth.column)"
        }
    }
    
    func setEyebrowImage() {
        if let eyebrow = self.eyebrowSelected {
            self.eyebrowImage = "Avatar \(eyebrow.row * eyebrow.column)"
        }
    }
}

struct FaceImageView: View {
    
    @Binding var eyePiece: String?
    @Binding var mouthPiece: String?
    @Binding var eyebrowPiece: String?
    
    var body: some View {
        ZStack {
            Image("Avatar 1")
                .resizable()
                .overlay(
                    VStack() {
                        HStack(spacing: 100) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black)
                                .frame(width: 80, height: 12)
                                .overlay(
                                    self.imageForEyebrow()
                                )
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black)
                                .frame(width: 80, height: 12)
                                .overlay(
                                    self.imageForEyebrow()
                                )
                        }.padding(.bottom, 10)
                        
                        HStack(spacing: 80) {
                            Capsule(style: .circular)
                                .fill(Color.blue)
                                .frame(width: 100, height: 120)
                                .overlay(
                                    self.imageForEye()
                                )
                            
                            Capsule(style: .circular)
                                .fill(Color.blue)
                                .frame(width: 100, height: 120)
                                .overlay(
                                    self.imageForEye()
                                )
                        }
                        
                        Capsule(style: .circular)
                            .fill(Color.red)
                            .frame(width: 260, height: 180)
                            .padding(.top, 50)
                            .overlay(
                                self.imageForMouth()
                            )
                    }
                )
        }
    }
    
    @ViewBuilder
    func imageForEyebrow() -> some View {
        if self.eyebrowPiece != nil {
            Image(self.eyebrowPiece!)
                .resizable()
                .frame(width: 50, height: 50)
        }
    }
    
    @ViewBuilder
    func imageForEye() -> some View {
        if self.eyePiece != nil {
            Image(self.eyePiece!)
                .resizable()
                .frame(width: 80, height: 80)
        }
    }
    
    @ViewBuilder
    func imageForMouth() -> some View {
        if self.mouthPiece != nil {
            Image(self.mouthPiece!)
                .resizable()
                .frame(width: 150, height: 150)
        }
    }
}


struct AvatarMechanicView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarMechanic()
    }
}
