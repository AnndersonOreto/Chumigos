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
    
    private var sizeOfSequence: Int = 0
    private var sequence: [Int] = []
    private var pattern: [Int] = []
    private var difficulty: DIFFICULT = .EASY
    private var repetition: Int = 0
    
    init() {
        
    }

    func generateSequence(diff: DIFFICULT) -> [Int]{
        switch diff {
        case .EASY:
            difficulty = .EASY
            sizeOfSequence = generateSizeOfSequence()
            repetition = 2
            sequence = generateRandomSequence(size: sizeOfSequence, repetition: repetition)
            return sequence
        case .MEDIUM:
            difficulty = .MEDIUM
            sizeOfSequence = generateSizeOfSequence()
            repetition = 3
            sequence = generateRandomSequence(size: sizeOfSequence, repetition: repetition)
            return sequence
        default:
            difficulty = .HARD
            sizeOfSequence = generateSizeOfSequence()
            repetition = 3
            sequence = generateRandomSequence(size: sizeOfSequence, repetition: repetition)
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
    
    func getDifficulty() -> DIFFICULT {
        return difficulty
    }
    
    func getRepetition() -> Int {
        return repetition
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
    
    func generateSizeOfSequence() -> Int {
        
        let random = Int.random(in: 0...1)

        if random == 0 {
            return 3
        } else {
            return 4
        }
    }
}
