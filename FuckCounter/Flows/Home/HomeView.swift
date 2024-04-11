//
//  ContentView.swift
//  FuckCounter
//
//  Created by Alex on 19.11.2023.
//

import AudioToolbox
import SwiftUI
import AVFAudio

struct HomeView: View {
    
    @StateObject var homeViewModel = HomeViewModel()
    
    @State private var isOpenCongrats: Bool = false
    @State private var isProcessing: Bool = false
    @State private var isShow = false
    
    @EnvironmentObject var dailyService: DailyService
    @EnvironmentObject var speechService: SpeechService
    @Environment(\.scenePhase) var scenePhase
    
    private var isPushToView: Binding<Bool> {
        Binding(get: { homeViewModel.homeEvent != nil && homeViewModel.homeEvent != .subscription },
                set: { _ in homeViewModel.homeEvent = nil } )
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(content: {
                    Spacer()
                    Spacer()
                    prepareCounterWordsView()
                    
                    prepareStatusImageView()
                        .padding(.top, 30)
                    
                    Spacer()
                    
                    prepareProgressView()
                                   
                    preparePlayButtonView()
                    
                    MediumTextView(style: .sfPro, title: homeViewModel.level.result)
                        .padding(.bottom, 95)
                })
                
                BottomSheetView(isOpen: $isOpenCongrats, maxHeight: 375) { isOpen in
                    if !isOpen {
                        homeViewModel.resetCounter()
                    }
                } content: {
                    if isOpenCongrats {
                        CongratsView(userModel: homeViewModel.userModel,
                                     count: AppData.userLoginModel == nil ? homeViewModel.counter : homeViewModel.totalCount,
                                     subTitle: homeViewModel.isChamp ? "New Total Words Record, you’re King of Bad Words!" : "Bad words for today")
                    }
                }
            }
            .onFirstAppear {
                Task {
                    await homeViewModel.subscribeHomeObservers()
                    await homeViewModel.checkWinner()
                }
            }
            .navigationDestination(isPresented: isPushToView, destination: {
                switch homeViewModel.homeEvent {
                case .settings:
                    SettingsView(navTitle: homeViewModel.homeEvent?.title)
                case .filters:
                    FiltersView(navTitle: homeViewModel.homeEvent?.title)
                        .environmentObject(speechService)
                case .leaders:
                    LeadersView(navTitle: homeViewModel.homeEvent?.title)
                default:
                    EmptyView()
                }
            })
            .fullScreenCover(isPresented: $isShow) {
                SubscriptionView(subscriptionInfo: .secondInfo)
            }
            .onReceive(dailyService.$timeSlice, perform: { _ in
                homeViewModel.timeSlice = dailyService.timeSliceResult
            })
            .onReceive(speechService.$speechRecognitionStatus, perform: { status in
                switch status {
                case .recording:
                    homeViewModel.isPlay = true
                    dailyService.state = .start
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.isProcessing = false
                    }
                case .stopped:
                    homeViewModel.isPlay = false
                    dailyService.state = .stop
                    
                default:
                    break
                }
            })
            .onReceive(dailyService.$state, perform: { _ in
                dailyService.calculateDates()
            })
            .onReceive(speechService.$fullText, perform: { fullText in
                if let fullText = fullText {
                    homeViewModel.calculateWordProcess(fullText: fullText)
                }
            })
            .onReceive(NotificationCenter.default.publisher(for: AVAudioSession.interruptionNotification)) { notification in
                handleInterruption(notification: notification)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .modifier(GradientModifiers(style: homeViewModel.level.background))
            .modifier(HomeToolbarItemsModifiers(isHideButtons: homeViewModel.isPlay, onHomeEvent: { homeEvent in
                if homeEvent == .leaders && !AppData.hasPremium {
                    self.homeViewModel.homeEvent = .subscription
                    isShow = true
                } else {
                    self.homeViewModel.homeEvent = homeEvent
                }
            }))
            .ignoresSafeArea()
        }
        .showProgress(isLoading: isProcessing)
        .alertError(errorMessage: $speechService.error)
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
//                homeViewModel.updateCountForAppPush()
            }
        }
        .overlay(content: {
            if homeViewModel.isShowAppPush {
                AppHardPushView { event in
                    switch event {
                    case .dismiss:
                        homeViewModel.resetCountForAppPush()
                    }
                }
            }
        })
    }
    
    private func preparePlayButtonView() -> some View {
        ButtonView(title: homeViewModel.isPlayState.0, image: homeViewModel.isPlayState.1, useBG: true, buttonBG: .black, textColor: .white) {
            withAnimation {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                if homeViewModel.isPlay {
                    isProcessing = true
                    speechService.stopRecording()
                    Task {
                        if AppData.userLoginModel != nil {
                            await homeViewModel.uploadResults()
                        }
                        
                        isOpenCongrats = true
                        isProcessing = false
                    }
                } else {
                    isProcessing = true
                    speechService.startRecording()
                }
            }
        }
        .frame(width: homeViewModel.isPlayState.2, height: 56)
        .padding(.bottom, 52)
        .padding(.top, 20)
    }
    
    private func prepareCounterWordsView() -> some View {
        VStack(alignment: .center, spacing: -10) {
            BoldTextView(style: .sfPro, title: "\($homeViewModel.counter.wrappedValue)", size: 108)
            MediumTextView(style: .sfPro, title: "Bad words for today", size: 17)
        }
    }
    
    private func prepareStatusImageView() -> some View {
        homeViewModel.level.icon
            .frame(width: 32, height: 41)
    }
    
    private func prepareProgressView() -> some View {
        VStack(alignment: .center, spacing: 8, content: {
            ProgressView(value: Float(dailyService.timeSlice), total: Float(dailyService.totalSlice))
                .frame(width: 150)
                .tint(.white)
                .background(.white.opacity(0.3))

            BoldTextView(style: .sfPro, title: homeViewModel.timeSlice, size: 15)
        })
    }
    
    private func handleInterruption(notification: Notification) {
        guard 
            let value = (notification.userInfo?[AVAudioSessionInterruptionTypeKey] as? NSNumber)?.uintValue,
            let interruptionType =  AVAudioSession.InterruptionType(rawValue: value) 
        else {
            print("notification.userInfo?[AVAudioSessionInterruptionTypeKey]", notification.userInfo?[AVAudioSessionInterruptionTypeKey] as Any)
            return
        }
        
        switch interruptionType {
        case .began:
            guard homeViewModel.isPlay else {
                return
            }
            
            speechService.pauseRecording()
        default :
            guard homeViewModel.isPlay else {
                return
            }
            if let optionValue = (notification.userInfo?[AVAudioSessionInterruptionOptionKey] as? NSNumber)?.uintValue, AVAudioSession.InterruptionOptions(rawValue: optionValue) == .shouldResume {
                speechService.resumeRecording()
            }
        }
    }
}

#Preview {
    HomeView()
}
