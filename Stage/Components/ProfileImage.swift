//
//  ProfileImage.swift
//  Fotofolio
//
//  Created by Bryce on 10/19/23.
//

import SwiftUI

struct ProfileImage: View {
    
    let size: CGFloat
    let clipShape: any Shape
    let stroke: CGFloat
    
    @EnvironmentObject var imageController: ImageController
    @EnvironmentObject var theme: ThemeController
    @EnvironmentObject var remoteStorage: RemoteStorageController
    
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?
    
    init(size: CGFloat = 100, clipShape: any Shape = Circle(), stroke: CGFloat = 16) {
        self.size = size
        self.clipShape = clipShape
        self.stroke = stroke
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(theme.background)
                .frame(width: size+stroke, height: size+stroke)
            AsyncImage(url: imageController.profileURL)
                .frame(width: size, height: size)
                .clipShape(Circle())
                .modifier(Editable(offsetX: size/2.4, offsetY: size/2.4))
                .onTapGesture {
                    self.isImagePickerPresented = true
                }
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(image: self.$selectedImage)
                }
                .onChange(of: $selectedImage.wrappedValue) {
                    if let image = selectedImage {
                        remoteStorage.uploadToImgBB(image) { result in
                            switch result {
                            case .success(let imageURL):
                                print("Image uploaded successfully. URL: \(imageURL)")
                                imageController.profileURL = URL(string: imageURL)!
                            case .failure(let error):
                                print("Image upload failed with error: \(error)")
                            }
                            
                        }
                    }
                }
        }
    }
}
