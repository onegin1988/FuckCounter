//
//  AppsListRow.swift
//  FuckCounter
//
//  Created by Alex on 10.12.2023.
//

import SwiftUI

struct AppsListRow: View {
    
    private let appsModel: AppsModel
    private let onGet: (() -> Void)?
    
    init(appsModel: AppsModel, onGet: (() -> Void)?) {
        self.appsModel = appsModel
        self.onGet = onGet
    }
    
    var body: some View {
        ZStack {
            BlackBgView()
            
            HStack(alignment: .center, spacing: 12) {
                appImageView()
                appLabelsView()
                Spacer()
                appsGetButtonView()
            }
            .padding(.all, 12)
        }
    }
    
    private func appImageView() -> some View {
        Image(appsModel.imageName)
            .cornerRadius(10)
            .frame(width: 48, height: 48)
    }
    
    private func appLabelsView() -> some View {
        VStack(alignment: .leading, spacing: 4, content: {
            SemiboldTextView(style: .sfPro, title: appsModel.name, size: 19)
                .frame(height: 23)
            RegularTextView(style: .sfPro, title: appsModel.description, size: 11, color: .white.opacity(0.59))
                .frame(height: 13)
        })
    }
    
    private func appsGetButtonView() -> some View {
        Button {
            onGet?()
        } label: {
            MediumTextView(style: .sfPro, title: "Get", color: Colors._386AFF)
                .padding(.vertical, 10)
                .padding(.horizontal, 18.5)
        }
        .background(
            Capsule()
                .fill(Colors._EDEDED)
        )
    }
}

#Preview {
    AppsListRow(appsModel: AppsModel(name: "Test", description: "Test description", imageName: "yoga88Icon", url: ""), onGet: nil)
        .padding(.horizontal, 16)
        .frame(height: 72)
}
