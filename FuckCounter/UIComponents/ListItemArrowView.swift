//
//  ListItemArrowView.swift
//  FuckCounter
//
//  Created by Alex on 21.01.2024.
//

import SwiftUI

struct ListItemArrowView: View {
    
    private let title: String
    
    init(title: String) {
        self.title = title
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
                    
                    Images.chevronRight
                        .frame(width: 24, height: 24)
                }
                .padding(.all, 16)
                Rectangle()
                    .fill(Colors._6D6D7A.opacity(0.18))
                    .frame(height: 1)
            }
        }
    }
}

//#Preview {
//    ListItemArrowView()
//}
