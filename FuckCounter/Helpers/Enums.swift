//
//  Enums.swift
//  FuckCounter
//
//  Created by Alex on 06.12.2023.
//

import SwiftUI

enum HomeEvent: String, Hashable {
    case settings, filters, leaders
    
    var title: String {
        switch self {
        case .settings: return "Settings"
        case .filters: return "Filters"
        case .leaders: return "Leaders"
        }
    }
}

enum Level: String {
    case green
    case orange
    case red
    
    var background: GradientStyle.Style {
        switch self {
        case .green: return .green
        case .orange: return .orange
        case .red: return .red
        }
    }
    
    var icon: Image {
        switch self {
        case .green: return Images.greenState
        case .orange: return Images.orangeState
        case .red: return Images.redState
        }
    }
}
