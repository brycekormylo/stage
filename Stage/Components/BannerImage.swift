//
//  BannerImageView.swift
//  Fotofolio
//
//  Created by Bryce on 10/23/23.
//

import SwiftUI

struct BannerImage: View {
    
    @EnvironmentObject var imageController: ImageController
    @EnvironmentObject var theme: ThemeController
    @EnvironmentObject var remoteStorage: RemoteStorageController
    @EnvironmentObject var stageController: StageController
    
    @State private var isImagePickerPresented = false
    @State private var isUploading: Bool = false
    @State private var selectedImage: UIImage?
    @State private var imageURL: URL?
    
    
    var body: some View {
        VStack {
            AsyncImage(url: imageURL) { result in
                if let image = result.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .ignoresSafeArea()
                }
            }
            .overlay {
                ZStack {
                    theme.background.ignoresSafeArea()
                    ProgressView()
                        .foregroundStyle(theme.text)
                        .scaleEffect(2.0)
                }
                .opacity(isUploading ? 1.0 : 0.0)
            }
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
                            stage.header = URL(string: imageURL)!
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
        .onAppear {
            if imageURL == nil {
                imageURL = imageController.bannerURL
            }
        }
    }
}

#Preview {
    BannerImage()
}
