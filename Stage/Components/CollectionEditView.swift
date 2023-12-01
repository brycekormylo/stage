//
//  InteractiveListView.swift
//  Stage
//
//  Created by Bryce on 11/4/23.
//

import SwiftUI
import Combine

//class InteractiveListViewModel: ObservableObject {
//    
//    @Published var orderedImages: [ID_URL] = []
//    @Published var editMode: EditMode = .inactive
//    
//    func setOrderedImages(to urls: [ID_URL]) {
//        self.orderedImages = urls
//    }
//    
//    func move(from source: IndexSet, to destination: Int) {
//        orderedImages.move(fromOffsets: source, toOffset: destination)
//    }
//    
//    func delete(at offsets: IndexSet) {
//        orderedImages.remove(atOffsets: offsets)
//    }
//}


struct CollectionEditView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var stageController: StageController
    @EnvironmentObject var theme: ThemeController
    @EnvironmentObject var remoteStorage: RemoteStorageController
    
    @StateObject private var viewModel = InteractiveListViewModel()
    @State private var selectedImage: UIImage?
    @State private var isUploading = false
    
    @Binding var collectionData: ImageCollection
    
    var body: some View {
        NavigationView {
            ZStack {
                theme.background.ignoresSafeArea()
                buttons
                List {
                    ForEach(viewModel.orderedImages, id: \.self) { image in
                        HStack {
                            AsyncImage(url: image.url) { phase in
                                phase.image?
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
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
            if let images = collectionData.content {
                viewModel.setOrderedImages(to: images)
            }
        }
        .onDisappear {
            viewModel.editMode = .inactive
        }
        .onChange(of: viewModel.orderedImages) {
            var data = collectionData
            data.content = viewModel.orderedImages
            collectionData = data
            
        }
        .onChange(of: $selectedImage.wrappedValue) {
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
        VStack {
            HStack {
                Text("Edit Collection")
                    .font(.title2)
                    .foregroundStyle(theme.text)
                Spacer()
                NewImageButton(selectedImage: $selectedImage)
                Button(action: { dismiss() }) {
                    Image(systemName: "checkmark")
                }
                .modifier(CircleButton())
                .zIndex(2.0)
            }
            Spacer()
        }
        .padding(.top, 56)
        .padding(.horizontal, 24)
        .ignoresSafeArea()
    }
}