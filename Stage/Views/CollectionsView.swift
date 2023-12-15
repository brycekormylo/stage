//
//  CollectionsView.swift
//  Fotofolio
//
//  Created by Bryce on 10/24/23.
//

import SwiftUI

struct CollectionsView: View {
    
    @EnvironmentObject var theme: ThemeController
    @EnvironmentObject var stageController: StageController
    
    var body: some View {
        ZStack {
            if stageController.isEditEnabled {
                ZStack() {
                    NewCollectionButton()
                    ChangeCollectionOrderButton()
                        .padding(.bottom, 204)
                }
                .zIndex(10)
                .transition(.move(edge: .trailing))
            }
            ScrollView(showsIndicators: false) {
                Spacer(minLength: 64)
                LazyVStack {
                    Spacer(minLength: 64)
                    title
                        .padding(.bottom)
                    if let collectionData = stageController.stage?.collections {
                        ForEach(collectionData) { collection in
                            CollectionPreviewRow(collection)
                        }
                    }
                }
                .scrollTargetLayout()
                .padding(.bottom, 100)
            }
            .scrollTargetBehavior(.viewAligned)
            .zIndex(0)
        }
        .ignoresSafeArea()
    }
    
    var title: some View {
        HStack {
            Spacer()
            Text("Collections")
                .font(.custom("Quicksand-Medium", size: 32))
                .foregroundStyle(theme.text)
                .padding()
        }
    }
}

private struct NewCollectionButton: View {
    
    @EnvironmentObject var theme: ThemeController
    @EnvironmentObject var stageController: StageController
    
    @State var presentCollectionCreator: Bool = false
    
    var body: some View {
        ZStack {
            if stageController.isEditEnabled {
                if presentCollectionCreator {
                    VStack {
                        CollectionCreatorView(isPresented: $presentCollectionCreator)
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
                                presentCollectionCreator.toggle()
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
            .interactiveSpring(response: 0.45, dampingFraction: 0.69, blendDuration: 0.74), value: presentCollectionCreator)
    }
    
}

private struct CollectionCreatorView: View {
    
    @Binding var isPresented: Bool
    
    @EnvironmentObject var theme: ThemeController
    @EnvironmentObject var stageController: StageController
    
    @State var title: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("New Collection")
                    .font(.custom("Quicksand", size: 24))
                Spacer()
            }
            .padding(.horizontal)
            TextField("", text: $title)
                .placeholder(when: title.isEmpty) {
                    Text("Title")
                        .foregroundColor(theme.text.opacity(0.6))
                        .font(.custom("Quicksand", size: 18))
                }
                .font(.custom("Quicksand", size: 18))
                .padding()
                .background(theme.background)
                .cornerRadius(12)
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
                    submitNewCollection()
                    isPresented = false
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(theme.button)
                        Image(systemName: "checkmark")
                    }
                }
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
    
    func submitNewCollection() {
        
        let newCollection = ImageCollection(id: UUID(), title: title)
        
        if var stage = stageController.stage {
            if var collections = stage.collections {
                collections.append(newCollection)
                stage.collections = collections
            } else {
                stage.collections = [newCollection]
            }
            stageController.replaceStage(stage)
        }
    }
}

private struct CollectionPreviewRow: View {
    
    let collection: ImageCollection
    let imageHeight: CGFloat
    
    @EnvironmentObject var theme: ThemeController
    @EnvironmentObject var stageController: StageController
    @EnvironmentObject var remoteStorage: RemoteStorageController
    
    @State private var selectedImage: UIImage?
    @State private var isUploading: Bool = false
    
    @State var presentDetailView: Bool = false
    @State var presentEditView: Bool = false
    
    @State private var collectionData: ImageCollection = ImageCollection(id: UUID(), title: "Empty Collection")
    
    init(_ collection: ImageCollection, imageHeight: CGFloat = UIScreen.main.bounds.width * 0.88) {
        self.collection = collection
        self.imageHeight = imageHeight
        self.collectionData = collection
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 0) {
                Spacer()
                if stageController.isEditEnabled {
                    newCollectionImageButton
                    editButton
                }
                Text(collection.title)
                    .font(.custom("Quicksand-Medium", size: 18))
                    .foregroundStyle(theme.text)
                    .padding(.horizontal)
            }
            .frame(height: 36)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    if let content = collectionData.content {
                        ForEach(content, id: \.self) { imageURL in
                            SlidingImage(imageURL.url, .horizontal, startingHeight: imageHeight)
                        }
                        Spacer(minLength: 80)
                    }
                }
            }
            .safeAreaPadding(.horizontal, UIScreen.main.bounds.width * 0.06)
            .frame(height: imageHeight)
        }
        .padding(.bottom)
        .onTapGesture {
            if !stageController.isEditEnabled {
                presentDetailView.toggle()
            }
        }
        .fullScreenCover(isPresented: $presentDetailView) {
            CollectionDetailView(collection: collectionData)
        }
        .onChange(of: collectionData.title) {
            if var stage = stageController.stage, var collections = stage.collections {
                collections = collections.map { collection in
                    if collection.id != collectionData.id {
                        return collection
                    } else {
                        var modifiedCollection = collection
                        modifiedCollection.title = collectionData.title
                        return modifiedCollection
                    }
                }
                stage.collections = collections
                stageController.replaceStage(stage)
            }
        }
        .onChange(of: collectionData.content) {
            if var stage = stageController.stage, var collections = stage.collections {
                collections = collections.map { collection in
                    if collection.id != collectionData.id {
                        return collection
                    } else {
                        var modifiedCollection = collection
                        modifiedCollection.content = collectionData.content
                        return modifiedCollection
                    }
                }
                stage.collections = collections
                stageController.replaceStage(stage)
            }
        }
        .onChange(of: self.selectedImage) {
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
                        }
                        isUploading = false
                    case .failure(let error):
                        print("Image upload failed with error: \(error)")
                        isUploading = false
                    }
                }
            }
        }
        .onAppear {
            collectionData = collection
        }
    }
    
    var editButton: some View {
        Button(action: {
            presentEditView.toggle()
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(theme.backgroundAccent)
                    .strokeBorder(theme.button.opacity(0.4), lineWidth: 1.4)
                    .frame(width: 48, height: 48)
                Image(systemName: "pencil")
                    .foregroundStyle(theme.text)
            }
        }
        .scaleEffect(0.75)
        .fullScreenCover(isPresented: $presentEditView) {
            CollectionEditView(collectionData: $collectionData)
        }
    }
    
    @State private var presentImagePicker = false
    
    var newCollectionImageButton: some View {
        Button(action: {
            presentImagePicker.toggle()
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(theme.backgroundAccent)
                    .strokeBorder(theme.accent.opacity(0.4), lineWidth: 1.4)
                    .frame(width: 48, height: 48)
                Image(systemName: "plus")
                    .foregroundStyle(theme.text)
            }
        }
        .transition(.move(edge: .trailing))
        .scaleEffect(0.75)
        .sheet(isPresented: $presentImagePicker) {
            ImagePicker(image: self.$selectedImage)
        }
    }
}

private struct ChangeCollectionOrderButton: View {
    
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
            CollectionOrderEditView()
        }
    }
    
}
