//
//  PreLaunchView.swift
//  Loggio
//
//  Created by Annderson Packeiser Oreto on 15/10/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import SwiftUI

struct PreLaunchView: View {
    
    @EnvironmentObject var environmentManager: EnvironmentManager
    
    //all images of the animaton
    @State var splashImages: [String] = [
        "splash-screen00", "splash-screen01", "splash-screen02", "splash-screen03", "splash-screen04", "splash-screen05",
        "splash-screen06", "splash-screen07", "splash-screen08", "splash-screen09", "splash-screen10", "splash-screen11",
        "splash-screen12", "splash-screen13", "splash-screen14", "splash-screen15", "splash-screen16", "splash-screen17",
        "splash-screen18", "splash-screen19", "splash-screen20", "splash-screen21", "splash-screen22", "splash-screen23",
        "splash-screen24", "splash-screen25", "splash-screen26", "splash-screen27", "splash-screen28", "splash-screen29",
        "splash-screen30", "splash-screen31", "splash-screen32", "splash-screen33", "splash-screen34", "splash-screen35",
        "splash-screen36", "splash-screen37", "splash-screen38", "splash-screen39", "splash-screen40", "splash-screen41",
        "splash-screen42", "splash-screen43", "splash-screen44", "splash-screen45", "splash-screen46", "splash-screen47",
        "splash-screen48", "splash-screen49", "splash-screen50", "splash-screen51", "splash-screen52", "splash-screen53",
        "splash-screen54", "splash-screen55", "splash-screen56", "splash-screen57", "splash-screen58", "splash-screen59",
        "splash-screen60", "splash-screen61", "splash-screen62", "splash-screen63", "splash-screen64", "splash-screen65",
        "splash-screen66", "splash-screen67", "splash-screen68", "splash-screen69", "splash-screen70", "splash-screen71",
        "splash-screen72", "splash-screen73", "splash-screen74", "splash-screen75", "splash-screen76", "splash-screen77",
        "splash-screen78", "splash-screen79", "splash-screen80", "splash-screen81", "splash-screen82", "splash-screen83",
        "splash-screen84", "splash-screen85", "splash-screen86", "splash-screen87", "splash-screen88", "splash-screen89"]
    //Current image in the animation
    @State var imageIndex: Int = 0
    //Timer to change current image over time
    let timer = Timer.publish(every: 0.04, on: .main, in: .common).autoconnect()
    
    //Navigation Variables
    @State var goToMain = false
    @State var goToLogin = false
    
    func getUser() {
        
        environmentManager.listen()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                //MainView navigation link, when goToMain become true goes to main view
                NavigationLink("", destination: MainView(), isActive: $goToMain)
                //LoginView navigation link, when goToLogin become true goes to login/signup view
                NavigationLink("", destination: InitialScreen(), isActive: $goToLogin)
                //Background color for the animation occupy theh whole screen
                Color.Macaw
                //Animation image
                Image(splashImages[imageIndex])
                    .scaledToFit()
                    .onReceive(timer) { _ in
                        if self.imageIndex < self.splashImages.count-1 {
                            //Changing current image
                            self.imageIndex += 1
                        } else {
                            //Stoping the timer
                            self.timer.upstream.connect().cancel()
                            //Change screen here
                            if self.environmentManager.profile != nil {
                                self.goToMain = true
                            } else {
                                self.goToLogin = true
                            }
                        }
                }                
            }.onAppear(perform: getUser)
            .edgesIgnoringSafeArea(.all)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct PreLaunchView_Previews: PreviewProvider {
    static var previews: some View {
        PreLaunchView()
    }
}
