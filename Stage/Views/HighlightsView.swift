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
    @EnvironmentObject var remoteStorage: RemoteStorageController
    
    @State private var isUploading = false
    @State private var presentReorderSheet = false
    @State private var contents: [ID_URL] = []
    @State private var selectedImage: UIImage?
    
    let imageHeight: CGFloat
    
    init(imageHeight: CGFloat = UIScreen.main.bounds.width) {
        self.imageHeight = imageHeight
    }
    
    func updateContents() {
        if let highlights = stageController.stage?.highlights {
            self.contents = highlights
        }
    }
    
    var body: some View {
        ZStack {
            if stageController.isEditEnabled {
                ZStack {
                    NewImageButton(selectedImage: self.$selectedImage)
                        .padding(.bottom, 234)
                    ChangeHighlightOrderButton()
                        .padding(.bottom, 170)
                }
                .zIndex(1)
                .transition(.move(edge: .trailing))
            }
            ScrollView {
                LazyVStack {
                    Spacer(minLength: 64)
                    HStack {
                        Spacer()
                        Text("Highlights")
                            .font(.custom("Quicksand-Medium", size: 32))
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
            .zIndex(0)
        }
        .animation(
            .interactiveSpring(response: 0.45, dampingFraction: 0.69, blendDuration: 0.74), value: stageController.isEditEnabled)
        .foregroundStyle(theme.text)
        .onAppear {
            updateContents()
        }
        .onChange(of: $selectedImage.wrappedValue) {
            if let image = selectedImage {
                isUploading = true
                remoteStorage.uploadToImgBB(image) { result in
                    switch result {
                    case .success(let imageURL):
                        self.contents.append(ID_URL(id: UUID(), url: URL(string: imageURL)!, order: contents.count+1))
                        if var stage = stageController.stage {
                            stage.highlights = self.contents
                            stageController.replaceStage(stage)
                        }
                        isUploading = false
                    case .failure(let error):
                        print("Image upload failed with error: \(error)")
                        isUploading = false
                    }
                }
            }
        }
        .onChange(of: stageController.isEditEnabled) {
            updateContents()
        }
    }
}

private struct ChangeHighlightOrderButton: View {
    
    @EnvironmentObject var stageController: StageController
    @EnvironmentObject var theme: ThemeController
    
    @State private var presentReorderSheet = false

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: { presentReorderSheet.toggle() }) {
                    Image(systemName: "arrow.up.arrow.down")
                        .foregroundStyle(theme.text)
                }
                .modifier(SideMountedButton(theme.accent, bordered: true))
                .transition(.move(edge: .trailing))
            }
        }
        .fullScreenCover(isPresented: $presentReorderSheet) {
            HighlightEditView()
        }
    }
    
}

struct NewImageButton: View {
    
    @EnvironmentObject var theme: ThemeController
    
    @Binding var selectedImage: UIImage?
    @State private var presentImagePicker = false
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: { presentImagePicker.toggle() }) {
                    Image(systemName: "plus")
                        .foregroundStyle(theme.text)
                    }
                .modifier(SideMountedButton(theme.button))
            }

        }
        .sheet(isPresented: $presentImagePicker) {
            ImagePicker(image: self.$selectedImage)
        }
    }
    
}
