//
//  Int+Formatter.swift
//  FuckCounter
//
//  Created by Alex on 20.02.2024.
//

import Foundation

extension Int {
    
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
