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
                    
                    ProductView(product: product)
                }
            }
        }
    }
}

struct ProductView: View {
    
    var product: SKProduct?
    @State var productName: String = ""
    @State var productPrice: String = ""
    @State var buttonText: String = ""
    
    var body: some View {
        
        HStack {
            Text(productName)
            Text(productPrice)
            Button {
                ConsumableProducts.store.buyProduct(product!)
            } label: {
                Text(buttonText)
            }
        }.onAppear(perform: setup)
    }
    
    func setup() {
        
        guard let product = product else { return }
        
        productName = product.localizedTitle
        
        if ConsumableProducts.store.isProductPurchased(product.productIdentifier) {
            productPrice = "COMPROU"
            buttonText = "Comprar"
        } else if IAPHelper.canMakePayments() {
            productPrice = ProductsViewModel.priceFormatter.string(from: product.price) ?? ""
            buttonText = "Comprar"
        }
    }
    
}
