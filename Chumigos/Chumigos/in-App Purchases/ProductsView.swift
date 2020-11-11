//
//  ProductsView.swift
//  Loggio
//
//  Created by Annderson Packeiser Oreto on 11/11/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import Foundation
import SwiftUI
import StoreKit

struct ProductsView: View {
    
    @ObservedObject var viewModel: ProductsViewModel = ProductsViewModel()
    
    var body: some View {
        
        ZStack {
            
            // Print products vertically
            VStack {
                
                ForEach(self.viewModel.products, id: \.self) { product in
                    
                    HStack {
                        Text(product.localizedTitle)
                        Text(ProductsViewModel.priceFormatter.string(from: product.price) ?? "")
                    }
                }
            }
        }
    }
}
