//
//  ProfileImage.swift
//  Fotofolio
//
//  Created by Bryce on 10/19/23.
//

import SwiftUI

struct ProfileImage: View {
    
    let size: CGFloat
    let stroke: CGFloat
    
    @EnvironmentObject var theme: ThemeController
    @EnvironmentObject var remoteStorage: RemoteStorageController
    @EnvironmentObject var stageController: StageController
    
    @State private var isImagePickerPresented = false
    @State private var isUploading: Bool = false
    @State private var selectedImage: UIImage?
    @State private var imageURL: URL?
    
    init(size: CGFloat = 100, stroke: CGFloat = 12) {
        self.size = size
        self.stroke = stroke
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(theme.background)
                .frame(width: size+stroke, height: size+stroke)
            CachedAsyncImage(url: imageURL)
                .scaledToFill()
                .frame(width: size, height: size)
                .clipShape(Circle())
        }
        .onTapGesture {
            self.isImagePickerPresented = true
        }
        .disabled(!stageController.isEditEnabled)
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(image: self.$selectedImage)
        }
        .onChange(of: $selectedImage.wrappedValue) {
            if let image = selectedImage {
                isUploading = true
                remoteStorage.uploadToImgBB(image) { result in
                    switch result {
                    case .success(let imageURL):
                        self.imageURL = URL(string: imageURL)!
                        if var stage = stageController.stage {
                            stage.profileImage = URL(string: imageURL)!
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
        .onChange(of: stageController.stage) {
            if let profileImage = stageController.stage?.profileImage {
                imageURL = profileImage
            }
        }
        .task {
            if let profileImage = stageController.stage?.profileImage {
                imageURL = profileImage
            }
        }
    }
    
    
    
}
