//
//  LifeBanner.swift
//  Loggio
//
//  Created by Marcus Vinicius Vieira Badiale on 04/11/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import SwiftUI
import StoreKit

struct LifeBanner: View {

    let screenWidth = UIScreen.main.bounds.width
    @Binding var showLifeBanner: Bool

    var timer = Timer.publish(every: 0, on: .current, in: .common).autoconnect()
    @State var remainingTime: String = ""

    @EnvironmentObject var environmentManager: EnvironmentManager
    @ObservedObject var viewModel: LifeBannerViewModel = LifeBannerViewModel()
    
    @Binding var tab: TabItem
    
    var body: some View {

        ZStack {
            //Rectangle in the back to close the view when is tapped
            Rectangle().fill(Color.background).opacity(0.1)
            .onTapGesture {
                self.showLifeBanner = false
            }

            //VStack to push banner for the top
            VStack {
                //HStack to make background the whole width of the screen
                HStack {
                    Spacer()
                    //Main VStack
                    VStack(spacing: 12) {
                        if self.environmentManager.profile?.lifeManager.totalLifes == 0 {
                            CustomText("Suas energias acabaram!")
                            .dynamicFont(size: 20, weight: .medium)
                            .foregroundColor(.textColor)
                            .padding(.top)
                        } else {
                            CustomText("Você possui \(self.environmentManager.profile?.lifeManager.totalLifes ?? 0) energias!")
                            .dynamicFont(size: 20, weight: .medium)
                            .foregroundColor(.textColor)
                            .padding(.top)
                        }

                        if (self.environmentManager.profile?.lifeManager.countLife ?? 0) < 5 {
                            HStack(spacing: 0) {
                                CustomText("A próxima energia recarrega em ")
                                    .dynamicFont(size: 20, weight: .medium)
                                    .foregroundColor(.textColor)
                                CustomText(remainingTime)
                                    .dynamicFont(size: 25, weight: .medium)
                                    .foregroundColor(.Owl)
                            }.onReceive(timer) { _ in
                                if let remaining = self.environmentManager.profile?.lifeManager.remainingTime() {
                                    self.remainingTime = remaining
                                }
                            }
                        }

                        HStack(spacing: 34) {
                            ForEach(self.viewModel.products, id: \.self) { product in

                                paidLife(product: product)
                            }
                        }.padding(.vertical)

                    }.padding()

                    Spacer()

                }.background(
                    Rectangle()
                    .fill(Color.background)
                    .customRoundedCorners(radius: 22, corners: [.bottomLeft,  .bottomRight])
                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.15000000596046448)), radius:12, x:0, y:7)
                )
                Spacer()
            }
            .onAppear {
                self.viewModel.environmentManager = self.environmentManager
            }
        }
    }
}


extension LifeBanner {
    
    func freeLife(lifeCount: Int) -> some View {
        VStack {
            Image("icon-life")
                .resizable()
                .frame(width: screenWidth * 0.031, height: screenWidth * 0.063)
            
            CustomText("+\(lifeCount) Energia")
                .dynamicFont(size: 16, weight: .bold)
                .foregroundColor(.textColor)
            
            CustomText("Praticar")
                .padding(.top, 10)
        }.frame(width: screenWidth * 0.1549, height: screenWidth * 0.1624)
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(Color.popUpBackground)
                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.15000000596046448)), radius:12, x:0, y:0)
        )
    }
    
    func paidLife(product: SKProduct) -> some View {
        VStack {
            Image(product.productIdentifier)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: screenWidth * 0.063)
            
            CustomText("+\(product.productIdentifier.suffix(2)) Energias")
                .dynamicFont(size: 16, weight: .bold)
                .foregroundColor(.textColor)
            
            CustomText("Recarregar")
                .dynamicFont(size: 16, weight: .regular)
                .foregroundColor(.Owl)
                .padding(.top, 10)
        }
        .frame(width: screenWidth * 0.1549, height: screenWidth * 0.1624)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.popUpBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                    .strokeBorder(Color.Humpback, lineWidth: 5)
                )
                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.15000000596046448)), radius:12, x:0, y:0)
        )
        .onTapGesture {
            self.showLifeBanner = false
            self.tab = .shop
        }
    }
    
    func unlimitedLife() -> some View {
        VStack {
            Image("icon-buffed-life")
                .resizable()
                .frame(width: screenWidth * 0.031, height: screenWidth * 0.063)
            
            CustomText("Ilimitada")
                .dynamicFont(size: 16, weight: .bold)
                .foregroundColor(.Ghost)
            
            CustomText("Teste Grátis")
                .dynamicFont(size: 16, weight: .regular)
                .foregroundColor(.Ghost)
                .padding(.top, 10)
        }
        .frame(width: screenWidth * 0.1549, height: screenWidth * 0.1624)
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.Humpback)
                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.15000000596046448)), radius:12, x:0, y:0)
        )
    }
}
