//
//  LanguagesView.swift
//  FuckCounter
//
//  Created by Alex on 20.01.2024.
//

import SwiftUI

struct LanguagesView: View {
    
    struct LanguagesConstants {
        static let listItemHeight: CGFloat = 64
        static let buttonHeight: CGFloat = 52
        static let padding: CGFloat = 16
    }
    
    @Environment(\.safeAreaInsets) var safeAreaInsets
    @Environment(\.dismiss) var dismiss
    
    @StateObject var languagesViewModel = LanguagesViewModel()
    
    @EnvironmentObject var filtersViewModel: FiltersViewModel
    
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
                
                ButtonView(title: "Save changes", useBG: true, buttonBG: Colors._FFDD64, textColor: .black) {
                    if filtersViewModel.languageModel.languageCode != languagesViewModel.languageModel.languageCode {
                        filtersViewModel.customWord = ""
                        if let model = filtersViewModel.list.first {
                            filtersViewModel.wordsModel = model
                        }
                    }
                    filtersViewModel.languageModel = languagesViewModel.languageModel
                    filtersViewModel.customWord = ""
                    filtersViewModel.isCustom = false
                    dismiss()
                }
                .frame(height: LanguagesConstants.buttonHeight)
                .padding(
                    EdgeInsets(
                        top: LanguagesConstants.padding,
                        leading: LanguagesConstants.padding,
                        bottom: 37,
                        trailing: LanguagesConstants.padding)
                )
            }
            .onFirstAppear {
                languagesViewModel.languageModel = filtersViewModel.languageModel
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .modifier(NavBarModifiers(isCancel: true, title: navTitle))
            .modifier(GradientModifiers(style: .red,
                                        useBlackOpacity: true))
            .ignoresSafeArea()
        }
    }
    
    private func makeLanguagesListView() -> some View {
        LazyVStack(spacing: 0) {
            Section {
                VStack {
                    ForEach(Array(languagesViewModel.list.enumerated()), id: \.offset) { index, element in
                        ListItemCheckView(title: element.name,
                                          isChecked: element.id == languagesViewModel.languageModel.id)
                        .frame(height: LanguagesConstants.listItemHeight)
                        .padding(.top, index == 0 ? 10 : 0)
                        .itemTap {
                            languagesViewModel.languageModel = element
                        }
                    }
                }
                .background(
                    Color.black.opacity(0.2)
                )
                .cornerRadius(24)
            } header: {
                SectionHeaderView(title: "Language".uppercased())
                    .frame(height: LanguagesConstants.padding + 2)
                    .padding(.bottom, 8)
            }
        }
        .padding(.horizontal, LanguagesConstants.padding)
        .padding(.top, safeAreaInsets.top + LanguagesConstants.listItemHeight)
    }
}

#Preview {
    LanguagesView()
}
