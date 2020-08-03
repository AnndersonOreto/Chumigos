
//
//  MarcusDraggableObn.swift
//  Chumigos
//
//  Created by Marcus Vinicius Vieira Badiale on 31/07/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

public enum DragState{
    case unknown
    case good
    case bad
}

struct DraggableObject<Content: View>: View {
    
    let content: Content
    let answer: Int
    @State var dragState = DragState.unknown
    @State var rect: CGRect = .zero

    //OffSet Variables
    @State var dragAmount = CGSize.zero
    @State var newOffSet = CGSize.zero
    
    var onChanged: ((CGPoint) -> DragState)?
    var onEnded: ((CGPoint, CGRect, Int, DragState) -> (x: CGFloat, y: CGFloat))?
    
    init(@ViewBuilder content: () -> Content, onChanged: @escaping (CGPoint) -> DragState, onEnded: @escaping (CGPoint, CGRect, Int, DragState) -> (x: CGFloat, y: CGFloat), answer: Int) {
        self.content = content()
        self.onChanged = onChanged
        self.onEnded = onEnded
        self.answer = answer
    }
    
    
    var body: some View { 
        
        //Generic View Here
        self.content
            .overlay(GeometryReader { geo in
                Color.clear
                .onAppear{
                    self.rect = geo.frame(in: .global)
                }
            })
            .offset(dragAmount)
            .zIndex(dragAmount == .zero ? 0 : 1)
//            .shadow(color: dragColor, radius: dragAmount == .zero ? 0 : 10)
//            .shadow(color: dragColor, radius: dragAmount == .zero ? 0 : 10)
        .gesture(
            DragGesture(coordinateSpace: .global)
            .onChanged{
                self.dragAmount = CGSize(width: $0.translation.width + self.newOffSet.width, height: $0.translation.height + self.newOffSet.height)
                self.dragState = self.onChanged?($0.location) ?? .unknown
            }
            .onEnded{
            
                let newCgPoint = self.onEnded?($0.location, self.rect, self.answer, self.dragState) ?? (x: CGFloat.zero, y: CGFloat.zero)
                if self.dragState == .good {
                    let x = newCgPoint.x
                    let y = newCgPoint.y

                    let currentOffSet = CGSize(width: x, height: y)
                    
                    self.newOffSet = currentOffSet
                    self.dragAmount = currentOffSet
                } else {
                    self.dragAmount = .zero
                    self.newOffSet = .zero
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
