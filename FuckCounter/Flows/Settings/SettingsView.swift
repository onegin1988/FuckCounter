//
//  SettingsView.swift
//  FuckCounter
//
//  Created by Alex on 06.12.2023.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject var settingsViewModel = SettingsViewModel()
    
    @EnvironmentObject var facebookService: FacebookService
    @EnvironmentObject var googleService: GoogleService
    
    @Environment(\.safeAreaInsets) var safeAreaInsets
    
    @State private var showDeleteAccountAlert = false
    @State private var isAuthProcess = false
    
    private let navTitle: String?
    
    var isPushToView: Binding<Bool> {
        Binding(get: { settingsViewModel.settingsEvent != nil },
                set: { _ in settingsViewModel.settingsEvent = nil } )
    }
    
    init(navTitle: String? = nil) {
        self.navTitle = navTitle
    }
    
    var body: some View {
//        NavigationStack {
            ScrollView(content: {
//                AppsListView(apps: settingsViewModel.apps)
                SettingsListView(settingsItems: settingsViewModel.settingsItems,
                                 isToggle: $settingsViewModel.isNotify) { settingsItem in
                    switch settingsItem {
                    case .invite:
                        settingsViewModel.showSheet = true
                    case .rate:
                        ReviewApp.requestReview()
                    case .createAccount:
                        if AppData.userLoginModel == nil {
                            settingsViewModel.settingsEvent = .login
                        }
                    case .deleteAccount:
                        showDeleteAccountAlert.toggle()
                    case .logout:
                        Task {
                            if AppData.userLoginModel?.providerId == "google.com" {
                                await googleService.googleSignOut()
                            } else {
                                await facebookService.logOut()
                            }
                        }
                    default:
                        break
                    }
                }
            })
            .onReceive(facebookService.$isAuth, perform: { newValue in
                settingsViewModel.updateSettingsItems(newValue)
            })
            .onReceive(googleService.$isAuth, perform: { newValue in
                settingsViewModel.updateSettingsItems(newValue)
            })
            .padding(.top, safeAreaInsets.top + 64)
            .modifier(NavBarModifiers(title: navTitle))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .modifier(GradientModifiers(style: .red,
                                        useBlackOpacity: true))
            .ignoresSafeArea()
//        }
        .onFirstAppear {
            facebookService.getFriends()
        }
        .alert("You want to delete account", isPresented: $showDeleteAccountAlert, actions: {
            Button("Cancel", role: .cancel, action: {})
            Button("Yes, delete", role: .destructive) {
                Task {
                    isAuthProcess = true
                    
                    await settingsViewModel.deleteAccount()
                    
                    if AppData.userLoginModel?.providerId == "google.com" {
                        await googleService.googleSignOut()
                    } else {
                        await facebookService.logOut()
                    }
                    
                    isAuthProcess = false
                }
            }
        }, message: {
            Text("Are you sure? All your data will be deleted forever.")
        })
        .errorSocialServices($settingsViewModel.error)
        .authProcess($isAuthProcess)
        .showProgress(isLoading: isAuthProcess)
        .alertError(errorMessage: $settingsViewModel.error)
        .navigationDestination(isPresented: isPushToView, destination: {
            switch settingsViewModel.settingsEvent {
            case .login:
                LoginView()
            case .none:
                EmptyView()
            }
        })
        .sheetShare(showSheet: $settingsViewModel.showSheet, items: ["Wow, It’s my Fuck counter result"])
    }
}

private extension SettingsView {
    
    enum SettingsError: LocalizedError {
        
        case custom(String)
        
        var errorMessage: String? {
            switch self {
            case .custom(let message): return message
            }
        }
    }
    
    // MARK: - AppsListView
    struct AppsListView: View {
        
        private let apps: [AppsModel]
        @Environment(\.openURL) var openURL
        @State private var errorMessage: String?
        
        init(apps: [AppsModel]) {
            self.apps = apps
        }
        
        var body: some View {
            Section {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(apps, id: \.id) { element in
                        AppsListRow(appsModel: element) {
                            guard let url = URL(string: element.url), let _ = try? Data(contentsOf: url) else {
                                errorMessage = SettingsError.custom("URL is not valid").errorMessage
                                return
                            }
                            openURL(url)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .alertError(errorMessage: $errorMessage)
        }
    }
    
    struct SettingsListView: View {
        
        private let settingsItems: [SettingsItem]
        @Binding var isToggle: Bool
        private let onSettingsItem: ((SettingsItem) -> Void)?
        
        init(settingsItems: [SettingsItem], 
             isToggle: Binding<Bool>,
             onSettingsItem: ((SettingsItem) -> Void)?) {
            self.settingsItems = settingsItems
            self._isToggle = isToggle
            self.onSettingsItem = onSettingsItem
        }
        
        var body: some View {
            Section {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(settingsItems, id: \.self) { element in
                        SettingsListRow(item: element, isToggle: $isToggle) {
                            onSettingsItem?(element)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

#Preview {
    SettingsView(navTitle: "Test")
}
