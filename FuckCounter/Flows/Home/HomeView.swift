//
//  ContentView.swift
//  FuckCounter
//
//  Created by Alex on 19.11.2023.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var homeViewModel = HomeViewModel()
    
    @State private var isOpenCongrats: Bool = false
    
    @EnvironmentObject var dailyService: DailyService
    @EnvironmentObject var speechService: SpeechService
    @Environment(\.scenePhase) var scenePhase
    
    private var isPushToView: Binding<Bool> {
        Binding(get: { homeViewModel.homeEvent != nil },
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
                                        
                    ButtonView(title: homeViewModel.isPlayState.0, image: homeViewModel.isPlayState.1, useBG: true, buttonBG: .black, textColor: .white) {
                        withAnimation {
                            if homeViewModel.isPlay {
                                speechService.cancelRecording()
                                isOpenCongrats = true
                            } else {
                                speechService.recordAndRecognizeSpeech()
                            }
                        }
                    }
                    .frame(width: homeViewModel.isPlayState.2, height: 56)
                    .padding(.bottom, 52)
                    .padding(.top, 20)
                    
                    MediumTextView(style: .sfPro, title: homeViewModel.level.result)
                        .padding(.bottom, 95)
                })
                
                BottomSheetView(isOpen: $isOpenCongrats, maxHeight: 375) { isOpen in
                    if !isOpen {
                        homeViewModel.resetCounter()
                    }
                } content: {
                    if isOpenCongrats {
                        CongratsView(title: "\(homeViewModel.counter)", subTitle: "Bad words today!")
                    }
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
                case nil:
                    EmptyView()
                }
            })
            .onReceive(dailyService.$timeSlice, perform: { _ in
                homeViewModel.timeSlice = dailyService.timeSliceResult
            })
            .onReceive(speechService.$isRecording, perform: { isRecording in
                homeViewModel.isPlay = speechService.isRecording
            })
            .onReceive(speechService.$fullText, perform: { fullText in
                if let fullText = fullText {
                    homeViewModel.counter = fullText.lowercased().ranges(of: AppData.selectedWordsModel.name.lowercased()).count
                    homeViewModel.checkLevel()
                }
//                if isSameWord {
//                    homeViewModel.counter += 1
//                    homeViewModel.checkLevel()
//                }
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .modifier(GradientModifiers(style: homeViewModel.level.background))
            .modifier(HomeToolbarItemsModifiers(isHideButtons: homeViewModel.isPlay, onHomeEvent: { homeEvent in
                self.homeViewModel.homeEvent = homeEvent
            }))
            .ignoresSafeArea()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                homeViewModel.updateCountForAppPush()
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
    
    private func prepareCounterWordsView() -> some View {
        VStack(alignment: .center, spacing: -10) {
            BoldTextView(style: .sfPro, title: "\($homeViewModel.counter.wrappedValue)", size: 108)
            MediumTextView(style: .sfPro, title: "Bad words today", size: 17)
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
}

#Preview {
    HomeView()
}
