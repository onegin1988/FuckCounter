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
    
    init() {
        self.level = .green
        self.counter = 0
    }
    
    // Test
    func checkCounter() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.counter += 6
            
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
    }
}
