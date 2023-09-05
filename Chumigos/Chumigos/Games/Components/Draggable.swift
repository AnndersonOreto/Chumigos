//
//  Draggable.swift
//  Chumigos
//
//  Created by Arthur Bastos Fanck on 12/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

enum DragState {
    case unknown, good
}

// Does the same thing that DraggableObject does, but as a ViewModifier
struct Draggable: ViewModifier {
    //State to see if can or cannot drop the object
    @State private var dragState = DragState.unknown
    //Variable to save the rect of the object
    @State private var rect: CGRect = .zero
    
    //OffSet Variables
    @State private var dragAmount = CGSize.zero
    @State private var newOffSet = CGSize.zero
    
    //Closures that was written on the view
    var onChanged: ((CGPoint, Int) -> DragState)?
    var onEnded: ((CGPoint, CGRect, Int, DragState) -> (x: CGFloat, y: CGFloat))?
    
    //Object answer
    let answer: Int
    
    @State var isFirstTouchChange: Bool = true
    
    func body(content: Content) -> some View {
        
        //Generic View Here
        content
            .overlay(GeometryReader { geo in
                Color.clear
                    .onAppear {
                        //saving rect here
                        self.rect = geo.frame(in: .global)
                }
            })
            .offset(dragAmount)
            .gesture(
                DragGesture(coordinateSpace: .global)
                    .onChanged {
                        
                        if self.isFirstTouchChange {
                            SoundManager.shared.playSound(gameSound: .pick)
                            self.isFirstTouchChange = false
                        }
                        
                        //Changing dragAmount based on the drag translation
                        self.dragAmount = CGSize(width: $0.translation.width + self.newOffSet.width,
                                                 height: $0.translation.height + self.newOffSet.height)
                        //Saving the state of the drag
                        self.dragState = self.onChanged?($0.location, self.answer) ?? .unknown
                }
                .onEnded {
                    //Getting drop location
                    let newCgPoint = self.onEnded?($0.location, self.rect, self.answer, self.dragState) ?? (x: CGFloat.zero, y: CGFloat.zero)
                    
                    //if can drop the object, place it on the drop location however if cannot drop reset the object offset
                    if self.dragState == .good {
                        
                        //Getting x and y position of the drop location
                        let newX = newCgPoint.x
                        let newY = newCgPoint.y
                        
                        //making a cgsize with the position
                        let currentOffSet = CGSize(width: newX, height: newY)
                        
                        self.newOffSet = currentOffSet
                        self.dragAmount = currentOffSet
                    } else {
                        self.dragAmount = .zero
                        self.newOffSet = .zero
                    }
                    SoundManager.shared.playSound(gameSound: .drop)
                    self.isFirstTouchChange = true
                }
        )
    }
}

extension View {
    // Function to call the modifier more easily
    func draggable(onChanged: @escaping (CGPoint, Int) -> DragState, onEnded: @escaping (CGPoint, CGRect, Int, DragState) -> (x: CGFloat, y: CGFloat), answer: Int) -> some View {
        return self.modifier(Draggable(onChanged: onChanged, onEnded: onEnded, answer: answer))
    }
}
