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
    
    init(navTitle: String?) {
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
            .modifier(GradientModifiers(style: .green))
            .modifier(NavBarModifiers(title: navTitle))
            .ignoresSafeArea()
        }
    }
    
    
    private func listView() -> some View {
        Section {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(filtersViewModel.list, id: \.id) { element in
                    filterRow(element)
                        .onTapGesture {
                            filtersViewModel.wordsModel = element
                        }
                }
            }
            .background(Colors._6D6D7A.opacity(0.3))
            .cornerRadius(24)
        } header: {
            HStack(content: {
                MediumTextView(style: .gilroy, title: "Bad words".uppercased(), size: 13)
                    .padding(.leading, 16)
                    .padding(.bottom, 8)
                
                Spacer()
            })
        }
        .padding(.horizontal, 16)
        .padding(.top, safeAreaInsets.top + 64)
    }
    
    private func filterRow(_ model: WordsModel) -> some View {
        ZStack {
            VStack {
                HStack {
                    MediumTextView(style: .gilroy, title: model.name, size: 17)
                        .frame(height: 22)
                    
                    Spacer()
                    
                    checkmarkIconView(model)
                        .frame(width: 24, height: 24)
                }
                .padding(.all, 16)
                Rectangle()
                    .fill(Colors._6D6D7A.opacity(0.18))
                    .frame(height: 1)
            }
        }
    }
    
    @ViewBuilder private func checkmarkIconView(_ model: WordsModel) -> some View {
        if model.id == filtersViewModel.wordsModel.id {
            Images.checked
        } else {
            Images.unchecked
        }
    }
}

#Preview {
    FiltersView(navTitle: "Test")
}
