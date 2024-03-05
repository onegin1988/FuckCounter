//
//  SplashView.swift
//  FuckCounter
//
//  Created by Alex on 19.11.2023.
//

import SwiftUI

struct SplashView: View {
    
    @EnvironmentObject var speechService: SpeechService
    
    var body: some View {
        VStack {
            Images.logo
                .resizable()
                .frame(width: 64, height: 64)
                .aspectRatio(contentMode: .fill)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .modifier(GradientModifiers(style: .green))
        .ignoresSafeArea(.all)
    }
}

#Preview {
    SplashView()
}
