//
//  String+Valid.swift
//  FuckCounter
//
//  Created by Alex on 04.03.2024.
//

import Foundation

extension String {
    func isEmptyOrWhitespace() -> Bool {
        if isEmpty {
            return true
        }
        
        return trimmingCharacters(in: .whitespacesAndNewlines) == ""
    }
}
