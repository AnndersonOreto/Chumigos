//
//  SplashScreen.swift
//  Loggio
//
//  Created by Marcus Vinicius Vieira Badiale on 28/10/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import SwiftUI

struct SplashScreen: View {
    
    @State var splashImages: [String] = []
    @State var imageIndex: Int = 0
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        .onAppear(perform: generateSplashArray)
    }
    
    
    func generateSplashArray() {
        
        for i in 0...89 {
            let splashIndex = String(format: "%02d", i)
            let imageString = "splash-screen\(splashIndex)"
            splashImages.append(imageString)
        }
        print(splashImages)
    }
}

//struct SplashScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        SplashScreen()
//    }
//}
