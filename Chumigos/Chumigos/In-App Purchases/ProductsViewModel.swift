//
//  ProductsViewModel.swift
//  Loggio
//
//  Created by Annderson Packeiser Oreto on 11/11/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import Foundation
import SwiftUI
import StoreKit

class ProductsViewModel: ObservableObject {
    
    // MARK: - Combine variables
    
    @Published var products: [SKProduct] = []
    @Published var environmentManager: EnvironmentManager?
    
    // MARK: - Variables
    
    static let priceFormatter: NumberFormatter = {
      let formatter = NumberFormatter()
      
      formatter.formatterBehavior = .behavior10_4
      formatter.numberStyle = .currency
      
      return formatter
    }()
    
    // MARK: - Init
    
    init() {
        reloadProducts()
    }
    
    // MARK: - Functions
    
    // Reload the products in View by requesting Apple IAP
    func reloadProducts() {
        products = []
        
        ConsumableProducts.store.requestProducts { [weak self] success, products in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                if success {
                    print(products!)
                    self.products = products!
                }
            }
        }
    }
}
