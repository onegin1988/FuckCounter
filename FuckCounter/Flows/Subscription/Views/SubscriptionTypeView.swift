//
//  SubscriptionTypeView.swift
//  FuckCounter
//
//  Created by Alex on 19.03.2024.
//

import SwiftUI

struct SubscriptionTypeView: View {
    
    private let isSelected: Bool
    private let title: String
    private let weekDay: String
    private let price: String
    private let percentage: Int
    
    init(isSelected: Bool, title: String, weekDay: String, price: String, percentage: Int) {
        self.isSelected = isSelected
        self.title = title
        self.weekDay = weekDay
        self.price = price
        self.percentage = percentage
    }
    
    var body: some View {
        setupBgFrame()
    }
    
    @ViewBuilder
    private func setupBgFrame() -> some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 8)
                .fill(isSelected ? .black.opacity(0.4) : .black.opacity(0.2))
                .overlay {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: isSelected ? 1.0 : 2.0)
                            .fill(isSelected ? Colors._FFDD64 : .white.opacity(0.4))
                        
                        prepareContent(percent: percentage)
                    }
                }
                .padding(.top, 10)
            
            if isSelected {
                prepareSubscriptionInfoView(title: "POPULAR", radius: 8, textSize: 11, textColor: Colors._4A4A4A)
            }
        }
    }
        
    @ViewBuilder
    private func prepareContent(percent: Int) -> some View {
        ZStack {
            VStack(alignment: .center, spacing: 0) {
                MediumTextView(style: .sfPro, title: title, size: 32)
                    .frame(height: 28)
                
                RegularTextView(style: .sfPro, title: weekDay, size: 16, color: .white.opacity(0.4))
                    .frame(height: 24)
                
                BoldTextView(style: .sfPro, title: price, size: 19)
                    .frame(height: 32)
                    .padding(.top, 4)
                
                if percent != 0 {
                    prepareSubscriptionInfoView(title: "SAVE \(percent)%", radius: 4, textSize: 10, textColor: .black)
                        .padding(EdgeInsets(top: 16, leading: 10, bottom: 0, trailing: 10))
                } else {
                    prepareEmptySaveView()
                }
            }
        }
    }
    
    @ViewBuilder
    private func prepareSubscriptionInfoView(
        title: String,
        radius: CGFloat,
        textSize: CGFloat,
        textColor: Color
    ) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: radius)
                .fill(Colors._FFDD64)
                .frame(height: 16)
                .padding(EdgeInsets(top: 2, leading: 10, bottom: 0, trailing: 10))
            
            BoldTextView(style: .sfPro, title: title, size: textSize, color: textColor)
                .frame(height: 16)
                .padding(.top, 2)
        }
    }
    
    @ViewBuilder
    private func prepareEmptySaveView() -> some View {
        ZStack {
            Rectangle()
                .fill(.clear)
                .frame(height: 16)
                .padding(EdgeInsets(top: 16, leading: 10, bottom: 0, trailing: 10))
        }
    }
}

#Preview {
    Group {
        SubscriptionTypeView(isSelected: true, title: "1", weekDay: "month", price: "$0,99", percentage: 10)
            .frame(width: 98, height: 173)
        
        SubscriptionTypeView(isSelected: false, title: "1", weekDay: "month", price: "$0,99", percentage: 10)
            .frame(width: 98, height: 173)
    }
}
