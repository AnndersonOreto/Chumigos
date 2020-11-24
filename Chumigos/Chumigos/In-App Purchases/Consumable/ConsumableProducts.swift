//
//  ConsumableProducts.swift
//  Loggio
//
//  Created by Annderson Packeiser Oreto on 11/11/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import Foundation

public struct ConsumableProducts {
    
    public static let energy5 = "com.mc.Chumigos.energy5"
    public static let energy10 = "com.mc.Chumigos.energy10"
    public static let energy20 = "com.mc.Chumigos.energy20"
    
    private static let productIdentifiers: Set<ProductIdentifier> = [ConsumableProducts.energy5,
                                                                     ConsumableProducts.energy10,
                                                                     ConsumableProducts.energy20]
    
    public static let store = IAPHelper(productIds: ConsumableProducts.productIdentifiers)
}

func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
    return productIdentifier.components(separatedBy: ".").last
}
