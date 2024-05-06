//
//  HomeToolbarItemsModifier.swift
//  SwearCounter
//
//  Created by Alex on 19.11.2023.
//

import SwiftUI

struct HomeToolbarItemsModifiers: ViewModifier {
        
    private let isHideButtons: Bool
    @Binding private var isShowPopover: Bool
    private let onHomeEvent: ((HomeEvent) -> Void)?
    
    init(isHideButtons: Bool, isShowPopover: Binding<Bool>, onHomeEvent: ((HomeEvent) -> Void)?) {
        self.isHideButtons = isHideButtons
        self._isShowPopover = isShowPopover
        self.onHomeEvent = onHomeEvent
    }
    
    func body(content: Content) -> some View {
        content
            .toolbar(content: {
                if !isHideButtons {
                    ToolbarItemGroup(placement: .topBarLeading) {
                        Button(action: {
                            onHomeEvent?(.settings)
                        }, label: {
                            Images.settings
                                .frame(width: 22, height: 22)
                        })
                        Button(action: {
                            isShowPopover = false
                            onHomeEvent?(.filters)
                        }, label: {
                            Images.filter
                                .frame(width: 22, height: 22)
                        })
                        .alwaysPopover(isPresented: $isShowPopover, content: {
                            MediumTextView(style: .gilroy, title: "Select your tracking word", size: 14, color: Colors._0A0A0A)
                                .padding()
                        })
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        onHomeEvent?(.leaders)
                    }, label: {
                        Images.cup
                            .frame(width: 22, height: 22)
                    })
                }
            })
    }
}
