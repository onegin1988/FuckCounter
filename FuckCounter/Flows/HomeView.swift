//
//  ContentView.swift
//  FuckCounter
//
//  Created by Alex on 19.11.2023.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack(content: {
                Text("Placeholder")
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .modifier(GradientModifiers(style: .green))
            .modifier(HomeToolbarItemsModifiers(onHomeEvent: { homeEvent in
                
            }))
            .ignoresSafeArea()
        }
    }
}

#Preview {
    HomeView()
}
