//
//  ItemTapModifiers.swift
//  FuckCounter
//
//  Created by Alex on 22.02.2024.
//

import SwiftUI

typealias ActionItemTap = (() -> Void)

struct ItemTapModifiers: ViewModifier {
    
    private let action: ActionItemTap
    
    init(action: @escaping ActionItemTap) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content
            .overlay {
                Color.black
                    .opacity(0.01)
                    .onTapGesture {
                        withAnimation {
                            action()
                        }
                    }
            }
    }
}

extension View {
    func itemTap(action: @escaping ActionItemTap) -> some View {
        modifier(ItemTapModifiers(action: action))
    }
}
