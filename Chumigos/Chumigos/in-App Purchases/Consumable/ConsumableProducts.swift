//
//  ConsumableProducts.swift
//  Loggio
//
//  Created by Annderson Packeiser Oreto on 11/11/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import Foundation

public struct ConsumableProducts {
    
    public static let SwiftShopping = "com.mc.Chumigos.generaluserlife"
    
    private static let productIdentifiers: Set<ProductIdentifier> = [ConsumableProducts.SwiftShopping]
    
    public static let store = IAPHelper(productIds: ConsumableProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
