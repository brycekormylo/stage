//
//  HighlightsView.swift
//  Fotofolio
//
//  Created by Bryce on 10/24/23.
//

import SwiftUI

struct HighlightsView: View {
    
    @EnvironmentObject var theme: ThemeController
    
    let content: [URL]
    let imageHeight: CGFloat
    
    init(_ content: [URL] = sampleImages, imageHeight: CGFloat = 300) {
        self.content = content
        self.imageHeight = imageHeight
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                Spacer(minLength: 64)
                HStack {
                    Spacer()
                    Text("Highlights")
                        .font(.title)
                }
                .padding()
                .padding(.bottom)
                ForEach(content, id: \.self) { imageURL in
                    SlidingImage(imageURL, startingHeight: imageHeight)
                }
                Spacer(minLength: 240)
            }
        }
        .foregroundStyle(theme.text)
    }
}
