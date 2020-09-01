//
//  AvatarSelectionView.swift
//  Chumigos
//
//  Created by Guilherme Piccoli on 01/09/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

//struct AvatarSelectionView: View {
//    let screenWidth = UIScreen.main.bounds.width
//
//    let avatarArray = ["fruit-1", "fruit-2", "fruit-3"]
//
//    var body: some View {
//        VStack {
//
//            HStack(spacing: screenWidth * 0.057) {
//                ForEach(avatarArray, id: \.self, content: { avatar in
//                    Image(avatar)
//                        .resizable().frame(width: self.screenWidth * 0.163, height: self.screenWidth * 0.163, alignment: .center)
//                })
//            }
//        }
//    }
//}
//
//struct AvatarSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        AvatarSelectionView()
//    }
//}


struct Grid<Content: View>: View {
    
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(0..<rows) { row in
                HStack(alignment: .center, spacing: 30) {
                    ForEach(0..<self.columns) { (column) in
                        self.content(row, column)
                            .padding()
                    }
                }
            }
        }
    }
}

struct AvatarView: View {
    @State var avatarName: String
    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            Image(avatarName)
        }
    }
}

struct AvatarSelectionView: View {
    let avatarGrid = ["Avatar 1", "Avatar 2", "Avatar 3", "Avatar 4", "Avatar 5", "Avatar 6", "Avatar 7", "Avatar 8", "Avatar 9", "Avatar 10", "Avatar 11", "Avatar 12"]
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    private var numberOfColumns: Int {
        (horizontalSizeClass == .compact) ? 2 : 3
    }
    private var numberOfRows: Int {
        Int(ceil(Double(avatarGrid.count)/Double(numberOfColumns)))
    }
    var body: some View {
        ScrollView {
            Grid(rows: numberOfRows, columns: numberOfColumns) { (row, column) in
                AvatarView(avatarName: self.getAvatarName(of: row, column: column))
            }
            .padding()
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
    }
}

