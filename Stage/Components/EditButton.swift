//
//  EditPopover.swift
//  Fotofolio
//
//  Created by Bryce on 10/23/23.
//

import SwiftUI

struct EditButton: View {
    
    @EnvironmentObject var imgBB: RemoteStorageController
    
    @State private var showPopover = false
    @State private var showImagePicker = false
    @State private var showFilePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @EnvironmentObject var theme: ThemeController
    
    private var size: CGFloat = 24
    
    var body: some View {
            Button(action: {
                showPopover = true
            }) {
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial.opacity(0.6))
                        .frame(width: size, height: size)
                    Image(systemName: "pencil")
                        .scaleEffect(0.8)
                        .foregroundStyle(theme.text)
                }
            }
            .popover(isPresented: $showPopover,
                     attachmentAnchor: .point(.bottom),
                     arrowEdge: .bottom
            ) {
                PopoverMenu {
                    Button("Choose from Photo Library") {
                        sourceType = .photoLibrary
                        showPopover = false
                        showImagePicker = true
                    }
                    Button("Choose from Files") {
                        sourceType = .savedPhotosAlbum
                        showPopover = false
                        showFilePicker = true
                    }
                }
                .presentationCompactAdaptation(.popover)

        }
    }
    
}

#Preview {
    EditButton()
}

