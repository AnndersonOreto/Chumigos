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
    
    // MARK: - Init
    
    init() {
        ConsumableProducts.store.delegate = self
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
    
    // Formats product's price for the current locale and with currency style
    static public func formattedPrice(for product: SKProduct) -> String {
        let formatter = NumberFormatter()
        
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        
        return formatter.string(from: product.price) ?? ""
    }
}

extension ProductsViewModel: InAppProtocol {
    func didCompletePayment(for product: String) {
        if let quantity = Int(product.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)),
           let lifeManager = environmentManager?.profile?.lifeManager {
            lifeManager.incrementLife(by: quantity, isBonus: true)
        }
    }
}
