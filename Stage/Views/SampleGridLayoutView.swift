//
//  SampleGridLayoutView.swift
//  Stage
//
//  Created by Bryce on 11/5/23.
//

import SwiftUI

struct SampleGridLayoutView: View {
    
    var images: [ID_URL] = sampleImages.enumerated().map { index, url in
        ID_URL(id: UUID(), url: url, order: index)
    }
    
    var body: some View {
        ScrollView {
            HStack(spacing: 0) {
                CollectionImage(images[6], style: .medium)
                VStack(spacing: 0) {
                    CollectionImage(images[3], style: .small)
                    CollectionImage(images[5], style: .small)
                }
            }
        }
    }
    
//    var body: some View {
//        GeometryReader { geo in
//            ScrollView {
//                Grid(horizontalSpacing: 0, verticalSpacing: 0) {
//                    GridRow {
//                        ZStack {
//                            CustomAsyncImage(url: images[0].url)
//                                .padding(imagePadding)
//                        }
//                        .mask {
//                            Rectangle()
//                                .frame(width: geo.frame(in: .global).width*2/3-imagePadding*2)
//                        }
//                        .frame(width: geo.frame(in: .global).width*2/3)
//                        .gridCellColumns(2)
//                        VStack(spacing: imagePadding*2) {
//                            CustomAsyncImage(url: images[6].url)
//                                .padding(.horizontal, imagePadding)
//                            CustomAsyncImage(url: images[2].url)
//                                .padding(.horizontal, imagePadding)
//                        }
//                        .padding(.vertical, imagePadding)
//                        .mask {
//                            Rectangle()
//                                .frame(width: geo.frame(in: .global).width/3-imagePadding*2)
//                        }
//                        .frame(width: geo.frame(in: .global).width/3)
//                        .gridCellColumns(1)
//                    }
//                    .frame(height: geo.frame(in: .global).height/3)
//                    .background(Color.black)
//                    
//                    GridRow {
//                        VStack(spacing: imagePadding*2) {
//                            CustomAsyncImage(url: images[6].url)
//                                .padding(.horizontal, imagePadding)
//                            CustomAsyncImage(url: images[2].url)
//                                .padding(.horizontal, imagePadding)
//                        }
//                        .padding(.vertical, imagePadding)
//                        .mask {
//                            Rectangle()
//                                .frame(width: geo.frame(in: .global).width/3-imagePadding*2)
//                        }
//                        .frame(width: geo.frame(in: .global).width/3)
//                        .gridCellColumns(1)
//                        ZStack {
//                            CustomAsyncImage(url: images[5].url)
//                                .padding(imagePadding)
//                        }
//                        .mask {
//                            Rectangle()
//                                .frame(width: geo.frame(in: .global).width*2/3-imagePadding*2)
//                        }
//                        .frame(width: geo.frame(in: .global).width*2/3)
//                        .gridCellColumns(2)
//                        
//                    }
//                    .frame(height: geo.frame(in: .global).height/3)
//                    .background(Color.black)
//                    
//                    GridRow {
//                        ZStack {
//                            CustomAsyncImage(url: images[6].url)
//                                .padding(imagePadding)
//                        }
//                        .mask {
//                            Rectangle()
//                                .frame(width: geo.frame(in: .global).width*2/3-imagePadding*2)
//                        }
//                        .frame(width: geo.frame(in: .global).width*2/3)
//                        .gridCellColumns(2)
//                        VStack(spacing: imagePadding*2) {
//                            CustomAsyncImage(url: images[6].url)
//                                .padding(.horizontal, imagePadding)
//                            CustomAsyncImage(url: images[2].url)
//                                .padding(.horizontal, imagePadding)
//                        }
//                        .padding(.vertical, imagePadding)
//                        .mask {
//                            Rectangle()
//                                .frame(width: geo.frame(in: .global).width/3-imagePadding*2)
//                        }
//                        .frame(width: geo.frame(in: .global).width/3)
//                        .gridCellColumns(1)
//                        
//                    }
//                    .frame(height: geo.frame(in: .global).height/3)
//                    .background(Color.black)
//                }
//            }
//        }
//
//    }
}

#Preview {
    SampleGridLayoutView()
}
