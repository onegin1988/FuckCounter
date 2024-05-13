//
//  ReviewApp.swift
//  SwearCounter
//
//  Created by Alex on 14.12.2023.
//

import Foundation
import StoreKit

class ReviewApp {
    
    static func requestReview() {
        guard let writeReviewURL = URL(string: "https://itunes.apple.com/app/id6474148666?action=write-review") else { return }
        if UIApplication.shared.canOpenURL(writeReviewURL) {
            UIApplication.shared.open(writeReviewURL)
        }
    }
}
