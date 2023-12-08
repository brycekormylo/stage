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
            ScrollView {
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
            }
            .scrollTargetBehavior(.viewAligned)
            .zIndex(0)
            if stageController.isEditEnabled {
                VStack() {
                    Spacer()
                    NewCollectionButton()
                }
                .padding(.bottom, 120)
                .zIndex(1)
                .transition(.move(edge: .trailing))
            }
        }
        .animation(
            .interactiveSpring(response: 0.45, dampingFraction: 0.69, blendDuration: 0.74), value: stageController.isEditEnabled)
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
                                presentCollectionCreator.toggle()
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
            .interactiveSpring(response: 0.45, dampingFraction: 0.69, blendDuration: 0.74), value: presentCollectionCreator)
    }
    
}

struct CollectionCreatorView: View {
    
    @Binding var isPresented: Bool
    
    @EnvironmentObject var theme: ThemeController
    @EnvironmentObject var stageController: StageController
    
    @State var title: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("New Collection")
                    .font(.custom("Quicksand-Medium", size: 24))
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
                .background(theme.background)
                .cornerRadius(8)
            HStack {
                Spacer()
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark")
                }
                .modifier(CircleButton())
                Button(action: { 
                    submitNewCollection()
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
    
    func submitNewCollection() {
        
        let newCollection = ImageCollection(id: UUID(), title: title)
        
        if var stage = stageController.stage {
            print("Found stage")
            if var collections = stage.collections {
                collections.append(newCollection)
                print(collections)
                stage.collections = collections
            } else {
                stage.collections = [newCollection]
            }
            stageController.stage = stage
        }
    }
}

struct CollectionPreviewRow: View {
    
    let collection: ImageCollection
    let imageHeight: CGFloat
    
    @EnvironmentObject var theme: ThemeController
    @EnvironmentObject var stageController: StageController
    
    @State var presentDetailView: Bool = false
    @State var presentEditView: Bool = false
    
    @State private var collectionData: ImageCollection = ImageCollection(id: UUID(), title: "Empty Collection")
    
    init(_ collection: ImageCollection, imageHeight: CGFloat = 320) {
        self.collection = collection
        self.imageHeight = imageHeight
        self.collectionData = collection
    }
    
    var body: some View {
        VStack {
            if let title = collection.title {
                HStack(alignment: .center) {
                    Spacer()
                    if stageController.isEditEnabled {
                        editButton
                    }
                    Text(title)
                        .font(.custom("Quicksand-Medium", size: 18))
                        .foregroundStyle(theme.text)
                        .padding(.horizontal)
                }
            }
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    if let content = collectionData.content {
                        ForEach(content, id: \.self) { imageURL in
                            SlidingImage(imageURL.url, .horizontal, startingHeight: imageHeight)
                        }
                        Spacer(minLength: 80)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .safeAreaPadding(.horizontal, 35)
            .frame(height: imageHeight + 16)
        }
        .padding(.bottom)
        .onTapGesture {
            presentDetailView.toggle()
        }
        .fullScreenCover(isPresented: $presentDetailView) {
            CollectionDetailView()
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
                stageController.stage = stage
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
            Image(systemName: "pencil")
        }
        .foregroundStyle(theme.text.opacity(0.8))
        .modifier(CircleButton())
        .scaleEffect(0.75)
        .fullScreenCover(isPresented: $presentEditView) {
            CollectionEditView(collectionData: $collectionData)
        }
    }
}
