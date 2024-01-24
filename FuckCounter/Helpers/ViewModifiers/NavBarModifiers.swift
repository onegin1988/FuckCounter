//
//  NavBarModifiers.swift
//  FuckCounter
//
//  Created by Alex on 06.12.2023.
//

import SwiftUI

struct NavBarModifiers: ViewModifier {
    
    let title: String?
    @Environment(\.dismiss) var dismiss
    
    init(title: String? = nil) {
        self.title = title
    }
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Images.chevronLeft
                            .frame(width: 22, height: 22)
                    })
                }
                
                ToolbarItem(placement: .principal) {
                    if let title = title {
                        SemiboldTextView(style: .gilroy, title: title, size: 17)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
    }
}
