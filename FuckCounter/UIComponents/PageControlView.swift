//
//  PageControlView.swift
//  FuckCounter
//
//  Created by Alex on 18.03.2024.
//

import SwiftUI

struct PageControlView: View {
    
    private let numberOfPages: Int
    @Binding private var currentPage: Int
    
    init(numberOfPages: Int, currentPage: Binding<Int>) {
        self.numberOfPages = numberOfPages
        self._currentPage = currentPage
    }
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<numberOfPages) { index in
                Circle()
                    .frame(width: 6, height: 6)
                    .foregroundColor(index == self.currentPage ? .white : .white.opacity(0.4))
            }
        }
    }
}

#Preview {
    PageControlView(numberOfPages: 3, currentPage: .constant(0))
}
