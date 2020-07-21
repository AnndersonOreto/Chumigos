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
    
    init() {
        
    }

    func generateSequence(diff: DIFFICULT) -> [Int]{
        switch diff {
        case .EASY:
            sizeOfSequence = 3
            return generateRandomSequence(size: 3, repetition: 2)
        default:
            return generateRandomSequence(size: 3, repetition: 2)
        }
    }
    
    func generateRandomSequence(size: Int, repetition: Int) -> [Int] {
        sizeOfSequence = size
        var array = generatePattern(size: size)

        //var matrix: [[Int]] = []
        let arrayAux = array
        for _ in 1..<repetition {
            array += arrayAux
        }

        print(array)
        return array
    }
    
    func getSize() -> Int {
        return sizeOfSequence
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
