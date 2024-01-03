//
//  AppHardPushView.swift
//  FuckCounter
//
//  Created by Alex on 19.12.2023.
//

import SwiftUI

enum AppHardPushEvent {
    case dismiss
}

struct AppHardPushView: View {
    
    private let event: ((AppHardPushEvent) -> Void)?
    
    init(event: ((AppHardPushEvent) -> Void)?) {
        self.event = event
    }
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.4)
            
            ContainerAppHardPushView(event: event)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.white)
                )
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
    }
}

extension AppHardPushView {
    
    struct ContainerAppHardPushView: View {
        
        private let event: ((AppHardPushEvent) -> Void)?
        
        init(event: ((AppHardPushEvent) -> Void)?) {
            self.event = event
        }
        
        var body: some View {
            ZStack {
                VStack {
                    topHorizontalContainer()
                    descriptionAppView()
                    ButtonView(title: "Get App") {
                        event?(.dismiss)
                    }
                        .frame(height: 52)
                        .padding(.top, 32)
                    ButtonView(title: "Later", useBG: false) {
                        event?(.dismiss)
                    }
                        .frame(height: 52)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
        }
        
        private func topHorizontalContainer() -> some View {
            HStack(alignment: .center, spacing: 23) {
                iconAppView()
                    .frame(width: 68, height: 68)
                    .cornerRadius(16)
                
                VStack(alignment: .leading, spacing: 4, content: {
                    SemiboldTextView(style: .sfPro, title: "Sleeplover", size: 24, color: .black)
                    SemiboldTextView(style: .sfPro, title: "Meditation", color: .black.opacity(0.4))
                })
                
                Spacer()
            }
        }
        
        @ViewBuilder func iconAppView() -> some View {
            Images.sleeploverIcon
        }
        
        @ViewBuilder func descriptionAppView() -> some View {
            SemiboldTextView(style: .sfPro, title: "Reduse stress, fall asleep fast and find your perfect meditation.\nEverything in one app. Try it now", color: .black.opacity(0.4))
                .lineSpacing(4)
        }
    }
}

#Preview {
    AppHardPushView { _ in
        
    }
}
