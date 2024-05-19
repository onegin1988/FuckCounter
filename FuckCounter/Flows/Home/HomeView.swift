//
//  ContentView.swift
//  SwearCounter
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
    @State private var isShowPopover: Bool = false
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
                    
                    Text(resultText)
                        .padding(.bottom, 95)
                        
                })
                
                BottomSheetView(isOpen: $isOpenCongrats, maxHeight: 375) { isOpen in
                    Task {
                        if !isOpen {
                            homeViewModel.resetCounter()
                            await homeViewModel.loadLastTotal()
                            if homeViewModel.updateCountForSubscriptionAndShow() && !AppData.hasPremium {
                                withAnimation {
                                    homeViewModel.subscriptionInfo = .firstInfo
                                    homeViewModel.homeEvent = .subscription
                                    isShow = true
                                }
                            }
                        }
                    }
                } content: {
                    if isOpenCongrats {
                        CongratsView(userModel: homeViewModel.userModel,
                                     count: AppData.userLoginModel == nil ? homeViewModel.counter : homeViewModel.totalCount,
                                     subTitle: homeViewModel.isChamp ? "New Total Words Record, you’re King of Bad Words!" : "Bad words counted")
                    }
                }
            }
            .onFirstAppear {
                Task {
                    await homeViewModel.subscribeHomeObservers()
                    await homeViewModel.checkWinner()
                    await homeViewModel.loadLastTotal()
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isShowPopover = AppData.isShowTrackPopover
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
                SubscriptionView(subscriptionInfo: homeViewModel.subscriptionInfo)
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
            .onChange(of: isShowPopover, perform: { newValue in
                AppData.isShowTrackPopover = newValue
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .modifier(GradientModifiers(style: homeViewModel.level.background))
            .modifier(HomeToolbarItemsModifiers(isHideButtons: homeViewModel.isPlay, isShowPopover: $isShowPopover, onHomeEvent: { homeEvent in
                if homeEvent == .leaders && !AppData.hasPremium {
                    self.homeViewModel.subscriptionInfo = .secondInfo
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
    
    private var resultText: AttributedString {
        var attriString = AttributedString(AppData.hasPremium ? "" : homeViewModel.isPlay ? homeViewModel.level.result : "\(AppData.lastTrackingCount) free tracking for today")
        attriString.font = .custom("SFProDisplay-Medium", size: 14)
        attriString.foregroundColor = .white

        if let freeRange = attriString.range(of: "\(AppData.lastTrackingCount) free") {
            attriString[freeRange].font = .custom("SFProDisplay-Black", size: 14)
        }
        
        return attriString
    }
    
    private func preparePlayButtonView() -> some View {
        ButtonView(title: homeViewModel.isPlayState.0, image: homeViewModel.isPlayState.1, useBG: true, buttonBG: .black, textColor: .white) {
            withAnimation {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                if homeViewModel.isPlay {
                    isProcessing = true
                    speechService.stopRecording()
                    Task {
                        await homeViewModel.uploadResults()
                        isOpenCongrats = true
                        isProcessing = false
                    }
                } else {
                    if !AppData.hasPremium {
                        if AppData.lastTrackingCount <= 0 {
                            withAnimation {
                                homeViewModel.subscriptionInfo = .firstInfo
                                homeViewModel.homeEvent = .subscription
                                isShow = true
                            }
                            return
                        }
                        AppData.lastTrackingCount -= 1
                    }
                    isShowPopover = false
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
            BoldTextView(style: .sfPro, title: counterText, size: 108)
            MediumTextView(style: .sfPro, title: isWordsShow ? "Words \(AppData.selectedWordsModel.nameCorrect)" : "Bad words for today", size: 17)
        }
    }
    
    private var isWordsShow: Bool {
        if homeViewModel.isPlay || (isProcessing && !homeViewModel.isPlay) || isOpenCongrats {
            return true
        }
        return false
    }
    
    private var counterText: String {
        if isOpenCongrats {
            if AppData.userLoginModel == nil {
                return "\($homeViewModel.counter.wrappedValue)"
            }
            return "\(homeViewModel.totalCount)"
        }
        return homeViewModel.isPlay ? "\($homeViewModel.counter.wrappedValue)" : "\(homeViewModel.totalCount)"
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
