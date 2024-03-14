//
//  ListItemArrowView.swift
//  FuckCounter
//
//  Created by Alex on 21.01.2024.
//

import SwiftUI

struct ListItemArrowView: View {
    
    private let title: String
    private let useLeftCheckmark: Bool
    private let selectCheckmark: Bool
    private let selectRowHandler: (() -> Void)?
    
    init(title: String, 
         useLeftCheckmark: Bool = false,
         selectCheckmark: Bool = false,
         selectRowHandler: (() -> Void)? = nil) {
        self.title = title
        self.useLeftCheckmark = useLeftCheckmark
        self.selectCheckmark = selectCheckmark
        self.selectRowHandler = selectRowHandler
    }

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    if useLeftCheckmark {
                        CheckMarkIconView(isChecked: selectCheckmark)
                            .frame(width: 24, height: 24)
                    }
                    
                    MediumTextView(style: .gilroy,
                                   title: title,
                                   size: 17,
                                   color: selectCheckmark ? Colors._FFDD64 : .white)
                    .frame(height: 22)
                    
                    Spacer()
                    
                    Images.chevronRight
                        .frame(width: 32, height: 32)
                        .itemTap {
                            selectRowHandler?()
                        }
                }
                .padding(.all, 16)
                Rectangle()
                    .fill(Colors._6D6D7A.opacity(0.18))
                    .frame(height: 1)
            }
        }
    }
}

#Preview {
    ListItemArrowView(title: "Test")
}
