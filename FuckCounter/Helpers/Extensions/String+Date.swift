//
//  String+Date.swift
//  FuckCounter
//
//  Created by Alex on 29.02.2024.
//

import Foundation

extension String {
    
    func toDate(format: String = AppConstants.defaultDateFormat) -> Date {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.date(from: self) ?? Date()
    }
}
