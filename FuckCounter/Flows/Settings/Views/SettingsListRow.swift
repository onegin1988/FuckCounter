//
//  SettingsListRow.swift
//  FuckCounter
//
//  Created by Alex on 11.12.2023.
//

import SwiftUI

struct SettingsListRow: View {
    
    private let item: SettingsItem
    @Binding var isToggle: Bool
    private let onTap: (() -> Void)?
    
    init(item: SettingsItem, isToggle: Binding<Bool>, onTap: (() -> Void)?) {
        self.item = item
        self._isToggle = isToggle
        self.onTap = onTap
    }
    
    var body: some View {
        ZStack {
            BlackBgView()
            
            HStack(alignment: .center, spacing: 12) {
                if let url = AppData.userLoginModel?.image, item == .createAccount {
                    ImageView(url: url)
                        .frame(width: 28, height: 28)
                } else {
                    settingsIconView()
                }
                
                settingsLabelView()
                Spacer()
                
                if item == .notifications {
                    Toggle(isOn: $isToggle, label: {})
                        .tint(Colors._FFCF69)
                } else {
                    if item.useChevron {
                        Images.chev
                            .frame(width: 32, height: 32)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 13)
        }
        .onTapGesture {
            if item != .notifications {
                onTap?()
            }
        }
    }
    
    private func settingsIconView() -> some View {
        item.icon
            .frame(width: 28, height: 28)
            .background {
                Circle()
                    .fill(Colors._FFDD64)
            }
    }
    
    private func settingsLabelView() -> some View {
        if let name = AppData.userLoginModel?.name, item == .createAccount {
            RegularTextView(style: .sfPro, title: name, size: 15)
                .frame(height: 18)
        } else {
            RegularTextView(style: .sfPro, title: item.title, size: 15)
                .frame(height: 18)
        }
    }
}

#Preview {
    SettingsListRow(item: .notifications, isToggle: .constant(true), onTap: nil)
        .padding(.horizontal, 16)
        .frame(height: 54)
}
