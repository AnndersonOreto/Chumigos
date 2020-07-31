
//
//  MarcusDraggableObn.swift
//  Chumigos
//
//  Created by Marcus Vinicius Vieira Badiale on 31/07/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

enum DragState{
    case unknown
    case good
    case bad
}

struct MarcusDraggableObj: View {
    
    @State var dragAmount = CGSize.zero
    @State var dragState = DragState.unknown
    
    var onChanged: ((CGPoint) -> DragState)?
    var onEnded: ((CGPoint) -> CGPoint)?
    
    var body: some View {
        
        //Generic View Here
        Rectangle()
            .frame(width: 70, height: 70)
            .offset(dragAmount)
            .zIndex(dragAmount == .zero ? 0 : 1)
            .shadow(color: dragColor, radius: dragAmount == .zero ? 0 : 10)
            .shadow(color: dragColor, radius: dragAmount == .zero ? 0 : 10)
        .gesture(
            DragGesture(coordinateSpace: .global)
            .onChanged{
                self.dragAmount = CGSize(width: $0.translation.width, height: $0.translation.height)
                self.dragState = self.onChanged?($0.location) ?? .unknown
            }
            .onEnded{
                if self.dragState == .good {
                    
//                    self.onEnded?($0.location)
                    let newCgPoint = self.onEnded?($0.location) ?? CGPoint.zero

                    let x = newCgPoint.x + self.dragAmount.width
                    let y = newCgPoint.y + self.dragAmount.height

                    let currentOffSet = CGSize(width: x, height: y)

                    self.dragAmount = currentOffSet
                } else {
                    self.dragAmount = .zero
                }
            }
        )
    }
    
    var dragColor: Color {
        switch dragState {
        case .unknown:
            return .black
        case .good:
            return .green
        case .bad:
            return .red
        }
    }
}
//
//struct MarcusDraggableObn_Previews: PreviewProvider {
//    static var previews: some View {
//        MarcusDraggableObj()
//    }
//}
