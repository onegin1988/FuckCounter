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
    @EnvironmentObject var appleService: AppleService
    @EnvironmentObject var googleService: GoogleService
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    @State private var isAuthProcess = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    setupLogoImageView()
                    
                    setupTitleView()
                        .padding(EdgeInsets(top: 8, leading: 0, bottom: 12, trailing: 0))
                    setupDescriptionView()
                    
                    setupSocialButtons()
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
        .authProcess($isAuthProcess)
        .errorSocialServices($loginViewModel.error)
        .userSocialModelModifiers(modelHandler: { userLoginModel in
            Task {
                if AppData.appleUserId.isEmpty {
                    await appendUser(userLoginModel)
                }
            }
        })
        .onReceive(appleService.$isFinished, perform: { isFinished in
            if isFinished {
                Task {
                    if let userLoginModel = appleService.userLoginModel {
                        await appendUser(userLoginModel)
                        dismiss()
                    } else {
                        guard let user = Auth.auth().currentUser else { return }
                        await loginViewModel.getAndAppendAppleUser(user)
                        dismiss()
                    }
                }
            }
        })
        .alertError(errorMessage: $loginViewModel.error)
        .showProgress(isLoading: isAuthProcess)
    }
    
    private func appendUser(_ loginModel: UserLoginModel?) async {
        guard let user = Auth.auth().currentUser, let model = loginModel else { return }
        await loginViewModel.appendUser(model, user)
        dismiss()
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
    private func setupSocialButtons() -> some View {
        VStack(spacing: 16) {
            setupSocailButton(icon: Images.apple, title: "apple", bgColor: Colors._141414) {
                Task {
                    await appleService.startSignInWithAppleFlow()
                }
            }
            setupSocailButton(icon: Images.google, title: "google", bgColor: Colors._4484E9) {
                Task {
                    await googleService.googleSignIn()
                }
            }
//            setupSocailButton(icon: Images.facebookWhite, title: "facebook", bgColor: Colors._0766FF) {
//                if !facebookService.isAuth {
//                    Task {
//                        await facebookService.logIn()
//                    }
//                } else {
//                    Task {
//                        await facebookService.logOut()
//                    }
//                }
//            }
        }
    }
    
    private func setupSocailButton(icon: Image, title: String, bgColor: Color, action: @escaping (() -> Void)) -> some View {
        Button {
            action()
        } label: {
            ZStack {
                HStack(spacing: 8) {
                    icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    
                    MediumTextView(style: .lato,
                                   title: "login with \(title)".uppercased(),
                                   size: 14)
                    .kerning(1)
                }
                .padding(.horizontal, 32)
            }
            .frame(width: 312, height: 56)
            .background {
                Capsule()
                    .fill(bgColor)
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(FacebookService())
}
