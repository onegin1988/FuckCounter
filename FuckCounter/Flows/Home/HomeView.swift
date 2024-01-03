//
//  ContentView.swift
//  FuckCounter
//
//  Created by Alex on 19.11.2023.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var homeViewModel = HomeViewModel()
    
    @State private var homeEvent: HomeEvent?
    @State private var isOpenCongrats: Bool = false
    
    @EnvironmentObject var dailyService: DailyService
    @Environment(\.scenePhase) var scenePhase
    
    private var isPushToView: Binding<Bool> {
        Binding(get: { homeEvent != nil }, set: { _ in homeEvent = nil } )
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
                            homeViewModel.isPlay.toggle()
                        }
                    }
                    .frame(width: homeViewModel.isPlayState.2, height: 56)
                    .padding(.bottom, 52)
                    .padding(.top, 20)
                    
                    MediumTextView(style: .sfPro, title: homeViewModel.level.result)
                        .padding(.bottom, 95)
                })
                
                BottomSheetView(isOpen: $isOpenCongrats, maxHeight: 375) {
                    CongratsView()
                }
            }
            .navigationDestination(isPresented: isPushToView, destination: {
                switch homeEvent {
                case .settings:
                    SettingsView(navTitle: homeEvent?.title)
                case .filters:
                    FiltersView(navTitle: homeEvent?.title)
                case .leaders:
                    LeadersView(navTitle: homeEvent?.title)
                case nil:
                    EmptyView()
                }
            })
            .onFirstAppear {
                homeViewModel.checkCounter()
            }
            .onReceive(dailyService.$timeSlice, perform: { _ in
                homeViewModel.timeSlice = dailyService.timeSliceResult
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .modifier(GradientModifiers(style: homeViewModel.level.background))
            .modifier(HomeToolbarItemsModifiers(isHideButtons: homeViewModel.isPlay, onHomeEvent: { homeEvent in
                self.homeEvent = homeEvent
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

extension Double {
  func asString(style: DateComponentsFormatter.UnitsStyle) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second, .nanosecond]
    formatter.unitsStyle = style
    return formatter.string(from: self) ?? ""
  }
}
