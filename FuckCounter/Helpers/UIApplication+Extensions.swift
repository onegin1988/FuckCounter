//
//  UIApplication+Extensions.swift
//  FuckCounter
//
//  Created by Alex on 08.12.2023.
//

import UIKit

extension UIApplication {
    var keyWindow: UIWindow? {
        connectedScenes
            .compactMap {
                $0 as? UIWindowScene
            }
            .flatMap {
                $0.windows
            }
            .first {
                $0.isKeyWindow
            }
    }
    
}
