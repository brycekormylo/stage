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
    @State var bannerHeight: CGFloat = 320
    @State var profileImageSize: CGFloat = 164
    
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
                stageController.stage = stage
                syncProfileInfo()
            }
        }
    }
    
    var body: some View {
        ZStack {
            if stageController.isEditEnabled && arrowUp {
                ZStack() {
                    SegmentOrderChangerButton()
                        .padding(.bottom, 204)
                    NewSegmentButton()
                        .padding(.bottom, 148)
                }
                .zIndex(1)
                .transition(.move(edge: .trailing))
            }
            ScrollView(showsIndicators: false) {
                BannerImage()
                VStack {
                    HStack {
                        ProfileImage(size: profileImageSize)
                            .padding(.leading, 36)
                            .shadow(color: theme.background.opacity(0.6), radius: 8, x: 0, y: 0)
                        Spacer()
                    }
                    info
                    if let segments = stageController.stage?.segments {
                        ForEach(segments.chunked(into: 3), id: \.self) { segmentChunk in
                            ProfilePageFrame {
                                ForEach(segmentChunk) { segment in
                                    SegmentView(segment)
                                }
                                if segmentChunk.count < 3 {
                                    ContactButton()
                                }
                            }
                        }
                    }
                    GeometryReader { geo in
                        Color.clear
                            .onChange(of: geo.frame(in: .global).minY) {
                                self.arrowUp = geo.frame(in: .global).minY < 1000
                            }
                    }
                }
                .offset(y: -profileImageSize*0.61)
                .background {
                    ZStack {
                        theme.background
                        VStack {
                            Rectangle()
                                .fill(theme.background)
                                .frame(height: 48)
                                .cornerRadius(32, corners: [.topLeft, .topRight])
                                .offset(y: -48)
                                .shadow(color: theme.background.opacity(0.6), radius: 8, x: 0, y: 0)
                            Spacer()
                        }
                    }
                }
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
        .animation(
            .interactiveSpring(response: 0.45, dampingFraction: 0.69, blendDuration: 0.74), value: stageController.isEditEnabled)
    }
    
    var arrowButton: some View {
        Image(systemName: arrowUp ? "chevron.up" : "chevron.down")
            .padding(.vertical, 8)
            .foregroundStyle(theme.text)
    }
    
    @State var infoOpacity: CGFloat = 0.0
    
    var info: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                EditableField(content: $name)
                    .font(.custom("Quicksand-Medium", size: 36))
            }
            .padding(.horizontal, 24)
            HStack {
                Spacer()
                EditableField(content: $profession)
                    .font(.custom("Quicksand-Light", size: 18))
                    .opacity(0.6)
            }
            .padding(.horizontal, 24)
            Spacer()
            CaptionView {
                EditableText(content: $intro)
                    .font(.custom("Quicksand-Medium", size: 18))
                    .padding(.vertical, 4)
            }
            .transition(.move(edge: .leading))
            .opacity(infoOpacity)
            Spacer()
            
        }
        .onAppear {
            withAnimation(.easeInOut) {
                infoOpacity = 0.0
                infoOpacity += 1.0
            }
        }
        .animation(
            .interactiveSpring(response: 0.45, dampingFraction: 0.69, blendDuration: 0.74), value: infoOpacity)
        .frame(height: UIScreen.main.bounds.height*(0.314))
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
        .cornerRadius(18)
        .padding(.horizontal, 8)
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
                EditableField(content: $segmentTitle)
                    .font(.custom("Quicksand-Medium", size: 24))
            }
            Group {
                Spacer()
                EditableText(content: $segmentContent)
                    .font(.custom("Quicksand-Medium", size: 18))
                Spacer()
            }
        }
        .padding()
        .background {
            theme.backgroundAccent
                .opacity(0.1)
                .cornerRadius(18)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .frame(height: (UIScreen.main.bounds.height - 240)/3)
        .onChange(of: segmentTitle) {
            if var stage = stageController.stage, var segments = stage.segments {
                segments = segments.map { segment in
                    if segment.id != self.segment.id {
                        return segment
                    } else {
                        var modifiedSegment = segment
                        modifiedSegment.title = self.segmentTitle
                        modifiedSegment.content = self.segmentContent
                        return modifiedSegment
                    }
                }
                stage.segments = segments
                stageController.stage = stage
            }
        }
        .onChange(of: segmentContent) {
            if var stage = stageController.stage, var segments = stage.segments {
                segments = segments.map { segment in
                    if segment.id != self.segment.id {
                        return segment
                    } else {
                        var modifiedSegment = segment
                        modifiedSegment.title = self.segmentTitle
                        modifiedSegment.content = self.segmentContent
                        return modifiedSegment
                    }
                }
                stage.segments = segments
                stageController.stage = stage
            }
        }
    }
}

struct NewSegmentButton: View {
    @EnvironmentObject var theme: ThemeController
    @EnvironmentObject var stageController: StageController
    
    @State var presentNewSegmentCreator: Bool = false
    
    var body: some View {
        ZStack {
            if stageController.isEditEnabled {
                if presentNewSegmentCreator {
                    VStack {
                        SegmentCreatorView(isPresented: $presentNewSegmentCreator)
                        Spacer()
                    }
                    .padding(.top, 120)
                    .transition(.move(edge: .trailing))
                } else {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                presentNewSegmentCreator.toggle()
                            }) {
                                Image(systemName: "plus")
                                    .foregroundStyle(theme.text)
                            }
                            .modifier(SideMountedButton(backgroundColor: theme.button))
                        }
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .zIndex(1)
        .animation(
            .interactiveSpring(response: 0.45, dampingFraction: 0.69, blendDuration: 0.74), value: presentNewSegmentCreator)
    }
}

struct SegmentCreatorView: View {
    
    @Binding var isPresented: Bool
    
    @EnvironmentObject var theme: ThemeController
    @EnvironmentObject var stageController: StageController
    
    @State var title: String = ""
    @State var content: String = ""
    @State var isContactSegment: Bool = false
    
    var body: some View {
        
        VStack {
            HStack {
                Text("New Segment")
                    .font(.custom("Quicksand-Medium", size: 24))
                    .opacity(0.6)
                Spacer()
            }
            .padding(.horizontal)
            TextField("", text: $title)
                .placeholder(when: title.isEmpty) {
                    Text("Title")
                        .foregroundColor(theme.text.opacity(0.6))
                        .font(.custom("Quicksand-Medium", size: 18))
                }
                .padding()
                .background(theme.button.opacity(0.1))
                .cornerRadius(8)
            TextEditor(text: $content)
                .placeholder(when: content.isEmpty) {
                    VStack {
                        Text("Content")
                            .foregroundColor(theme.text.opacity(0.6))
                            .font(.custom("Quicksand-Medium", size: 18))
                        Spacer()
                    }
                    .padding()
                }
                .scrollContentBackground(.hidden)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(theme.button.opacity(0.1))
                }
                .multilineTextAlignment(.leading)
                .frame(maxHeight: 120)
            HStack {
                Spacer()
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark")
                }
                .modifier(CircleButton())
                Button(action: {
                    submitNewSegment()
                    isPresented = false
                }) {
                    Image(systemName: "checkmark")
                }
                .disabled(title.isEmpty)
                .modifier(CircleButton())
            }
        }
        .padding()
        .background {
            theme.backgroundAccent
                .cornerRadius(12)
        }
        .padding()
        .foregroundStyle(theme.text)
    }
    
    func submitNewSegment() {
        let newSegment = Segment(id: UUID(), title: self.title, content: self.content)
        if var stage = stageController.stage {
            if var segments = stage.segments {
                segments.append(newSegment)
                print(segments)
                stage.segments = segments
            } else {
                stage.segments = [newSegment]
            }
            stageController.stage = stage
        }
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
