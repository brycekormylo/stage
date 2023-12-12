//
//  BannerImageView.swift
//  Fotofolio
//
//  Created by Bryce on 10/23/23.
//

import SwiftUI

struct BannerImage: View {
    
    @EnvironmentObject var theme: ThemeController
    @EnvironmentObject var remoteStorage: RemoteStorageController
    @EnvironmentObject var stageController: StageController
    
    @State private var isImagePickerPresented = false
    @State private var isUploading: Bool = false
    @State private var selectedImage: UIImage?
    @State private var imageURL: URL?
    
    
    var body: some View {
        StickyHeader {
            if imageURL != nil {
                CachedAsyncImage(url: imageURL)
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            } else {
                Rectangle()
            }
        }
        .onTapGesture {
            isImagePickerPresented.toggle()
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
                            stage.header = URL(string: imageURL)!
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
        .onChange(of: $stageController.stage.wrappedValue?.header) {
            if let bannerImage = stageController.stage?.header {
                imageURL = bannerImage
            }
        }
    }
}

#Preview {
    BannerImage()
}
