//
//  TrailView.swift
//  Chumigos
//
//  Created by Marcus Vinicius Vieira Badiale on 24/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

struct TrailView: View {
    
    // MARK: - Variable(s) & Contant(s)
    
    @ObservedObject var viewModel: TrailViewModel = TrailViewModel()
    let screenWidth = UIScreen.main.bounds.width
    
    @FetchRequest(entity: UserData.entity(), sortDescriptors: []) var result: FetchedResults<UserData>
    @Environment(\.managedObjectContext) var moc
    
    @State var matrixList: [TrailSection] = TrailViewModel.mockSections()
    
    //MARK: - View
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.background.edgesIgnoringSafeArea(.all)
                VStack {
                    
                    // Button just for test
                    Button(action: {
                        self.matrixList[0].currentLine += 1
                    }) {
                        Text("Next Line")
                    }

                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(self.matrixList) { (section) in
                            VStack(spacing: self.screenWidth * 0.04) {
                                ForEach(section.trail, id: \.self) { line in
                                    HStack(spacing: self.screenWidth * 0.06) {
                                        Spacer()
                                        ForEach(line, id: \.self) { game in
                                            NavigationLink(destination: GamesView(gameName: game.gameName)) {
                                                TrailTile(game: game)
                                            }.buttonStyle(PlainButtonStyle())
                                        }
                                        Spacer()
                                    }
                                }
                            }.padding(.bottom, self.screenWidth * 0.04)
                            .background(section.available ? Color.background : Color.sectionUnavailable)
                        }
                    }
                }.padding(.vertical)
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    func retrieveMatrixTrail() {
        
//        let decoder = JSONDecoder()
//
//        if result.count > 0 && result[0].trail != nil {
//
//            guard let trailData = result[0].trail else { return }
//
//            do {
//                let matrixObjectList = try decoder.decode([TrailSection].self, from: trailData)
//                self.matrixList = matrixObjectList
//            } catch {
//                fatalError("fudeu0")
//            }
//
//        } else {
        self.matrixList = TrailViewModel.mockSections()
//        }
    }
    
    func saveMatrixTrail() {
        
        var user: UserData
        
        // Override save on first position to prevent creation of multiple instances
        if result.count <= 0 {
            user = UserData(context: self.moc)
        } else {
            user = result[0]
        }
        
        let encoder = JSONEncoder()
        
        do {
            user.trail = try encoder.encode(matrixList)
        } catch {
            fatalError("fudeu1")
        }
        
        do {
            try self.moc.save()
        } catch {
            fatalError("fudeu2")
        }
    }
}

// MARK: - Preview(s)

struct TrailView_Previews: PreviewProvider {
    static var previews: some View {
        TrailView()
    }
}
