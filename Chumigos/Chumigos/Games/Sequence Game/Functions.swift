//
//  Functions.swift
//  Chumigos
//
//  Created by Arthur Bastos Fanck on 16/07/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import Foundation

enum DIFFICULT {
    case EASY, MEDIUM, HARD
}

class Functions {
    
    var sizeOfSequence: Int = 0
    var sequence: [Int] = []
    var pattern: [Int] = []
    
    init() {
        
    }

    func generateSequence(diff: DIFFICULT) -> [Int]{
        switch diff {
        case .EASY:
            sizeOfSequence = 3
            sequence = generateRandomSequence(size: sizeOfSequence, repetition: 2)
            return sequence
        case .MEDIUM:
            sizeOfSequence = 4
            sequence = generateRandomSequence(size: sizeOfSequence, repetition: 3)
            return sequence
        default:
            sizeOfSequence = 5
            sequence = generateRandomSequence(size: sizeOfSequence, repetition: 4)
            return sequence
        }
    }
    
    func getSize() -> Int {
        return sizeOfSequence
    }
    
    func getSequence() -> [Int] {
        return sequence
    }
    
    func getPattern() -> [Int] {
        return pattern
    }
    
    func generateRandomSequence(size: Int, repetition: Int) -> [Int] {
        sizeOfSequence = size
        var array = generatePattern(size: size)
        pattern = array
        
        //var matrix: [[Int]] = []
        let arrayAux = array
        for _ in 1..<repetition {
            array += arrayAux
        }

        return array
    }
    

    
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
