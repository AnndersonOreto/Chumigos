//
//  UIImage+Crop.swift
//  Loggio
//
//  Created by Arthur Bastos Fanck on 22/09/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import UIKit

extension UIImage {
    func crop(rect: CGRect) -> UIImage? {
        var rect = rect
        rect.origin.x *= self.scale
        rect.origin.y *= self.scale
        rect.size.width *= self.scale
        rect.size.height *= self.scale
        
        guard let croppedImage = self.cgImage?.cropping(to: rect) else { return nil }
        
        return UIImage(cgImage: croppedImage, scale: self.scale, orientation: self.imageOrientation)
    }
}
