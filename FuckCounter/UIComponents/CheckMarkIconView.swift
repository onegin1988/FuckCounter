//
//  CheckMarkIconView.swift
//  FuckCounter
//
//  Created by Alex on 04.03.2024.
//

import SwiftUI

struct CheckMarkIconView: View {
    
    private let isChecked: Bool
    
    init(isChecked: Bool = false) {
        self.isChecked = isChecked
    }
    
    var body: some View {
        if isChecked {
            Images.checked
        } else {
            Images.unchecked
        }
    }
}
