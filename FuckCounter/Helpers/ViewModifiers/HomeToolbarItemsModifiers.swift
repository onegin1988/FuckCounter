//
//  HomeToolbarItemsModifier.swift
//  SwearCounter
//
//  Created by Alex on 19.11.2023.
//

import SwiftUI

struct HomeToolbarItemsModifiers: ViewModifier {
        
    private let isHideButtons: Bool
    private let onHomeEvent: ((HomeEvent) -> Void)?
    
    @State private var isShowPopover: Bool = false
    
    init(isHideButtons: Bool, onHomeEvent: ((HomeEvent) -> Void)?) {
        self.isHideButtons = isHideButtons
        self.onHomeEvent = onHomeEvent
    }
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    isShowPopover = AppData.isShowTrackPopover
                }
            }
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
                        .onChange(of: isShowPopover, perform: { newValue in
                            AppData.isShowTrackPopover = newValue
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
