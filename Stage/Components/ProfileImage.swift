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
    
    @EnvironmentObject var imageController: ImageController
    @EnvironmentObject var theme: ThemeController
    @EnvironmentObject var remoteStorage: RemoteStorageController
    @EnvironmentObject var stageController: StageController
    @EnvironmentObject var modeController: ModeController
    
    @State private var isImagePickerPresented = false
    @State private var isUploading: Bool = false
    @State private var selectedImage: UIImage?
    @State private var imageURL: URL?
    
    init(size: CGFloat = 100, stroke: CGFloat = 16) {
        self.size = size
        self.stroke = stroke
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(theme.background)
                .frame(width: size+stroke, height: size+stroke)
            AsyncImage(url: stageController.stage?.profileImage) { phase in
                phase.image?
                    .resizable()
                    .scaledToFill()
                    .frame(width: size, height: size)
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
                                stageController.stage?.setProfileImage(url: URL(string: imageURL)!)
                                self.imageURL = stageController.stage?.profileImage
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
                .clipShape(Circle())
        }
    }
}
