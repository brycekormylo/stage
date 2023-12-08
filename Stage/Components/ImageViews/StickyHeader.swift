//
//  StickyHeader.swift
//  Stage
//
//  Created by Bryce on 11/13/23.
//

import SwiftUI

struct StickyHeader<Content: View>: View {
    
    var minHeight: CGFloat
    var content: Content

    init(minHeight: CGFloat = 360, @ViewBuilder content: () -> Content) {
        self.minHeight = minHeight
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geo in
            if(geo.frame(in: .global).minY <= 0) {
                content
                    .offset(y: -geo.frame(in: .global).minY*0.618)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            } else {
                content
                    .offset(y: -geo.frame(in: .global).minY)
                    .frame(width: geo.size.width, height: geo.size.height + geo.frame(in: .global).minY)
            }
        }
        .frame(minHeight: minHeight)
    }
}

