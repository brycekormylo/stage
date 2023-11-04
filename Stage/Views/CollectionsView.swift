//
//  CollectionsView.swift
//  Fotofolio
//
//  Created by Bryce on 10/24/23.
//

import SwiftUI

struct CollectionsView: View {
    
    @EnvironmentObject var theme: ThemeController
    
    let content: [URL]
    let imageHeight: CGFloat
    
    init(_ content: [URL] = sampleImages, imageHeight: CGFloat = 300) {
        self.content = content
        self.imageHeight = imageHeight
    }
    
    var body: some View {
        ScrollView() {
            LazyVStack {
                Spacer(minLength: 64)
                HStack {
                    Spacer()
                    Text("Collections")
                        .font(.title)
                }
                .padding()
                .padding(.bottom)
                collection
                HStack {
                    Spacer()
                    Text("Natural beauty")
                        .font(.title2)
                }
                .padding()
                collection
                collection
                collection

            }
        }
        .foregroundStyle(theme.text)
    }
    
    var collection: some View {
        ScrollView(.horizontal) {
            HStack {
                Spacer(minLength: 40)
                ForEach(content, id: \.self) { imageURL in
                    SlidingImage(imageURL, .horizontal, startingHeight: imageHeight)
                }
                Spacer(minLength: 80)
            }
        }

        .padding(.bottom)
        
    }
}