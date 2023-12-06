//
//  ContentView.swift
//  FuckCounter
//
//  Created by Alex on 19.11.2023.
//

import SwiftUI

struct HomeView: View {
    
    @State var homeEvent: HomeEvent?
    
    private var isPushToView: Binding<Bool> {
        Binding(get: { homeEvent != nil }, set: { _ in homeEvent = nil } )
    }
    
    var body: some View {
        NavigationStack {
            VStack(content: {
                Text("Placeholder")
            })
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .modifier(GradientModifiers(style: .green))
            .modifier(HomeToolbarItemsModifiers(onHomeEvent: { homeEvent in
                self.homeEvent = homeEvent
            }))
            .ignoresSafeArea()
        }
    }
}

#Preview {
    HomeView()
}
