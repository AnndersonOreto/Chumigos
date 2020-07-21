//
//  DraggableAlternative.swift
//  Chumigos
//
//  Created by Guilherme Piccoli on 21/07/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

struct DraggableAlternative: View {
    
    
    // Variável que salva o tamanho e a posição do retângulo por trás do objeto
    @State private var rect: CGRect = .zero
    
    // Variável que salva a posição do objeto em tempo real, enquanto está sendo arrastado
    @State private var currentOffset: CGSize = .zero
    
    // Variável que salva a posição do objeto depois que é largao, ou seja, sua posição final
    @State private var newOffset: CGSize = .zero
        
    // Variável que salva a posição e o tamanho do lugar certo do objeto
    var rightPlace: CGRect
    
    @ObservedObject var viewModel: SequenceViewModel
    
    var answer: Int
    
    var body: some View {
        
        Rectangle()
            .fill(getRandomColor())
            .frame(width: 50, height: 50)
            .background(GeometryGetter(rect: $rect))
            .offset(self.currentOffset)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        
                        // If pra não deixar mover o objeto depois que estiver no lugar certo
                        if !self.viewModel.isAlternativeInTheRightPlace {
                            self.changeCurrentOffset(by: value)
                        }
                        
                    })
                    .onEnded({ value in
                        
                        // If pra não deixar mover o objeto depois que estiver no lugar certo
                        if !self.viewModel.isAlternativeInTheRightPlace {
                            
                            self.changeCurrentOffset(by: value)
                            
                            self.newOffset = self.currentOffset
                            
                            self.dragEnded()
                        }
                    })
        )
    }
    
    
    func getRandomColor() -> Color {
        switch answer {
        case 1:
            return Color.blue
        case 2:
            return Color.orange
        case 3:
            return Color.red
        case 4:
            return Color.yellow
        case 5:
            return Color.green
        default:
            return Color.black
        }
    }
}

extension DraggableAlternative {
    
    // Altera a posição do objeto enquanto está sendo arrastado
    func changeCurrentOffset(by value: DragGesture.Value) {
        
        self.currentOffset = CGSize(width: value.translation.width + self.newOffset.width, height: value.translation.height + self.newOffset.height)
        
    }
    
    // Função para verificar se o objeto foi largado no lugar certo e com o ângulo certo
    func dragEnded() {
        
        // Salva o ponto médio do objeto quando o objeto é largado
        let midPoint = CGPoint(x: self.rect.midX, y: self.rect.midY)
        
        // Verifica se o ponto médio pertence a área definida como "lugar certo" e se a resposta esta correta
        if self.rightPlace.contains(midPoint) {
            
            if self.viewModel.correctAnswer[0] == answer  {
                // Define os novos valores para X e Y,
                // calculando a distância do ponto médio do objeto para o ponto médio do lugar certo
                let newX = self.rect.midX.distance(to: self.rightPlace.midX)
                let newY = self.rect.midY.distance(to: self.rightPlace.midY)
                
                // Usa os X e Y calculados acima para definir a nova posição do objeto
                self.currentOffset = CGSize(width: newX + self.newOffset.width, height: newY + self.newOffset.height)
                self.newOffset = self.currentOffset
                
                // Muda o estado para mostrar que o objeto está no lugar certo
                self.viewModel.isAlternativeInTheRightPlace = true
            }
                        
            // Caso não seja o lugar certo do objeto, reseta sua posição
        } else {
            self.currentOffset = .zero
            self.newOffset = .zero
        }
        
    }
}


