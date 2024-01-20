//
//  ListItemRowView.swift
//  FuckCounter
//
//  Created by Alex on 20.01.2024.
//

import SwiftUI

struct ListItemRowView: View {
    
    private let title: String
    private let isChecked: Bool
    
    init(title: String, isChecked: Bool) {
        self.title = title
        self.isChecked = isChecked
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    MediumTextView(style: .gilroy,
                                   title: title,
                                   size: 17)
                    .frame(height: 22)
                    
                    Spacer()
                    
                    checkmarkIconView(isChecked: isChecked)
                        .frame(width: 24, height: 24)
                }
                .padding(.all, 16)
                Rectangle()
                    .fill(Colors._6D6D7A.opacity(0.18))
                    .frame(height: 1)
            }
        }
    }
    
    @ViewBuilder private func checkmarkIconView(isChecked: Bool) -> some View {
        if isChecked {
            Images.checked
        } else {
            Images.unchecked
        }
    }
}

#Preview {
    ListItemRowView(title: "Test", isChecked: true)
}
