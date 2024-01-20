//
//  FiltersView.swift
//  FuckCounter
//
//  Created by Alex on 06.12.2023.
//

import SwiftUI

struct FiltersView: View {
    
    @Environment(\.safeAreaInsets) var safeAreaInsets
    @Environment(\.dismiss) var dismiss
    @StateObject var filtersViewModel = FiltersViewModel()
    private let navTitle: String?
    
    init(navTitle: String? = nil) {
        self.navTitle = navTitle
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    listView()
                }
                
                Button {
                    AppData.selectedWordsModel = filtersViewModel.wordsModel
                    dismiss()
                } label: {
                    ZStack {
                        Colors._FFDD64
                        SemiboldTextView(style: .gilroy, title: "Allow filters", size: 17, color: .black)
                    }
                    .cornerRadius(14)
                }
                .frame(height: 52)
                .padding(.top, 16)
                .padding(.horizontal, 16)
                .padding(.bottom, 37)
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .modifier(GradientModifiers(style: .red,
                                        useBlackOpacity: true))
            .modifier(NavBarModifiers(title: navTitle))
            .ignoresSafeArea()
        }
    }
    
    
    private func listView() -> some View {
        Section {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(filtersViewModel.list, id: \.id) { element in
                    ListItemRowView(title: element.name,
                                    isChecked: element.id == filtersViewModel.wordsModel.id)
                    .onTapGesture {
                        filtersViewModel.wordsModel = element
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
            SectionHeaderView(title: "Bad words")
        }
        .padding(.horizontal, 16)
        .padding(.top, safeAreaInsets.top + 64)
    }
}

#Preview {
    FiltersView(navTitle: "Test")
}
