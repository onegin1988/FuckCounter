//
//  HomeViewModel.swift
//  FuckCounter
//
//  Created by Alex on 07.12.2023.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    
    @Published var level: Level
    @Published var counter: Int
    @Published var isPlay: Bool
    @Published var timeSlice: String
    @Published var isShowAppPush: Bool
    private var countForAppPush: Int
    
    init() {
        self.level = .green
        self.counter = 0
        self.isPlay = false
        self.timeSlice = ""
        self.countForAppPush = 0
        self.isShowAppPush = false
    }
    
    func checkLevel() {
        switch self.counter {
        case 0...5:
            self.level = .green
        case 6...15:
            self.level = .orange
        case 16...:
            self.level = .red
        default:
            self.level = .green
        }
    }
    
    func resetCounter() {
        counter = 0
        checkLevel()
    }
    
    func updateCountForAppPush() {
        countForAppPush += 1
        if countForAppPush >= 5 {
            withAnimation {
                isShowAppPush = true
            }
        }
    }
    
    func resetCountForAppPush() {
        countForAppPush = 0
        withAnimation {
            isShowAppPush = false
        }
    }
    
    var isPlayState: (String, Image, CGFloat) {
        if isPlay {
            return ("Stop", Images.stop, 120)
        }
        return ("Play", Images.play, 256)
    }
}
