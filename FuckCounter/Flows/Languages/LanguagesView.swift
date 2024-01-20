//
//  LanguagesView.swift
//  FuckCounter
//
//  Created by Alex on 20.01.2024.
//

import SwiftUI

struct LanguagesView: View {
    
    @Environment(\.safeAreaInsets) var safeAreaInsets
    @Environment(\.dismiss) var dismiss
    @StateObject var languagesViewModel = LanguagesViewModel()
    private let navTitle: String?
    
    init(navTitle: String? = nil) {
        self.navTitle = navTitle
    }

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    makeLanguagesListView()
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .modifier(GradientModifiers(style: .red,
                                        useBlackOpacity: true))
            .modifier(NavBarModifiers(title: navTitle))
            .ignoresSafeArea()
        }
    }
    
    private func makeLanguagesListView() -> some View {
        Section {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(languagesViewModel.list, id: \.id) { element in
                    ListItemRowView(title: element.name,
                                    isChecked: element.id == languagesViewModel.languageModel.id)
                        .onTapGesture {
                            languagesViewModel.languageModel = element
                        }
                }
            }
            .background(
                ZStack {
                    Colors._6D6D7A.opacity(0.3)
                    Color.black.opacity(0.2)
                }
            )
            .cornerRadius(24)
        } header: {
            SectionHeaderView(title: "Language".uppercased())
        }
        .padding(.horizontal, 16)
        .padding(.top, safeAreaInsets.top + 64)
    }
}

#Preview {
    LanguagesView()
}
