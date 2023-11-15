//
//  ProfileView.swift
//  Fotofolio
//
//  Created by Bryce on 10/23/23.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var theme: ThemeController
    @EnvironmentObject var stageController: StageController
    @EnvironmentObject var imageController: ImageController
    @State var arrowUp: Bool = false
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                StickyHeader {
                    BannerImage()
                }
                VStack {
                    ProfileImage(size: 256)
                    info
                    Spacer(minLength: 400)
                    moreInfo
                        .padding(.vertical, 120)
                    GeometryReader { geo in
                        Color.clear
                            .onChange(of: geo.frame(in: .global).minY) {
                                self.arrowUp = geo.frame(in: .global).minY < 1000
                            }
                    }
                }
                .offset(y: -96)
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
        }
        .overlay(alignment: arrowUp ? .top : .bottom) {
            arrowButton
                .padding(arrowUp ? .top : .bottom, arrowUp ? 64 : 108)
        }
        .ignoresSafeArea()
    }
    
    var arrowButton: some View {
        ZStack {
            Image(systemName: arrowUp ? "chevron.up" : "chevron.down")
                .padding(.vertical, 8)
                .foregroundStyle(theme.text)
        }
    }
    
    var info: some View {
        StyledStack {
            Text(stageController.stage?.name ?? "Name")
                .font(.title)
            Text(stageController.stage?.profession ?? "Profession")
                .opacity(0.6)
            Text(stageController.stage?.intro ?? "About me")
                .padding(.vertical, 8)
        }
        .frame(height: 200)
    }
    
    var moreInfo: some View {
        VStack {
            if let segments = stageController.stage?.segments {
                ForEach(segments) { segment in
                    SegmentView(segment)
                    SegmentView(segment)
                }
            }
            ContactButton()
                .padding(.bottom, 40)
        }
        .padding(.top, 48)
    }
}

struct SegmentView: View {
    let segment: Segment
    
    init(_ segment: Segment) {
        self.segment = segment
    }
    
    var body: some View {
        StyledStack {
            HStack {
                Spacer()
                Text(segment.title ?? "Title")
                    .font(.title)
            }
            .padding(.horizontal)
            Text(segment.content ?? "Content")
                .padding(.vertical, 8)
        }
        .frame(height: 300)
    }
}

struct StyledStack<Content: View>: View {
    
    @EnvironmentObject var theme: ThemeController
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack {
            content
        }
        .foregroundStyle(theme.text)
        .padding(.horizontal)
    }
    
}

#Preview {
    ProfileView()
}
