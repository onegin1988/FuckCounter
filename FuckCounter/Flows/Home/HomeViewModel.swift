//
//  HomeViewModel.swift
//  FuckCounter
//
//  Created by Alex on 07.12.2023.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    
    @Published var level: Level
    
    init() {
        self.level = .green
    }
}
