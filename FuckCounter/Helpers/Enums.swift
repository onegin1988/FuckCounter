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

enum FiltersEvent: String, Hashable {
    case languages
    case customWord
    
    var title: String {
        switch self {
        case .languages: return "Languages"
        case .customWord: return "Custom Word"
        }
    }
}

enum SettingsEvent: String, Hashable {
    case login
}

enum LeadersEvent: String, Hashable {
    case login
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
    
    var result: String {
        switch self {
        case .green: return "Bad words today"
        case .orange: return "Not bad, but you can better 👑"
        case .red: return "Maybe it’s time to read 🎩 Sheakspear?"
        }
    }
}

enum LeadersTimeType: Int {
    case daily = 0, weekly, yearly
    
    var title: String {
        switch self {
        case .daily: return "Daily"
        case .weekly: return "Weekly"
        case .yearly: return "Yearly"
        }
    }
}

enum SettingsItem: Int, CaseIterable, Hashable {
    case createAccount = 0, notifications, invite, rate, terms, logout
    
    var title: String {
        switch self {
        case .createAccount: return "Create account with Facebook"
        case .notifications: return "Enable notifications"
        case .terms: return "Terms of Conditions"
        case .invite: return "Invite Friends"
        case .rate: return "Rate App"
        case .logout: return "Log out"
        }
    }
    
    var icon: Image {
        switch self {
        case .createAccount: return Images.facebookBlue
        case .notifications: return Images.notifications
        case .terms: return Images.support
        case .invite: return Images.invite
        case .rate: return Images.rate
        case .logout: return Images.logout
        }
    }
    
    var useChevron: Bool {
        switch self {
        case .createAccount, .logout: return false
        default: return true
        }
    }
}
