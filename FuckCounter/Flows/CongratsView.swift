//
//  CongratsView.swift
//  FuckCounter
//
//  Created by Alex on 11.12.2023.
//

import SwiftUI

struct CongratsView: View {
    var body: some View {
        ZStack(alignment: .top, content: {
            Colors._2B1011
            
            imageBGView()
            
            profileImageView()
                .padding(.top, 78)
            
            crownImageView()
                .padding(.top, 54)
            
            labelsView()
                .padding(.top, 200)
        })
    }
    
    private func imageBGView() -> some View {
        Images.congratsBG
            .resizable()
            .aspectRatio(contentMode: .fit)
        
    }
    
    private func profileImageView() -> some View {
        Images.greenState
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
    
    private func crownImageView() -> some View {
        Images.crown_2
            .frame(width: 40, height: 40)
    }
    
    private func labelsView() -> some View {
        VStack(alignment: .center, spacing: 16) {
            MediumTextView(
                style: .sfPro,
                title: "Congrat’s, you’re King of\nBad Words today!",
                size: 21,
                color: Color(red: 0.949, green: 0.949, blue: 0.949)
            )
            .multilineTextAlignment(.center)
            
            BoldTextView(
                style: .sfPro,
                title: "14,254",
                size: 19,
                color: Color(red: 0.704, green: 0.704, blue: 0.704)
            )
        }
    }
}

#Preview {
    CongratsView()
}
