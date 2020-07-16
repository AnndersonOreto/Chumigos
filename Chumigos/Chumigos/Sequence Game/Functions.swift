//
//  Functions.swift
//  Chumigos
//
//  Created by Arthur Bastos Fanck on 16/07/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation

class Functions {
    
//    func generateSequence(size: Int, repetition: Int) -> [[Int]] {
//
//        var array: [Int] = []
//
//        for n in 1...size {
//            array.append(n)
//        }
//
//        array.shuffle()
//
//        var matrix: [[Int]] = []
//
//        for _ in 1...repetition {
//            matrix.append(array)
//        }
//
//        print(array)
//        print(matrix)
//
//        return matrix
//    }
    
    func generatePattern(size: Int) -> [Int] {
        
        var array: [Int] = []
        
        for n in 1...size {
            array.append(n)
        }
        
        array.shuffle()
        
        return array
    }
    
    func generateSequence(num_of_patterns: Int, sizes: [Int], repetition: Int) -> [[Int]]? {
        
        if num_of_patterns == sizes.count {
            
            var matrix: [[Int]] = []
            
            for n in 0..<num_of_patterns {
                let pattern = generatePattern(size: sizes[n])
                matrix.append(pattern)
            }
            
            var sequence: [[Int]] = []
            
            for _ in 1...repetition {
                sequence += matrix
            }
            
            return sequence
            
        } else {
         
            return nil
            
        }
    }
}
