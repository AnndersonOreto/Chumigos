//
//  GeometryGetter.swift
//  Chumigos
//
//  Created by Guilherme Piccoli on 21/07/20.
//  Copyright © 2020 Annderson Packeiser Oreto. All rights reserved.
//

import SwiftUI

// Struct criada para obter informação de tamanho e posição de uma View,
// para isso cria um retângulo transparente por trás da View.
// É através da variável "rect" que podemos ter acesso à essas informações
struct GeometryGetter: View {
    
    @Binding var rect: CGRect
    @ObservedObject var viewModel: SequenceViewModel
    var isQuestion: Bool
    var number: Int
    
    var body: some View {
        
        return GeometryReader { geometry in
            self.makeView(geometry: geometry)
        }
    }
    
    func makeView(geometry: GeometryProxy) -> some View {
        
        // Tem que alterar o rect na main queue de maneira assíncrona,
        // pois estamos mudando em tempo real a posição do objeto, que faz parte da UI
        DispatchQueue.global(qos: .userInteractive).async {
            self.rect = geometry.frame(in: .global)
            if self.isQuestion {
                self.viewModel.answers.append((answer: self.number, rect: self.rect, rectID: 0))
            }
        }
        
        return
            Rectangle()
                .fill(Color.clear)
    }
}
