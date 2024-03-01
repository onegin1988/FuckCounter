//
//  BottomSheetView.swift
//  FuckCounter
//
//  Created by Alex on 11.12.2023.
//

import SwiftUI

fileprivate enum Constants {
    static let radius: CGFloat = 16
    static let snapRatio: CGFloat = 0.25
    static let minHeightRatio: CGFloat = 0//0.3
}

struct BottomSheetView<Content: View>: View {
    
    @Binding var isOpen: Bool
    
    let maxHeight: CGFloat
    let minHeight: CGFloat
    let bottomSheetHandler: ((Bool) -> Void)?
    let content: Content
    
    @GestureState private var translation: CGFloat = 0
    
    private var offset: CGFloat {
        isOpen ? 0 : maxHeight - minHeight
    }
    
    init(isOpen: Binding<Bool>, maxHeight: CGFloat, bottomSheetHandler: ((Bool) -> Void)? = nil, @ViewBuilder content: () -> Content) {
        self.minHeight = maxHeight * Constants.minHeightRatio
        self.maxHeight = maxHeight
        self.bottomSheetHandler = bottomSheetHandler
        self.content = content()
        self._isOpen = isOpen
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.content
            }
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(Constants.radius)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, 0))
            .animation(.interactiveSpring())
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    state = value.translation.height
                }.onEnded { value in
                    let snapDistance = self.maxHeight * Constants.snapRatio
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    self.isOpen = value.translation.height < 0
                    bottomSheetHandler?(self.isOpen)
                }
            )
        }
    }
}

#Preview {
    BottomSheetView(isOpen: .constant(false), maxHeight: 375) {
        CongratsView(userModel: nil, count: 0, subTitle: "")
    }
    .ignoresSafeArea()
}
