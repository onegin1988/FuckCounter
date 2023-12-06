//
//  Enums.swift
//  FuckCounter
//
//  Created by Alex on 06.12.2023.
//

import Foundation

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
