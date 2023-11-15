//
//  HighlightsView.swift
//  Fotofolio
//
//  Created by Bryce on 10/24/23.
//

import SwiftUI
import Combine

struct HighlightsView: View {
    
    @EnvironmentObject var theme: ThemeController
    @EnvironmentObject var stageController: StageController
    
    @State private var presentReorderSheet = false
    @State private var contents: [ID_URL] = []
    
    let imageHeight: CGFloat
    
    init(imageHeight: CGFloat = 300) {
        self.imageHeight = imageHeight
    }
    
    func updateContents() {
        print("update called")
        if let highlights = stageController.stage?.highlights {
            self.contents = highlights
        }
        
        stageController.stage?.highlights = contents
    }
    
    var body: some View {
        ZStack {
            if stageController.isEditEnabled {
                reorderButton
                    .zIndex(2.0)
            }
            ScrollView {
                LazyVStack {
                    Spacer(minLength: 64)
                    HStack {
                        Spacer()
                        Text("Highlights")
                            .font(.title)
                    }
                    .padding()
                    .padding(.bottom)
                    if let highlights = stageController.stage?.highlights {
                        ForEach(highlights, id: \.self) { imageURL in
                            SlidingImage(imageURL.url, startingHeight: imageHeight)
                        }
                    }
                    Spacer(minLength: 240)
                }
            }
        }
        .foregroundStyle(theme.text)
        
    }
    
    var reorderButton: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: { presentReorderSheet.toggle() }) {
                    Image(systemName: "arrow.up.arrow.down")
                }
                .modifier(CircleButton())
            }
            .padding()
            .padding(.bottom, 80)
        }
        .fullScreenCover(isPresented: $presentReorderSheet) {
            InteractiveListView(contents: $contents)
                .onAppear {
                    updateContents()
                }
        }
    }
}
