//
//  FiltersView.swift
//  FuckCounter
//
//  Created by Alex on 06.12.2023.
//

import SwiftUI

struct FiltersView: View {
    
    @Environment(\.safeAreaInsets) var safeAreaInsets
    @StateObject var filtersViewModel = FiltersViewModel()
    private let navTitle: String?
    
    init(navTitle: String?) {
        self.navTitle = navTitle
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0, content: {
                List {
                    Section("Bad words".uppercased()) {
                        ForEach(filtersViewModel.list, id: \.id) { element in
                            MediumTextView(style: .gilroy, title: element.name, size: 17)
                                .listRowBackground(Colors._6D6D7A.opacity(0.3))
                        }
                    }
                    .listRowSeparatorTint(.red)
                    .font(Font.custom("Gilroy-Medium", size: 13))
                    .foregroundStyle(.white)
                    .padding(.top, 24)
                    .padding(.bottom, 8)
                }
                .padding(.top, safeAreaInsets.top + 20)
                
                .scrollContentBackground(.hidden)
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .modifier(GradientModifiers(style: .green))
            .modifier(NavBarModifiers(title: navTitle))
            .ignoresSafeArea()
        }
    }
}

#Preview {
    FiltersView(navTitle: "Test")
}
