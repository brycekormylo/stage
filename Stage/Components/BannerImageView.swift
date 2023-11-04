//
//  BannerImageView.swift
//  Fotofolio
//
//  Created by Bryce on 10/23/23.
//

import SwiftUI

struct BannerImageView: View {
    
    @EnvironmentObject var imageController: ImageController
    @EnvironmentObject var theme: ThemeController
    @EnvironmentObject var remoteStorage: RemoteStorageController
    @EnvironmentObject var stageController: StageController
    @EnvironmentObject var modeController: ModeController
    
    @State private var isImagePickerPresented = false
    @State private var isUploading: Bool = false
    @State private var selectedImage: UIImage?
    @State private var imageURL: URL?
    
    var body: some View {
        VStack {
            AsyncImage(url: stageController.stage?.header ?? imageController.bannerURL) { result in
                result.image?
                    .resizable()
                    .ignoresSafeArea()
            }
            .onTapGesture {
                self.isImagePickerPresented = true
            }
            .disabled(!modeController.isEditEnabled)
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(image: self.$selectedImage)
            }
            .onChange(of: $selectedImage.wrappedValue) {
                if let image = selectedImage {
                    isUploading = true
                    remoteStorage.uploadToImgBB(image) { result in
                        switch result {
                        case .success(let imageURL):
                            print("Image uploaded successfully. URL: \(imageURL)")
                            stageController.stage?.setHeader(url: URL(string: imageURL)!)
                            self.imageURL = stageController.stage?.header
                            isUploading = false
                        case .failure(let error):
                            print("Image upload failed with error: \(error)")
                            isUploading = false
                        }
                    }
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
            Spacer()
        }
        .frame(height: 320)
    }
}

#Preview {
    BannerImageView()
}
