//
//  SettingsView.swift
//  FuckCounter
//
//  Created by Alex on 06.12.2023.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject var settingsViewModel = SettingsViewModel()
    @Environment(\.safeAreaInsets) var safeAreaInsets
    private let navTitle: String?
    
    init(navTitle: String?) {
        self.navTitle = navTitle
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(content: {
                AppsListView(apps: settingsViewModel.apps)
                SettingsListView(isToggle: $settingsViewModel.isNotify)
                    .padding(.top, 48)
            })
            .padding(.top, safeAreaInsets.top + 64)
            .modifier(NavBarModifiers(title: navTitle))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .modifier(GradientModifiers(style: .green))
            .ignoresSafeArea()
        }
    }
}

private extension SettingsView {
    
    // MARK: - AppsListView
    struct AppsListView: View {
        
        private let apps: [AppsModel]
        
        init(apps: [AppsModel]) {
            self.apps = apps
        }
        
        var body: some View {
            Section {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(apps, id: \.id) { element in
                        AppsListRow(appsModel: element) {
                            
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    struct SettingsListView: View {
        
        @Binding var isToggle: Bool
        
        var body: some View {
            Section {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(SettingsItem.allCases, id: \.self) { element in
                        SettingsListRow(item: element, isToggle: $isToggle) {
                            
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

#Preview {
    SettingsView(navTitle: "Test")
}
