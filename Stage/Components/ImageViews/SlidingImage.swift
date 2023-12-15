//
//  SlidingImage.swift
//  Samples
//
//  Created by Bryce on 10/19/23.
//

import SwiftUI

enum ScrollDirection {
    case vertical
    case horizontal
}

struct SlidingImage: View {

    let url: URL
    let initialHeight: CGFloat
    let scrollDirection: ScrollDirection
    @State private var isExpanded: Bool = false
    @EnvironmentObject var imageSliderController: ImageSliderController
    
    init( _ url: URL = sampleImages[0], _ scrollDirection: ScrollDirection = .vertical, startingHeight: CGFloat = 0) {
        self.url = url
        self.initialHeight = startingHeight
        self.scrollDirection = scrollDirection
    }
    
    var body: some View {
        GeometryReader { geo in
            AsyncImage(url: url) { result in
                ZStack {
                    Color.clear
                        .background(
                            result.image?
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: scrollDirection == .vertical ? 0 : initialHeight * 1.08,
                                       height: scrollDirection == .vertical ? initialHeight * 1.72 : 0)
                                .offset(scrollDirection == .vertical ?
                                        CGSize(width: 0, height: -(geo.frame(in: .global).midY/2 - initialHeight/2)) :
                                            CGSize(width: -(geo.frame(in: .global).midX/2 - initialHeight / 3.5), height: 0))
                        )
                        .mask { RoundedRectangle(cornerRadius: 24) }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            guard scrollDirection != .horizontal else { return }
                            withAnimation {
                                if isExpanded {
                                    imageSliderController.minimizeAll()
                                } else {
                                    imageSliderController.expandImage(withURL: self.url)
                                }
                            }
                        }
                }
            }
        }
        .frame(minWidth: initialHeight)
        .modifier(AnimatingCellHeight(height: isExpanded ? initialHeight * 1.614 : initialHeight))
        .onReceive(imageSliderController.$expandedImage) { expandedImage in
            withAnimation {
                if let expandedURL = imageSliderController.expandedImage, expandedURL == url {
                    self.isExpanded = true
                } else {
                    self.isExpanded = false
                }
            }
        }
    }
}

struct AnimatingCellHeight: AnimatableModifier {
    var height: CGFloat = 0
    
    var animatableData: CGFloat {
        get { height }
        set { height = newValue }
    }
    
    func body(content: Content) -> some View {
        content.frame(height: height)
    }
}

#Preview {
    SlidingImage()
}
