//
//  FeelingsClassifier.swift
//  Loggio
//
//  Created by Arthur Bastos Fanck on 21/09/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import CoreML
import Vision

class FeelingsClassifier {
    
    static func classifyImage(_ myImage: CGImage, orientation: CGImagePropertyOrientation) {
        if let model = try? VNCoreMLModel(for: logginhoFeelings2_0().model) {
            let request = VNCoreMLRequest(model: model, completionHandler: handleResults(request:error:))
            request.imageCropAndScaleOption = .centerCrop
            
            DispatchQueue.global(qos: .userInitiated).async {
                let handler = VNImageRequestHandler(cgImage: myImage, orientation: orientation)
                do {
                    try handler.perform([request])
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    static func handleResults(request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results as? [VNClassificationObservation] else {
                print(error!.localizedDescription)
                return
            }
            for classification in results {
                print("\(classification.identifier): \(classification.confidence)")
            }
        }
    }
}
