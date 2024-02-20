//
//  ImageView.swift
//  FuckCounter
//
//  Created by Alex on 15.02.2024.
//

import SwiftUI

struct ImageView: View {
    
    private let url: String
    
    init(url: String) {
        self.url = url
    }
    
    var body: some View {
        if url.isEmpty {
            setupImage(Images.avatarSmall)
        } else {
            AsyncImage(url: URL(string: url)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    setupImage(image)
                        .clipShape(Circle())
                case .failure:
                    setupImage(Images.avatarSmall)
                @unknown default:
                    fatalError()
                }
            }
        }
    }
    
    private func setupImage(_ image: Image) -> some View {
        image
            .resizable()
            .scaledToFit()
    }
}

#Preview {
    ImageView(url: "https://picsum.photos/200")
}
