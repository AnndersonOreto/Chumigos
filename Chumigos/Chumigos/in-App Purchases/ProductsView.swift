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
        }.navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ProductView: View {
    
    var product: SKProduct?
    @State var productName: String = ""
    @State var productDescription: String = "adjkshadshijiashjsajkhask ejsadhadksjgaks kaskjhadksfj ajksh akshjakshj"
    @State var productPrice: String = ""
    @State var buttonText: String = ""
    @State var productImage: String = "Avatar 1"
    var backgroundImage: String =  "RECARGA VERDE"
    
    var screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        
        Image(backgroundImage)
            .resizable()
            .frame(width: screenWidth * 0.64, height: screenWidth * 0.18)
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:12, x:0, y:0)
            .onAppear(perform: setup)
            .overlay(
                HStack {
                    VStack(alignment: .leading) {
                        CustomText(self.productName)
                            .dynamicFont(size: 50, weight: .regular)
                        
                        Spacer()
                        
                        CustomText(self.productDescription)
                            .dynamicFont(size: 18, weight: .regular)
//                            .frame(width: screenWidth * 0.33, height: screenWidth *  0.045)
                            .lineLimit(nil)
                    }.padding(.vertical)
                        .padding(.trailing, 30)
                    
                    Spacer()
                    
                    VStack {
                        Image(self.productImage)
                            .resizable()
                            .frame(width: self.screenWidth * 0.071, height: self.screenWidth * 0.066)
                        
                        Button(action: {
                            //compra ae chumiga
                        }) {
                            CustomText("R$\(self.productPrice)" )
                        }.buttonStyle(
                            AppButtonStyle(buttonColor: Color.Owl,
                                           pressedButtonColor: Color.Turtle,
                                           buttonBackgroundColor: Color.TreeFrog,
                                           isButtonEnable: true, width: self.screenWidth * 0.16))
                    }.padding(.vertical)
                }.padding(.horizontal, 30)
                .padding(.vertical, 30)
        )
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
