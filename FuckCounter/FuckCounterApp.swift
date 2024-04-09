//
//  FuckCounterApp.swift
//  FuckCounter
//
//  Created by Alex on 19.11.2023.
//

import AVFAudio
import SwiftUI
import FirebaseCore
import FacebookCore

// MARK: - AppDelegate
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        
        if AppData.uuidDevice.isEmpty {
            AppData.uuidDevice = UUID().uuidString
        }
        
        ApplicationDelegate.shared.application(application,
                                               didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(app, 
                                               open: url,
                                               sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                               annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
}

// MARK: - Main

@main
struct FuckCounterApp: App {
    
    @State private var isStartApp = (false, false) // (isShowHome, isOlder)
    @State private var errorMessage: String?
    @State private var showAlert = false
    
    @StateObject var speechService = SpeechService()
    @StateObject var dailyService = DailyService()
    @StateObject var facebookService = FacebookService()
    @StateObject var appleService = AppleService()
    @StateObject var googleService = GoogleService()
    @StateObject var purchaseService = PurchaseService()
    
    @StateObject var loginViewModel = LoginViewModel()
    
    @Environment(\.scenePhase) var scenePhase
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            if isStartApp.0 && isStartApp.1 {
                HomeView()
                    .environmentObject(dailyService)
                    .environmentObject(speechService)
                    .environmentObject(facebookService)
                    .environmentObject(appleService)
                    .environmentObject(googleService)
                    .environmentObject(loginViewModel)
                    .environmentObject(purchaseService)
                    .onOpenURL { url in
                        ApplicationDelegate.shared.application(UIApplication.shared,
                                                               open: url,
                                                               sourceApplication: nil, 
                                                               annotation: UIApplication.OpenURLOptionsKey.annotation)
                    }
            } else {
                SplashView()
                    .alertError(errorMessage: $errorMessage, useButtons: ("Settings", {
                        showSettings()
                    }))
                    .onFirstAppear {
                        isStartApp.1 = AppData.isOlder
                        setupSettings()
                    }
                    .customAlert(showAlert: $showAlert,
                                 title: "Are you older than > 18",
                                 message: "To use app you need to be older than 18",
                                 cancelButton: ("I'm younger", false, {
                        isStartApp.1 = false
                    }),
                                 acceptButton: ("Yes, I am", false, {
                        AppData.isOlder = true
                        isStartApp.1 = AppData.isOlder
                    }))
                    .task {
                        loadProducts()
                    }
                    .environmentObject(speechService)
                    .environmentObject(purchaseService)
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                requestSpeechAuthorization()
                dailyService.calculateDates()
                
                Task {
//                    await facebookService.checkIsNeedRefreshToken()
                    await appleService.checkIsNeedRefresh()
                    await googleService.checkIsNeedRefreshToken()
                }
            } else if newPhase == .inactive {
//                dailyService.updateTimeInterval()
            }
        }
    }

    private func loadProducts() {
        Task {
            do {
                try await purchaseService.loadProducts()
                debugPrint(purchaseService.products)
                
                await purchaseService.updatePurchasedProducts()
            } catch let error {
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    private func setupSettings() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            
            try audioSession.setCategory(.playAndRecord, mode: .spokenAudio, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch let error {
            errorMessage = error.localizedDescription
        }
    }
    
    private func showSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
    
    private func showOlderAlert() {
        if !isStartApp.1 {
            showAlert = true
        }
    }
    
    private func requestSpeechAuthorization() {
        speechService.requestSpeechAuthorization { status in
            switch status {
            case .notDetermined, .restricted:
                isStartApp.0 = false
            case .denied:
                errorMessage = "You have disabled access to speech recognition."
                isStartApp.0 = false
            case .authorized:
                isStartApp.0 = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.showOlderAlert()
                }
            @unknown default:
                fatalError()
            }
        }
    }
}
