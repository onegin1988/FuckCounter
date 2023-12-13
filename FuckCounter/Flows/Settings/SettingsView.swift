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
                SettingsListView(isToggle: $settingsViewModel.isNotify) { settingsItem in
                    switch settingsItem {
                    case .invite:
                        settingsViewModel.showSheet = true
                    default:
                        break
                    }
                }
                .padding(.top, 48)
            })
            .padding(.top, safeAreaInsets.top + 64)
            .modifier(NavBarModifiers(title: navTitle))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .modifier(GradientModifiers(style: .green))
            .ignoresSafeArea()
        }
        .sheetShare(showSheet: $settingsViewModel.showSheet, items: ["Wow, It’s my Fuck counter result"])
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
        private let onSettingsItem: ((SettingsItem) -> Void)?
        
        init(isToggle: Binding<Bool>, onSettingsItem: ((SettingsItem) -> Void)?) {
            self._isToggle = isToggle
            self.onSettingsItem = onSettingsItem
        }
        
        var body: some View {
            Section {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(SettingsItem.allCases, id: \.self) { element in
                        SettingsListRow(item: element, isToggle: $isToggle) {
                            onSettingsItem?(element)
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
