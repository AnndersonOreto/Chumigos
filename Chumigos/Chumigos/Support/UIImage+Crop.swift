//
//  UIImage+Crop.swift
//  Loggio
//
//  Created by Arthur Bastos Fanck on 22/09/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// Crop the image into a subimage of the size of rect.
    /// - Parameter rect: A rectangle specifying the portion of the image to keep.
    /// - Returns: A UIImage object that specifies a subimage of the image.
    func crop(rect: CGRect) -> UIImage? {
        var rect = rect
        rect.origin.x *= self.scale
        rect.origin.y *= self.scale
        rect.size.width *= self.scale
        rect.size.height *= self.scale
        
        guard let croppedImage = self.cgImage?.cropping(to: rect) else { return nil }
        
        return UIImage(cgImage: croppedImage, scale: self.scale, orientation: self.imageOrientation)
    }

    /// Resizes the selected image to the size parameter.
    /// - Parameter size: size wanted for the image.
    /// - Returns: UIImage with the new size.
    func resizeTo(_ size: CGSize) -> UIImage?  {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    /// Converts UIImage to CVPixelBuffer.
    /// - Returns: CVPixelBuffer of the image.
    func toBuffer() -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey : kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey : kCFBooleanTrue] as CFDictionary
        
        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(self.size.width), Int(self.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
}
