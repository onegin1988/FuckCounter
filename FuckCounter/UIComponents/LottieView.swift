//
//  LottieView.swift
//  FuckCounter
//
//  Created by Alex on 22.02.2024.
//

import Lottie
import SwiftUI

struct LottieView: UIViewRepresentable {
    
    private let animationName: String
    private let loopMode: LottieLoopMode
    private let animationSpeed: CGFloat
    
    init(animationName: String, loopMode: LottieLoopMode = .playOnce, animationSpeed: CGFloat = 1) {
        self.animationName = animationName
        self.loopMode = loopMode
        self.animationSpeed = animationSpeed
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        let animationView = LottieAnimationView(name: animationName)
        animationView.loopMode = loopMode
        animationView.animationSpeed = animationSpeed
        animationView.play()
        animationView.contentMode = .scaleAspectFill
        return animationView
    }
}
