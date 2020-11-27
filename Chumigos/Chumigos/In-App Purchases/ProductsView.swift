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
    
    @EnvironmentObject var environmentManager: EnvironmentManager
    @ObservedObject var viewModel: ProductsViewModel = ProductsViewModel()
    
    var body: some View {
        Group {
        //ScrollView(.vertical, showsIndicators: true) {
            // Print products vertically
            VStack {
                
                ForEach(self.viewModel.products, id: \.self) { product in
                    
                    ProductView(product: product)
                }
            }.padding(50)
        }.navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            self.viewModel.environmentManager = self.environmentManager
        }
    }
}

struct ProductView: View {
    
    var product: SKProduct?
    @State var productName: String = ""
    @State var productDescription: String = ""
    @State var productPrice: String = ""
    @State var buttonText: String = ""
    @State var productImage: String = ""
    var backgroundImage: String =  "recarga-roxo"
    
    var screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        
        Image(backgroundImage)
            .frame(width: screenWidth * 0.64, height: screenWidth * 0.18)
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:12, x:0, y:0)
            .onAppear(perform: setup)
            .overlay(
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading) {
                        CustomText(self.productName)
                            .dynamicFont(size: 50, weight: .medium)
                            .foregroundColor(.Eel)
                        
                        Spacer()
                        
                        CustomText(self.productDescription)
                            .dynamicFont(size: 18, weight: .medium)
                            .foregroundColor(.Eel)
                            .lineLimit(nil)
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                    
                    VStack {
                        Image(self.productImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: self.screenWidth * 0.081, height: self.screenWidth * 0.076)
                        
                        Button(action: {
                            if let product = self.product {
                                ConsumableProducts.store.buyProduct(product)
                            }
                        }) {
                            CustomText(self.productPrice)
                        }.buttonStyle(
                            AppButtonStyle(buttonColor: Color.Owl,
                                           pressedButtonColor: Color.Turtle,
                                           buttonBackgroundColor: Color.TreeFrog,
                                           isButtonEnable: true, width: self.screenWidth * 0.16))
                    }
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 60)
        )
    }
    
    func setup() {
        
        guard let product = product else { return }
        
        productName = product.localizedTitle
        productDescription = product.localizedDescription
        
        if productName.contains("10") {
            productImage = "energy-10x"
        } else if productName.contains("15") {
            productImage = "energy-15x"
        } else if productName.contains("20") {
            productImage = "energy-20x"
        }
        
        buttonText = "Comprar"
        
        if IAPHelper.canMakePayments() {
            productPrice = ProductsViewModel.formattedPrice(for: product)
        }
    }
}
