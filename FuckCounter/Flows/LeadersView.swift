//
//  LeadersView.swift
//  FuckCounter
//
//  Created by Alex on 06.12.2023.
//

import SwiftUI

struct LeadersView: View {
    
    private let navTitle: String?
    
    init(navTitle: String?) {
        self.navTitle = navTitle
    }
    
    var body: some View {
        NavigationStack {
            VStack(content: {
                Text("Placeholder")
            })
            .modifier(NavBarModifiers(title: navTitle))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .modifier(GradientModifiers(style: .green))
            .ignoresSafeArea()
        }
    }
}

#Preview {
    LeadersView(navTitle: "Leaders")
}
