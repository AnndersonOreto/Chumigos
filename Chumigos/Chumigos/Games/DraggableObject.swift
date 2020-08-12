
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
    
    //Content recieve any view
    let content: Content
    //Object answer
    let answer: Int
    
    //State to see if can or cannot drop the object
    @State var dragState = DragState.unknown
    //Variable to save the rect of the object
    @State var rect: CGRect = .zero
    
    //OffSet Variables
    @State var dragAmount = CGSize.zero
    @State var newOffSet = CGSize.zero
    
    //Closures that was written on the view
    var onChanged: ((CGPoint, Int) -> DragState)?
    var onEnded: ((CGPoint, CGRect, Int, DragState) -> (x: CGFloat, y: CGFloat))?
    
    init(@ViewBuilder content: () -> Content, onChanged: @escaping (CGPoint, Int) -> DragState, onEnded: @escaping (CGPoint, CGRect, Int, DragState) -> (x: CGFloat, y: CGFloat), answer: Int) {
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
                        //saving rect here
                        self.rect = geo.frame(in: .global)
                }
            })
            .offset(dragAmount)
            .gesture(
                DragGesture(coordinateSpace: .global)
                    .onChanged{
                        //Changing dragAmount based on the drag translation
                        self.dragAmount = CGSize(width: $0.translation.width + self.newOffSet.width, height: $0.translation.height + self.newOffSet.height)
                        //Saving the state of the drag
                        self.dragState = self.onChanged?($0.location, self.answer) ?? .unknown
                }
                .onEnded{
                    
                    //Getting drop location
                    let newCgPoint = self.onEnded?($0.location, self.rect, self.answer, self.dragState) ?? (x: CGFloat.zero, y: CGFloat.zero)
                    
                    //if can drop the object, place it on the drop location however if cannot drop reset the object offset
                    if self.dragState == .good {
                        
                        //Getting x and y position of the drop location
                        let x = newCgPoint.x
                        let y = newCgPoint.y
                        
                        //making a cgsize with the position
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
}
