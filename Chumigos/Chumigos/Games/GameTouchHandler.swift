//
//  GameTouchHandler.swift
//  Chumigos
//
//  Created by Annderson Packeiser Oreto on 05/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation
import SwiftUI

/// Touch handler used to detect begin and end of touch gesture
struct GameTouchHandler: UIViewRepresentable {
    
    // MARK: - Variables
    
    var didBeginTouch: (() -> Void)?
    var didEndTouch: (() -> Void)?
    
    // MARK: - Functions

    // Create a standard UIKit gesture recognizer
    func makeUIView(context: UIViewRepresentableContext<GameTouchHandler>) -> UIView {
        
        let view = UIView(frame: .zero)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(context.coordinator.makeGesture(didBegin: didBeginTouch, didEnd: didEndTouch))
        return view;
    }

    // Function required because UIViewRpresentable protocol
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<GameTouchHandler>) {
        
    }

    // Coordinator used to provide gesture handler functions
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    class Coordinator {
        
        @objc func action(_ sender: Any?) {
            print("Tapped!")
        }

        // Create a didBegin and didEnd gesture block
        func makeGesture(didBegin: (() -> Void)?, didEnd: (() -> Void)?) -> GameTapGesture {
            GameTapGesture(target: self, action: #selector(self.action(_:)), didBeginTouch: didBegin, didEndTouch: didEnd)
        }
    }
}
