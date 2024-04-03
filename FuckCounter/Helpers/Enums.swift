//
//  Enums.swift
//  FuckCounter
//
//  Created by Alex on 06.12.2023.
//

import SwiftUI

enum HomeEvent: String, Hashable {
    case settings, filters, leaders, subscription
    
    var title: String {
        switch self {
        case .settings: return "Settings"
        case .filters: return "Filters"
        case .leaders: return "Leaders"
        case .subscription: return ""
        }
    }
}

enum FiltersEvent: String, Hashable {
    case languages
    case customWord
    case subscription
    
    var title: String {
        switch self {
        case .languages: return "Languages"
        case .customWord: return "Custom Word"
        case .subscription: return ""
        }
    }
}

enum SettingsEvent: String, Hashable {
    case login, subscription
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
        case .green: return "Exellent, you’re Rock!"
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
    case createAccount = 0, notifications, invite, rate, terms, deleteAccount, logout
    
    var title: String {
        switch self {
        case .createAccount: return "Create account"
        case .notifications: return "Enable notifications"
        case .terms: return "Terms of Conditions"
        case .invite: return "Invite Friends"
        case .rate: return "Rate App"
        case .deleteAccount: return "Delete account"
        case .logout: return "Log out"
        }
    }
    
    var icon: Image {
        switch self {
        case .createAccount: return Images.createAccount
        case .notifications: return Images.notifications
        case .terms: return Images.support
        case .invite: return Images.invite
        case .rate: return Images.rate
        case .deleteAccount: return Images.deleteAccount
        case .logout: return Images.logout
        }
    }
    
    var useChevron: Bool {
        switch self {
        case .createAccount, .logout, .deleteAccount: return false
        default: return true
        }
    }
}

enum LanguageCode: String, CaseIterable {
    case en, de, fr, uk, ru
    
    var title: String {
        switch self {
        case .en: return "English"
        case .de: return "Deutch"
        case .fr: return "France"
        case .uk: return "Ukrainian"
        case .ru: return "Russian"
        }
    }
    
    var languageSymbol: String {
        switch self {
        case .en: return "en"
        case .de: return "de"
        case .fr: return "fr"
        case .uk: return "ua"
        case .ru: return "ru"
        }
    }
}

enum ProductType: String, CaseIterable {
    case oneMonth = "premium.one.month"
    case oneWeek = "premium.one.week"
    case threeMonth = "premium.three.month"
    case oneYear = "premium.one.year"
    
    var percentage: Int {
        switch self {
        case .oneMonth: return 0
        case .oneWeek: return 49
        case .threeMonth: return 19
        case .oneYear: return 40
        }
    }
    
    var qty: Int {
        return self == .threeMonth ? 3 : 1
    }
    
    var weekDay: String {
        switch self {
        case .oneMonth, .threeMonth: return "month"
        case .oneWeek: return "week"
        case .oneYear: return "year"
        }
    }
}

enum SubscriptionInfo: CaseIterable {
    case firstInfo, secondInfo, thirdInfo
    
    var info: (String, String, Image) {
        switch self {
        case .firstInfo: return ("Use Custom Words", "Extended filters", Images.subscriptionInfoIcon_1)
        case .secondInfo: return ("See Frends Statistic", "Full Access", Images.subscriptionInfoIcon_2)
        case .thirdInfo: return ("Additional Languages", "Deutch, France, Ukrainian, Russian", Images.subscriptionInfoIcon_3)
        }
    }
}
