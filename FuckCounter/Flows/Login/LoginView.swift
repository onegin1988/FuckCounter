//
//  LoginView.swift
//  FuckCounter
//
//  Created by Alex on 25.01.2024.
//

import SwiftUI

struct LoginView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { geo in
            NavigationStack {
                VStack(alignment: .center) {
                    setupLogoImageView()
                    setupTitleView()
                        .padding(EdgeInsets(top: 8, leading: 0, bottom: 12, trailing: 0))
                    setupDescriptionView()
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .modifier(GradientModifiers(style: .green))
            .modifier(NavBarModifiers())
            .ignoresSafeArea()
        }
    }
    
    @ViewBuilder
    private func setupLogoImageView() -> some View {
        Images.redState
            .resizable()
            .scaledToFit()
            .frame(width: 56, height: 56)
    }
    
    @ViewBuilder
    private func setupTitleView() -> some View {
        Text("Fuck Counter")
            .font(Font.custom("SeymourOne", size: 27))
            .fontWeight(.regular)
            .foregroundColor(.white)
    }
    
    @ViewBuilder
    private func setupDescriptionView() -> some View {
        MediumTextView(style: .sfPro,
                       title: "Sign Up And Share Your Result\nWith Friends",
                       size: 15,
                       color: .white)
            .multilineTextAlignment(.center)
    }
}

#Preview {
    LoginView()
}
