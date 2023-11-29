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
    
    @State var name: String = "--"
    @State var profession: String = "--"
    @State var intro: String = "--"
    
    @State var segments: [Segment] = []
    
    func syncProfileInfo() {
        DispatchQueue.main.async {
            if let stage = stageController.stage {
                self.name = stage.name ?? ""
                self.profession = stage.profession ?? ""
                self.intro = stage.intro ?? ""
                self.segments = stage.segments ?? []
            }
        }
    }
    
    func updateProfileInfo() {
        DispatchQueue.main.async {
            if var stage = stageController.stage {
                stage.name = name
                stage.profession = profession
                stage.intro = intro
                stage.segments = segments
                Task {
                    await stageController.updateStage(stage)
                    syncProfileInfo()
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                BannerImage()
                VStack {
                    ProfileImage(size: 256)
                    info
                    ProfilePageFrame {
                        ForEach(stageController.sampleSegments) { segment in
                            SegmentView(segment)
                        }
                    }
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
        .onAppear {
            syncProfileInfo()
        }
        .onChange(of: stageController.stage) {
            syncProfileInfo()
        }
        .onChange(of: stageController.isEditEnabled) {
            if !stageController.isEditEnabled {
                updateProfileInfo()
            }
        }
    }
    
    var arrowButton: some View {
        Image(systemName: arrowUp ? "chevron.up" : "chevron.down")
            .padding(.vertical, 8)
            .foregroundStyle(theme.text)
    }
    
    var info: some View {
        VStack {
            EditableText(content: $name)
                .font(.title)
            EditableText(content: $profession)
                .opacity(0.6)
            CaptionView {
                EditableText(content: $intro)
                    .padding(.vertical, 8)
            }
        }
        .foregroundStyle(theme.text)
    }
}

struct ProfilePageFrame<Content: View>: View {
    
    @EnvironmentObject var theme: ThemeController
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack {
            content
        }
        .frame(minHeight: UIScreen.main.bounds.height - 240)
        .background {
            theme.backgroundAccent.opacity(0.2)
        }
        .padding(.top, 240)

    }
}

struct CaptionView<Content: View>: View {

    @EnvironmentObject var theme: ThemeController
    @ViewBuilder var content: Content
    
    var body: some View {
        HStack {
            content
        }
        .frame(height: 80)
        .padding()
        .background {
            theme.backgroundAccent.opacity(0.2)
        }
        .cornerRadius(8)
    }
}

struct SegmentView: View {
    
    @EnvironmentObject var theme: ThemeController
    @EnvironmentObject var stageController: StageController
    @State private var segment: Segment
    
    @State private var segmentTitle: String
    @State private var segmentContent: String
    
    init(_ seg: Segment) {
        _segment = State(initialValue: seg)
        if let title = seg.title {
            _segmentTitle = State(initialValue: title)
        } else {
            _segmentTitle = State(initialValue: "No title")
        }
        if let content = seg.content {
            _segmentContent = State(initialValue: content)
        } else {
            _segmentContent = State(initialValue: "No content")

        }
    }
    
    var body: some View {
        StyledStack {
            HStack {
                Spacer()
                EditableText(content: $segmentTitle)
                    .font(.title2)
            }
            .padding(.horizontal)
            Group {
                Spacer()
                EditableText(content: $segmentContent)
                Spacer()
            }
        }
        .padding()
        .background(Color.black)
        .padding(.vertical, 4)
        .frame(minHeight: (UIScreen.main.bounds.height - 240)/3)
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
    }
    
}
