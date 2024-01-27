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
        NavigationStack {
            ZStack {
                VStack {
                    setupLogoImageView()
                    setupTitleView()
                        .padding(EdgeInsets(top: 8, leading: 0, bottom: 12, trailing: 0))
                    setupDescriptionView()
                    setupFacebookButton()
                        .padding(.top, 56)
                }
                .offset(y: 56)
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
        Images.loginLogo
            .resizable()
            .scaledToFit()
            .frame(width: 80, height: 80)
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
    
    @ViewBuilder
    private func setupFacebookButton() -> some View {
        Button {
            
        } label: {
            ZStack {
                HStack(spacing: 8) {
                    Images.facebookWhite
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    
                    MediumTextView(style: .sfPro,
                                   title: "Sign In with facebook".uppercased(),
                                   size: 13)
                    .kerning(1)
                }
                .padding(.horizontal, 32)
            }
            .frame(width: 312, height: 56)
            .background {
                Capsule()
                    .fill(Colors._0766FF)
            }
        }
    }
}

#Preview {
    LoginView()
}
