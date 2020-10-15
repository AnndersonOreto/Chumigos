//
//  FeelingClassificator.swift
//  Loggio
//
//  Created by Marcus Vinicius Vieira Badiale on 21/09/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import Foundation
import UIKit

class FeelingClassificator {
    
    /// This fuction is for classify an image.
    /// - Parameter image: receive an UIImage.toBuffer().
    /// - Returns: the most likely category the model predicted.
    static func mostLikely(_ image: CVPixelBuffer) -> String? {
        let model = LogginhoFeelingsClassifier()
        let output = try? model.prediction(image: image)
        
        if let output = output {
            let mostLikelyCategory = output.classLabel
            
            return mostLikelyCategory
        }
        return nil
    }
    
    /// This function is for classify an image.
    /// - Parameter image: receive an UIImage.toBuffer().
    /// - Returns: the probability of each category as a dictionary.
    static func allPredictions(_ image: CVPixelBuffer) -> [String : Double]? {
        let model = LogginhoFeelingsClassifier()
        let output = try? model.prediction(image: image)
        
        if let output = output {
            let categoryWithPropability =  output.classLabelProbs
            
            return categoryWithPropability
        }
        return nil
    }
}
