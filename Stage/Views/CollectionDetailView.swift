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
                                Image(systemName: "xmark")
                            }
                            .modifier(CircleButton())
                            .zIndex(2.0)
                        }
                        Spacer()
                    }
                    .padding(.top, 64)
                    .padding(.horizontal, 16)
                    .transition(.move(edge: .top))
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

//struct ScrollOffsetPreferenceKey: PreferenceKey {
//    static var defaultValue: CGPoint = .zero
//    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
//        value = nextValue()
//    }
//}
//
//struct ScrollView<Content: View>: View {
//    let axes: Axis.Set
//    let showsIndicators: Bool
//    let offsetChanged: (CGPoint) -> Void
//    let content: Content
//    init(
//        axes: Axis.Set = .vertical,
//        showsIndicators: Bool = true,
//        offsetChanged: @escaping (CGPoint) -> Void = { _ in },
//        @ViewBuilder content: () -> Content
//    ) {
//        self.axes = axes
//        self.showsIndicators = showsIndicators
//        self.offsetChanged = offsetChanged
//        self.content = content()
//    }
//    
//    var body: some View {
//        SwiftUI.ScrollView(axes, showsIndicators: showsIndicators) {
//            GeometryReader { geometry in
//                Color.clear.preference(
//                    key: ScrollOffsetPreferenceKey.self,
//                    value: geometry.frame(in: .named("scrollView")).origin
//                )
//            }.frame(width: 0, height: 0)
//            content
//        }
//        .coordinateSpace(name: "scrollView")
//        .onPreferenceChange(ScrollOffsetPreferenceKey.self, perform: offsetChanged)
//    }
//}
//

#Preview {
    CollectionDetailView()
}
