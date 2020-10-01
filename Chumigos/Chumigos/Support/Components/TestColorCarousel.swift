//
//  TestColorCarousel.swift
//  Loggio
//
//  Created by Marcus Vinicius Vieira Badiale on 30/09/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import SwiftUI

struct TestColorCarousel: View {
    
    var colorCarousel = ColorCarousel()
    
    //Every 7 seconds tells the view to change the color
    let timer = Timer.publish(every: 7, on: .main, in: .common).autoconnect()
    
    @State var currentColor: Color = Color.clear
    
    var body: some View {
        
        Rectangle()
            .fill(currentColor)
            .animation(
                Animation.easeInOut(duration: 2)
            )
            //Recieve the publish from timer
            .onReceive(timer) { _ in
                //change the first color of the array 
                self.colorCarousel.next()
                self.currentColor = self.colorCarousel.getFirstColor() ?? Color.clear
            }
            .onAppear {
                self.currentColor = self.colorCarousel.getFirstColor() ?? Color.clear
            }
    }
}

struct TestColorCarousel_Previews: PreviewProvider {
    static var previews: some View {
        TestColorCarousel()
    }
}
