//
//  CollectionDetailView.swift
//  Stage
//
//  Created by Bryce on 11/5/23.
//

import SwiftUI

struct CollectionDetailView: View {
    
    @EnvironmentObject private var theme: ThemeController
    @Environment(\.dismiss) private var dismiss
    
    var images: [ID_URL] = sampleImages.enumerated().map { index, url in
        ID_URL(id: UUID(), url: url, order: index)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
            ForEach(images, id: \.self) { image in
                HStack(spacing: 0) {
                    CollectionImage(image, style: .medium)
                    VStack(spacing: 0) {
                        CollectionImage(image, style: .small)
                        CollectionImage(image, style: .small)
                    }
                }
                CollectionImage(image, style: .large)
                }
            }
        }
    }
}

enum CollectionImageStyle: CGFloat {
    case small = 1
    case medium = 2
    case large = 3
}

struct CollectionImage: View {
    
    @EnvironmentObject var theme: ThemeController
    
    let url: ID_URL
    let style: CollectionImageStyle
    
    var size: CGFloat
    
    init(_ url: ID_URL, style: CollectionImageStyle = .small) {
        self.url = url
        self.style = style
        self.size = style.rawValue
    }
    
    var body: some View {
        Rectangle()
            .aspectRatio(1, contentMode: .fill)
            .frame(width: UIScreen.main.bounds.width*size/3)
            .overlay {
                AsyncImage(url: url.url) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                }
            }
            .clipped()
    }
}

#Preview {
    CollectionDetailView()
}
