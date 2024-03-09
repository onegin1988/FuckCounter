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
    
    @StateObject private var customWordViewModel = CustomWordViewModel()
    
    @Environment(\.dismiss) var dismiss
        
    private let navTitle: String?
    private let wordText: String
    
    init(wordText: String, navTitle: String? = nil) {
        self.wordText = wordText
        self.navTitle = navTitle
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader(content: { geometry in
                ZStack(alignment: .bottom) {
                    setupCustomWordTextField()
                    setupCustomWordApplyButton(geometry)
                }
                .toolbarBackground(.hidden, for: .navigationBar)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, CustomWordConstants.padding)
                .modifier(NavBarModifiers(isCancel: true, title: navTitle))
                .modifier(GradientModifiers(style: .red,
                                            useBlackOpacity: true))
                .ignoresSafeArea()
                .onFirstAppear {
                    self.customWordViewModel.textInput = wordText
                }
                .onReceive(Publishers.keyboardHeight, perform: { value in
                    withAnimation {
                        customWordViewModel.keyboardHeight = value
                    }
                })
                .alertError(errorMessage: $customWordViewModel.error)
            })
        }
    }
    
    @ViewBuilder
    private func setupCustomWordTextField() -> some View {
        TextField("",
                  text: $customWordViewModel.textInput,
                  prompt:
                    Text("Enter Your Word")
            .font(FontStyle.gilroy.semibold(size: 23))
            .foregroundColor(.white.opacity(0.4))
                  
        )
        .multilineTextAlignment(.center)
        .lineLimit(1)
        .font(FontStyle.gilroy.semibold(size: 23))
        .foregroundColor(.white)
        .offset(y: -customWordViewModel.keyboardHeight/2)
    }
    
    @ViewBuilder
    private func setupCustomWordApplyButton(_ geo: GeometryProxy) -> some View {
        ButtonView(title: "Apply",
                   useBG: true,
                   buttonBG: customWordViewModel.textInput.isEmpty ? Colors._FFDD64.opacity(0.4) : Colors._FFDD64,
                   textColor: .black) {
            
            if customWordViewModel.checkingCustomWord(filtersViewModel.languageModel.languageCode) {
                filtersViewModel.customWord = customWordViewModel.textInput
                filtersViewModel.isCustom = true
                dismiss()
            }
        }
        .frame(height: CustomWordConstants.buttonHeight)
        .offset(y: geo.size.height / 2 - CustomWordConstants.padding - customWordViewModel.keyboardHeight/2)
        .allowsHitTesting(!customWordViewModel.textInput.isEmpty)
    }
}

#Preview {
    CustomWordView(wordText: "")
}
