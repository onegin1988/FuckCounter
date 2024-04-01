//
//  CongratsView.swift
//  FuckCounter
//
//  Created by Alex on 11.12.2023.
//

import SwiftUI

struct CongratsView: View {
    
    private let userModel: UserModel?
    private let count: Int
    private let subTitle: String
    
    init(userModel: UserModel?, count: Int = 0, subTitle: String) {
        self.userModel = userModel
        self.count = count
        self.subTitle = subTitle
    }
    
    var body: some View {
        ZStack(alignment: .top, content: {
            Colors._2B1011
            
            imageBGView()
            
            profileImageView()
                .padding(.top, 78)
            
//            crownImageView()
//                .padding(.top, 54)
            
            labelsView()
                .padding(.top, 200)
        })
    }
    
    private func imageBGView() -> some View {
        LottieView(animationName: "Сonfetti")
    }
    
    private func profileImageView() -> some View {
        ImageView(url: userModel?.image ?? "")
            .frame(width: 96, height: 96)
            .background(
                Circle()
                    .stroke(Colors._F7BC2C, lineWidth: 4)
                    .background(content: {
                        Circle()
                            .fill(.white)
                    })
            )
    }
    
//    private func crownImageView() -> some View {
//        Images.crown_2
//            .frame(width: 40, height: 40)
//    }
    
    private func labelsView() -> some View {
        VStack(alignment: .center, spacing: 16) {
            MediumTextView(
                style: .sfPro,
                title: count.withCommas(),
                size: 48,
                color: .white
            )
            .multilineTextAlignment(.center)
            
            BoldTextView(
                style: .sfPro,
                title: subTitle,//"Congrat’s, you’re King of\nBad words for today",
                size: 19,
                color: Colors._F2F2F2
            )
            .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    CongratsView(userModel: nil, count: 0, subTitle: "")
}
