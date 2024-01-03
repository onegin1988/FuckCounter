//
//  FuckCounterApp.swift
//  FuckCounter
//
//  Created by Alex on 19.11.2023.
//

import AVFAudio
import SwiftUI

@main
struct FuckCounterApp: App {
    
    @State private var isShowHome: Bool = false
    @State private var errorMessage: String?
    @StateObject var speechService = SpeechService()
    @StateObject var dailyService = DailyService()
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            if isShowHome {
                HomeView()
                    .environmentObject(dailyService)
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
            } else if newPhase == .inactive {
                dailyService.updateTimeInterval()
            }
        }
    }
    
    private func setupSettings() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .spokenAudio, options: .duckOthers)
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
