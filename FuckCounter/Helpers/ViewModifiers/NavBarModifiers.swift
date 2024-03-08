//
//  NavBarModifiers.swift
//  FuckCounter
//
//  Created by Alex on 06.12.2023.
//

import SwiftUI

struct NavBarModifiers: ViewModifier {
    
    let isCancel: Bool
    let title: String?
    let rightTitle: (String, () -> Void)?
    @Environment(\.dismiss) var dismiss
    
    init(isCancel: Bool = false, title: String? = nil, rightTitle: (String, () -> Void)? = nil) {
        self.isCancel = isCancel
        self.title = title
        self.rightTitle = rightTitle
    }
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        lectButtonIcon()
                            .frame(width: 22, height: 22)
                    })
                }
                
                ToolbarItem(placement: .principal) {
                    if let title = title {
                        SemiboldTextView(style: .gilroy, title: title, size: 17)
                    }
                }
                
                if let rightTitle = rightTitle {
                    ToolbarItem(placement: .topBarTrailing) {
                        SemiboldTextView(style: .gilroy, title: rightTitle.0, size: 17)
                            .itemTap {
                                rightTitle.1()
                            }
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
    }
    
    private func lectButtonIcon() -> some View {
        if isCancel {
            Images.cancelIcon
        } else {
            Images.chevronLeft
        }
    }
}
