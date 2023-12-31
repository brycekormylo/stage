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
    @EnvironmentObject var auth: AuthController
    
    @State var arrowUp: Bool = false
    @State var profileImageSize: CGFloat = 164
    
    @State var name: String = ""
    @State var profession: String = ""
    @State var intro: String = ""
    
    @State var segments: [Segment] = []
    
    func getProfileInfo() {
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
                stageController.replaceStage(stage)
                getProfileInfo()
            }
        }
    }
    
    var body: some View {
        ZStack {
            if stageController.isEditEnabled {
                editButtons
            }
            scrollView
        }
        .overlay(alignment: arrowUp ? .top : .bottom) {
            arrowButton
                .padding(arrowUp ? .top : .bottom, arrowUp ? 64 : 108)
        }
        .ignoresSafeArea()
        .onAppear {
            getProfileInfo()
        }
        .onChange(of: stageController.isEditEnabled) {
            if !stageController.isEditEnabled {
                updateProfileInfo()
            }
        }
        .onChange(of: $stageController.stage.wrappedValue?.name) {
            if let name = stageController.stage?.name {
                self.name = name
            }
            if let profession = stageController.stage?.profession {
                self.profession = profession
            }
            if let intro = stageController.stage?.intro {
                self.intro = intro
            }

        }
        .animation(
            .interactiveSpring(response: 0.45, dampingFraction: 0.69, blendDuration: 0.74), value: stageController.isEditEnabled)
    }
    
    var scrollView: some View {
        ScrollView(showsIndicators: false) {
            BannerImage()
                .frame(minHeight: UIScreen.main.bounds.height*0.391 + 48)
            VStack {
                HStack {
                    ProfileImage(size: profileImageSize)
                        .padding(.leading, 36)
                        .shadow(color: theme.shadow, radius: 8, x: 0, y: 0)
                    Spacer()
                }
                info
                if let segments = stageController.stage?.segments {
                    let formattedSegments = segments.filter({ $0.email == nil })
                    ForEach(formattedSegments.chunked(into: 3), id: \.self) { segmentChunk in
                        ProfilePageFrame {
                            ForEach(segmentChunk) { segment in
                                SegmentView(segment)
                            }
                            if segmentChunk.count < 3 {
                                ContactButton()
                            }
                        }
                    }
                    if formattedSegments.count % 3 == 0 {
                        ProfilePageFrame {
                            ContactButton()
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
                            .shadow(color: theme.shadow, radius: 8, x: 0, y: 0)
                        Spacer()
                    }
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
    }
    
    var editButtons: some View {
        ZStack() {
            SegmentOrderChangerButton()
                .padding(.bottom, 204)
            NewSegmentButton()
        }
        .zIndex(1)
        .transition(.move(edge: .trailing))
    }
    
    var arrowButton: some View {
        Image(systemName: arrowUp ? "chevron.up" : "chevron.down")
            .padding(.vertical, 8)
            .foregroundStyle(theme.text)
    }

    var info: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                EditableText(content: $name, placeholder: "Name")
            }
            .font(.custom("Quicksand-Medium", size: 36))
            .padding(.horizontal, 24)
            HStack {
                Spacer()
                EditableText(content: $profession, placeholder: "Profession")
                    .opacity(0.6)
            }
            .font(.custom("Quicksand-Light", size: 18))
            .padding(.horizontal, 24)
            Spacer()
            CaptionView {
                EditableText(content: $intro, placeholder: "Intro")
                    .padding(.vertical, 4)
            }
            .font(.custom("Quicksand-Medium", size: 18))
            Spacer()
            
        }
        .frame(height: (UIScreen.main.bounds.height-120)/3)
        .foregroundStyle(theme.text)
        .onChange(of: $name.wrappedValue) {
            if var stage = stageController.stage {
                stage.name = self.name
                stageController.replaceStage(stage)
            }
        }
        .onChange(of: $profession.wrappedValue) {
            if var stage = stageController.stage {
                stage.profession = self.profession
                stageController.replaceStage(stage)
            }
        }
        .onChange(of: $intro.wrappedValue) {
            if var stage = stageController.stage {
                stage.intro = self.intro
                stageController.replaceStage(stage)
            }
        }

    }
}

struct ProfilePageFrame<Content: View>: View {
    
    @EnvironmentObject var theme: ThemeController
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack {
            content
        }
        .frame(height: UIScreen.main.bounds.height - 240)
        .padding(.top, 260)

    }
}

struct CaptionView<Content: View>: View {

    @EnvironmentObject var theme: ThemeController
    @ViewBuilder var content: Content
    
    var body: some View {
        HStack {
            content
        }
        .padding(.horizontal)
        .frame(width: UIScreen.main.bounds.width, height: 80)
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
                EditableText(content: $segmentTitle, placeholder: "Segment Title")
                    .font(.custom("Quicksand-Medium", size: 24))
                    .padding()
                
            }
            Spacer()
            EditableText(content: $segmentContent, placeholder: "Segment Body")
                .font(.custom("Quicksand-Medium", size: 18))
                .padding(.horizontal, 4)

            
            Spacer()

        }
        .multilineTextAlignment(.center)
        .padding()
        .background {
            theme.backgroundAccent
                .opacity(0.1)
                .cornerRadius(12)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .frame(height: (UIScreen.main.bounds.height - 240)/3)
        .onChange(of: $segmentTitle.wrappedValue) {
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
                stageController.replaceStage(stage)
            }
        }
        .onChange(of: $segmentContent.wrappedValue) {
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
                stageController.replaceStage(stage)
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
                            .padding(.top, 120)
                        Spacer()
                    }
                    .ignoresSafeArea()
                    .background(.ultraThinMaterial.opacity(0.4))
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
                            .modifier(SideMountedButton(theme.button))
                        }
                        .padding(.bottom, 268)
                    }
                }
            }
        }
        .zIndex(10)
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
                .font(.custom("Quicksand-Medium", size: 18))
                .padding()
                .background(theme.background)
                .cornerRadius(12)
            TextEditor(text: $content)
                .placeholder(when: content.isEmpty) {
                    VStack {
                        Text("Content")
                            .foregroundColor(theme.text.opacity(0.6))
                            .font(.custom("Quicksand-Medium", size: 18))
                        Spacer()
                    }
                    .padding(2)
                }
                .font(.custom("Quicksand-Medium", size: 18))
                .padding()
                .scrollContentBackground(.hidden)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(theme.background)
                }
                .multilineTextAlignment(.leading)
                .frame(maxHeight: 120)
            HStack {
                Spacer()
                Button(action: { isPresented = false }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(theme.accent, lineWidth: 1.4)
                        Image(systemName: "xmark")
                    }
                }
                .frame(width: 55, height: 55)
                Button(action: {
                    submitNewSegment()
                    isPresented = false
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(theme.button)
                        Image(systemName: "checkmark")
                    }
                }
                .disabled(title.isEmpty)
                .frame(width: 110, height: 55)
                .padding(4)
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
                stage.segments = segments
            } else {
                stage.segments = [newSegment]
            }
            stageController.replaceStage(stage)
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
