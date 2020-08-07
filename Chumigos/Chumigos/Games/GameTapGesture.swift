//
//  GameTapGesture.swift
//  Chumigos
//
//  Created by Annderson Packeiser Oreto on 05/08/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation
import SwiftUI

/// Class used to handle UIKit gestures
class GameTapGesture : UITapGestureRecognizer {

    // MARK: - Vriables
    
    var didBeginTouch: (() -> Void)?
    var didEndTouch: (() -> Void)?
    
    // MARK: - Init

    init(target: Any?, action: Selector?, didBeginTouch: (() -> Void)? = nil, didEndTouch: (() -> Void)? = nil) {
        
        super.init(target: target, action: action)
        self.didBeginTouch = didBeginTouch
        self.didEndTouch = didEndTouch
    }
    
    // MARK: - Gesture handlers

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        
        super.touchesBegan(touches, with: event)
        self.didBeginTouch?()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        
        super.touchesEnded(touches, with: event)
        self.didEndTouch?()
    }
}
