//
//  HomeToolbarItemsModifier.swift
//  FuckCounter
//
//  Created by Alex on 19.11.2023.
//

import SwiftUI

struct HomeToolbarItemsModifiers: ViewModifier {
    
    enum HomeEvent {
        case settings, filter, cup
    }
    
    private let onHomeEvent: ((HomeEvent) -> Void)?
    
    init(onHomeEvent: ((HomeEvent) -> Void)?) {
        self.onHomeEvent = onHomeEvent
    }
    
    func body(content: Content) -> some View {
        content
            .toolbar(content: {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button(action: {
                        onHomeEvent?(.settings)
                    }, label: {
                        Images.settings
                            .frame(width: 22, height: 22)
                    })
                    Button(action: {
                        onHomeEvent?(.filter)
                    }, label: {
                        Images.filter
                            .frame(width: 22, height: 22)
                    })
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        onHomeEvent?(.cup)
                    }, label: {
                        Images.cup
                            .frame(width: 22, height: 22)
                    })
                }
            })
    }
}
