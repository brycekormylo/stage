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
    
    @State var isScrolling = false
    @State private var timer: Timer?
    
    @State var collection: ImageCollection?
    
    var images: [ID_URL] = sampleImages.enumerated().map { index, url in
        ID_URL(id: UUID(), url: url, order: index)
    }
    
    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView(
                .vertical,
                showsIndicators: false
            ) {
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
                .background(theme.background)
            }
        }
            .overlay {
                if isScrolling {
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: { dismiss() }) {
                                HStack {
                                    Spacer()
                                    ZStack {
                                        Rectangle()
                                            .fill(theme.background)
                                            .cornerRadius(12, corners: [.topLeft, .bottomLeft])
                                            .ignoresSafeArea()
                                            .frame(width: 110)
                                            .offset(x: 55)
                                        Image(systemName: "xmark")
                                            .foregroundStyle(theme.text)
                                            .offset(x: 22)
                                    }
                                }
                                .frame(height: 55)
                            }
                            .zIndex(2.0)
                        }
                        Spacer()
                    }
                    .padding(.top, 64)
                    .transition(.move(edge: .trailing))
                }
            }
            .ignoresSafeArea()
            .gesture(DragGesture().onChanged { _ in
                handleScroll(scrollView: scrollView)
            })
        }
        .onAppear {
            isScrolling = true
        }
        .animation(
            .interactiveSpring(response: 0.4, dampingFraction: 0.85, blendDuration: 0.74), value: isScrolling)
    }
    
    private func handleScroll(scrollView: ScrollViewProxy) {
        isScrolling = true
        resetTimer()
    }
    
    private func resetTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            isScrolling = false
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

struct CollectionImageRow: View {
    
    let images: [ID_URL]
    
    var body: some View {
        switch (images.count) {
        case 0:
            Text("No images found")
            
        case 1:
            CollectionImage(images[0], style: .large)
            
        case 3:
            HStack(spacing: 0) {
                CollectionImage(images[0], style: .medium)
                VStack(spacing: 0) {
                    CollectionImage(images[1], style: .small)
                    CollectionImage(images[2], style: .small)
                }
            }
        case 6:
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    CollectionImage(images[0], style: .small)
                    CollectionImage(images[1], style: .small)
                    CollectionImage(images[2], style: .small)
                }
                HStack(spacing: 0) {
                    CollectionImage(images[3], style: .small)
                    CollectionImage(images[4], style: .small)
                    CollectionImage(images[5], style: .small)
                }
            }
            
        default:
            Text("Unacceptable image count")
        }
    }
}

#Preview {
    CollectionDetailView()
}
