//
//  InteractiveListView.swift
//  Stage
//
//  Created by Bryce on 11/4/23.
//

import SwiftUI
import Combine

struct CollectionEditView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var stageController: StageController
    @EnvironmentObject var theme: ThemeController
    @EnvironmentObject var remoteStorage: RemoteStorageController
    
    @StateObject private var viewModel = InteractiveListViewModel()
    @State private var selectedImage: UIImage?
    @State private var isUploading = false
    @State private var showConfirmation = false
    @State private var title: String = ""
    
    @Binding var collectionData: ImageCollection
    
    var body: some View {
        NavigationView {
            ZStack {
                theme.background.ignoresSafeArea()
                buttons
                    .zIndex(10)
                List {
                    ForEach(viewModel.orderedImages, id: \.self) { image in
                        HStack {
                            AsyncImage(url: image.url) { phase in
                                phase.image?
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 120)
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 12)
                                    )
                            }
                            Spacer()
                        }
                        .onDrag {
                            return NSItemProvider()
                        }
                        .frame(height: 120)
                        .listRowBackground(theme.background)
                    }
                    .onMove(perform: viewModel.move)
                    .onDelete(perform: viewModel.delete)
                }
                .padding(.top, 80)
                .listStyle(.plain)
                .environment(\.editMode, $viewModel.editMode)
                .foregroundStyle(theme.text)
            }
        }
        .onAppear {
            viewModel.editMode = .active
            title = collectionData.title
            if let images = collectionData.content {
                viewModel.setOrderedImages(to: images)
            }
        }
        .onDisappear {
            collectionData.title = self.title
            viewModel.editMode = .inactive
        }
        .onChange(of: viewModel.orderedImages) {
            var data = collectionData
            data.content = viewModel.orderedImages
            collectionData = data
            
        }
        .onChange(of: title) {
            print(title)
            collectionData.title = self.title
        }
        .onChange(of: self.$selectedImage.wrappedValue) {
            if let image = selectedImage {
                isUploading = true
                remoteStorage.uploadToImgBB(image) { result in
                    switch result {
                    case .success(let imageURL):
                        if collectionData.content == nil {
                            collectionData.content = []
                        }
                        if var content = collectionData.content {
                            let newImage = ID_URL(id: UUID(), url: URL(string: imageURL)!, order: content.count+1)
                            content.append(newImage)
                            collectionData.content = content
                            viewModel.setOrderedImages(to: content)
                        }
                        isUploading = false
                    case .failure(let error):
                        print("Image upload failed with error: \(error)")
                        isUploading = false
                    }
                }
            }
        }
    }
    
    
    var buttons: some View {
        ZStack {
            VStack {
                ZStack {
                    HStack {
                        TextField("", text: $title)
                            .font(.title2)
                            .foregroundStyle(theme.text)
                        Spacer()
                        deleteCollectionButton
                    }
                    .padding(.leading)
                    .padding(.trailing, 72)
                    HStack {
                        Spacer()
                        Button(action: { dismiss() }) {
                            Image(systemName: "checkmark")
                        }
                        .modifier(SideMountedButton(backgroundColor: theme.button))
                        .zIndex(2.0)
                    }
                }
                Spacer()
                
            }
        }
        .padding(.top)
    }
    
    var deleteCollectionButton: some View {
        Button(action: { showConfirmation.toggle() }) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(theme.backgroundAccent)
                    .frame(width: 55, height: 55)
                
                Image(systemName: "trash")
                    .foregroundStyle(.red)
            }
        }
        .confirmationDialog("Delete the entire collection?", isPresented: $showConfirmation) {
            Button("Delete entire collection?", role: .destructive) {
                if let collections = stageController.stage?.collections {
                    if var stage = stageController.stage {
                        stage.collections = collections.filter { $0.id != collectionData.id }
                        stageController.replaceStage(stage)
                    }
                }
            }
        } message: {
            Text("This cannot be undone")
        }
    }
}

