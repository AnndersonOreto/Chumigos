//
//  FeelingClassificator.swift
//  Loggio
//
//  Created by Marcus Vinicius Vieira Badiale on 21/09/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import Foundation
import Vision

class FeelingClassificator{
    
//    Image (Color 299 x 299)
    
    let model = logginhoFeelings2_0()
    
    init() {
        
    }
    
    func performImageClassification(_ image: CVPixelBuffer) {
        
        let output = try? model.prediction(image: image)
        
        if let output = output {
            
            //Return category string. examples: "happy", "sad"...
            let mostLikelyCategory = output.classLabel
            
            //Probability of each category as dictionary of strings to doubles
            //returns [String : Double]
            let categoryWithPropability =  output.classLabelProbs
        }
    }
    
}
