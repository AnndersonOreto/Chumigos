//
//  AsImage.swift
//  Loggio
//
//  Created by Arthur Bastos Fanck on 22/09/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import Foundation
import SwiftUI

extension View {
    func asImage() -> UIImage {
        let controller = UIHostingController(rootView: self)

        // locate far out of screen
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)

        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()

        let image = controller.view.asImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        let renderedImage = renderer.image { (context) in
            layer.render(in: context.cgContext)
        }
        return renderedImage
    }
}
