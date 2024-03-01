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
    
    @State private var isShowHome: Bool = false
    @State private var errorMessage: String?
    
    @StateObject var speechService = SpeechService()
    @StateObject var dailyService = DailyService()
    @StateObject var facebookService = FacebookService()
    @StateObject var appleService = AppleService()
    @StateObject var googleService = GoogleService()
    
    @StateObject var loginViewModel = LoginViewModel()
    
    @Environment(\.scenePhase) var scenePhase
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            if isShowHome {
                HomeView()
                    .environmentObject(dailyService)
                    .environmentObject(speechService)
                    .environmentObject(facebookService)
                    .environmentObject(appleService)
                    .environmentObject(googleService)
                    .environmentObject(loginViewModel)
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
                        setupSettings()
                    }
                    .environmentObject(speechService)
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
                dailyService.updateTimeInterval()
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
    
    private func requestSpeechAuthorization() {
        Task {
            let status = await speechService.requestSpeechAuthorization()
            
            await MainActor.run {
                switch status {
                case .notDetermined, .restricted:
                    isShowHome = false
                case .denied:
                    errorMessage = SpeechServiceError.speechDeniedError.errorDescription
                    isShowHome = false
                case .authorized:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isShowHome = true
                    }
                @unknown default:
                    fatalError()
                }
            }
        }
    }
    
    
}
