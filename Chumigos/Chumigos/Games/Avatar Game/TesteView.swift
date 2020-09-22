//
//  TesteView.swift
//  Loggio
//
//  Created by Arthur Bastos Fanck on 22/09/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import SwiftUI

struct TesteView: View {
    @ObservedObject var vm = TesteVM()
    
    let screenWidth = UIScreen.main.bounds.height
    let avatarWidth = UIScreen.main.bounds.height * 0.63
    let avatarHeight = UIScreen.main.bounds.height * 0.85
    
    var body: some View {
        NavigationView {
            HStack {
                //GeometryReader { geometry in
                imageView()
                        .onTapGesture {
                            let teste = self.imageView().asImage()
                            self.vm.avatarImage = teste
                            print(teste)
                    }
                //}
                NavigationLink("Next Screen", destination: NextView(image: self.vm.cropFaceOfAvatar()))
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

extension TesteView {
    
    func imageView() -> some View {
        Image("avatar-main-asset")
        .resizable()
        .frame(width: avatarWidth, height: avatarHeight)
        .overlay(
            VStack(spacing: 0) {
                self.imageForEyebrow()
                    .padding(.top, self.screenWidth * 0.18)
                self.imageForEye()
                    .padding(.top, -(self.screenWidth * 0.008))
                self.imageForMouth()
                    .padding(.top, self.screenWidth * 0.01)
                Spacer()
            }.padding(.trailing, self.screenWidth * 0.025)
        )
    }
    
    func imageForEyebrow() -> some View {
        Image("avatar-eyebrow/01")
            .resizable()
            .frame(width: avatarWidth * 0.37, height: avatarWidth * 0.067)
    }
    
    func imageForEye() -> some View {
        Image("avatar-eyes/01")
            .resizable()
            .frame(width: avatarWidth * 0.37, height: avatarWidth * 0.13)
    }
    
    func imageForMouth() -> some View {
        Image("avatar-mouth/01")
            .resizable()
            .frame(width: avatarWidth * 0.15, height: avatarWidth * 0.13)
    }
}

struct NextView: View {
    var image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .border(Color.white)
    }
}

class TesteVM: ObservableObject {
    @Published var avatarImage: UIImage = UIImage()
    
    func cropFaceOfAvatar() -> UIImage {
        let imageWidth = avatarImage.size.width
        let width: CGFloat = imageWidth*0.4
        let height: CGFloat = imageWidth*0.4
        let origin = CGPoint(x: (imageWidth - width)/2.15, y: height/1.7)
        let size = CGSize(width: width, height: height)

        return avatarImage.crop(rect: CGRect(origin: origin, size: size)) ?? UIImage()
    }
}

struct TesteView_Previews: PreviewProvider {
    static var previews: some View {
        TesteView()
    }
}
