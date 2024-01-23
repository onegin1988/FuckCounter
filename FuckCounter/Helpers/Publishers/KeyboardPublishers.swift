//
//  KeyboardPublishers.swift
//  FuckCounter
//
//  Created by Alex on 24.01.2024.
//

import Combine
import Foundation
import UIKit

extension Notification {
    
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}

extension Publishers {
    
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map({ $0.keyboardHeight })
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map({ _ in CGFloat(0) })
        
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}
