//
//  LoginView.swift
//  FuckCounter
//
//  Created by Alex on 25.01.2024.
//

import FirebaseAuth
import SwiftUI

struct LoginView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var facebookService: FacebookService
    @EnvironmentObject var firebaseService: FirebaseService
    
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
        .onReceive(facebookService.$facebookLoginModel, perform: { facebookLoginModel in
            Task {
                do {
                    guard  let model = facebookLoginModel, let user = Auth.auth().currentUser else { return }
                    try await firebaseService.appendUser(model, user)
                    dismiss()
                } catch let error {
                    facebookService.error = error.localizedDescription
                }
            }
        })
        .alertError(errorMessage: $firebaseService.error)
        .showProgress(isLoading: facebookService.isAuthProcess)
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
            if !facebookService.isAuth {
                Task {
                    await facebookService.logIn()
                    
//                    dismiss()
                }
            } else {
                Task {
                    await facebookService.logOut()
                }
            }
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
        .environmentObject(FacebookService())
}
