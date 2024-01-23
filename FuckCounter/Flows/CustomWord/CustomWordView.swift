//
//  CustomWordView.swift
//  FuckCounter
//
//  Created by Alex on 23.01.2024.
//

import Combine
import SwiftUI

struct CustomWordView: View {
    
    struct CustomWordConstants {
        static let buttonHeight: CGFloat = 52
        static let padding: CGFloat = 16
    }
    
    @EnvironmentObject var filtersViewModel: FiltersViewModel
    
    @Environment(\.dismiss) var dismiss
    
    @State private var keyboardHeight: CGFloat = 0
    @State private var textInput: String = ""
    
    private let navTitle: String?
    
    init(wordText: String, navTitle: String? = nil) {
        self.navTitle = navTitle
        self.textInput = wordText
    }
    
    var body: some View {
        GeometryReader(content: { geometry in
            NavigationStack {
                ZStack(alignment: .bottom) {
                    
                    setupCustomWordTextField()
                    setupCustomWordApplyButton(geometry)
                }
                .padding(.horizontal, CustomWordConstants.padding)
                .toolbarBackground(.hidden, for: .navigationBar)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .modifier(GradientModifiers(style: .red,
                                            useBlackOpacity: true))
                .modifier(NavBarModifiers(title: navTitle))
                .ignoresSafeArea()
            }
            .onReceive(Publishers.keyboardHeight, perform: { value in
                withAnimation {
                    self.keyboardHeight = value
                }
            })
        })
    }
    
    @ViewBuilder
    private func setupCustomWordTextField() -> some View {
        TextField("",
                  text: $textInput,
                  prompt:
                    Text("Enter Your Word")
            .font(FontStyle.gilroy.semibold(size: 23))
            .foregroundColor(.white.opacity(0.4))
                  
        )
        .multilineTextAlignment(.center)
        .lineLimit(1)
        .font(FontStyle.gilroy.semibold(size: 23))
        .foregroundColor(.white)
        .offset(y: -keyboardHeight/2)
    }
    
    @ViewBuilder
    private func setupCustomWordApplyButton(_ geo: GeometryProxy) -> some View {
        ButtonView(title: "Apply",
                   useBG: true,
                   buttonBG: textInput.isEmpty ? Colors._FFDD64.opacity(0.4) : Colors._FFDD64,
                   textColor: .black) {
            filtersViewModel.customWord = textInput
            dismiss()
        }
        .frame(height: CustomWordConstants.buttonHeight)
        .offset(y: geo.size.height / 2 - CustomWordConstants.padding - keyboardHeight/2)
        .allowsHitTesting(!textInput.isEmpty)
    }
}

#Preview {
    CustomWordView(wordText: "")
}
