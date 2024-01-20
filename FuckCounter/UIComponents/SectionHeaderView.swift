//
//  SectionHeaderView.swift
//  FuckCounter
//
//  Created by Alex on 20.01.2024.
//

import SwiftUI

struct SectionHeaderView: View {
    
    private let title: String
    
    init(title: String) {
        self.title = title
    }
    
    var body: some View {
        HStack(content: {
            MediumTextView(style: .gilroy, 
                           title: title.uppercased(), size: 13)
            .padding(.leading, 16)
            .padding(.bottom, 8)
            
            Spacer()
        })
    }
}

#Preview {
    SectionHeaderView(title: "Test")
}
