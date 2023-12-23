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
                                        
                    ButtonView(title: homeViewModel.isPlayState.0, image: homeViewModel.isPlayState.1, useBG: true) {
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .modifier(GradientModifiers(style: homeViewModel.level.background))
            .modifier(HomeToolbarItemsModifiers(onHomeEvent: { homeEvent in
                self.homeEvent = homeEvent
            }))
            .ignoresSafeArea()
        }
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
            ProgressView(value: 20, total: 100)
                .frame(width: 150)
                .tint(.white)
                .background(.white.opacity(0.3))

            BoldTextView(style: .sfPro, title: "2h", size: 15)
        })
    }
}

#Preview {
    HomeView()
}
