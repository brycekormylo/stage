//
//  ImageGridRow.swift
//  Stage
//
//  Created by Bryce on 11/5/23.
//

import SwiftUI

struct ImageGridRow: View {
    
    var images: [ID_URL]
    
    var body: some View {
        GeometryReader { geo in
            GridRow {
                AsyncImage(url: images[0].url) { phase in
                    phase.image?
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.frame(in: .global).width*2/3, height: geo.frame(in: .global).height/3)
                }
                .gridCellColumns(2)
                VStack {
                    AsyncImage(url: images[1].url) { phase in
                        phase.image?
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                    AsyncImage(url: images[2].url) { phase in
                        phase.image?
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                }
                .mask {
                    Rectangle()
                        .frame(width: geo.frame(in: .global).width/3)
                }
                .frame(width: geo.frame(in: .global).width/3, height: geo.frame(in: .global).height/3)
                .gridCellColumns(1)
            }
            .background(Color.black)
        }
    }
}
