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
    
    init(imageHeight: CGFloat = 300) {
        self.imageHeight = imageHeight
    }
    
    func updateContents() {
        if let highlights = stageController.stage?.highlights {
            self.contents = highlights
        }
    }
    
    var body: some View {
        ZStack {
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
            if stageController.isEditEnabled {
                HStack {
                    Spacer()
                    VStack() {
                        Spacer()
                        NewImageButton(selectedImage: self.$selectedImage)
                        ChangeHighlightOrderButton()
                    }
                    .padding(.bottom, 120)
                }
                .padding()
            }
        }
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
                            Task {
                                await stageController.updateStage(stage)
                            }
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
    
    @State private var presentReorderSheet = false

    var body: some View {
        Button(action: { presentReorderSheet.toggle() }) {
            Image(systemName: "arrow.up.arrow.down")
        }
        .modifier(CircleButton())
        .fullScreenCover(isPresented: $presentReorderSheet) {
            InteractiveListView()
        }
    }
    
}

private struct NewImageButton: View {
    
    @Binding var selectedImage: UIImage?
    @State private var presentImagePicker = false
    
    var body: some View {
        Button(action: { presentImagePicker.toggle() }) {
            Image(systemName: "plus")
        }
        .modifier(CircleButton())
        .sheet(isPresented: $presentImagePicker) {
            ImagePicker(image: $selectedImage)
        }
    }
    
}
