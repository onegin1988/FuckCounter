//
//  ReviewApp.swift
//  FuckCounter
//
//  Created by Alex on 14.12.2023.
//

import Foundation
import StoreKit

class ReviewApp {
    
    static func requestReview() {
//        let infoDictionaryKey = kCFBundleVersionKey as String
//        guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String else {
//            fatalError("Expected to find a bundle version in the info dictionary")
//        }
//        
//        if currentVersion != AppData.lastVersionPromptedForReviewKey {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
//                    AppData.lastVersionPromptedForReviewKey = currentVersion
                    SKStoreReviewController.requestReview(in: scene)
                }
            }
//        }
    }
}
