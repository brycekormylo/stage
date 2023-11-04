//
//  EditPopover.swift
//  Fotofolio
//
//  Created by Bryce on 10/23/23.
//

import SwiftUI

struct EditPopover<Content: View>: View {
    
    @EnvironmentObject var theme: ThemeController
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack(spacing: 18) {
            content
        }
        .foregroundStyle(theme.text)
        .padding()
        .padding(.vertical, 4)
        .frame(width: 240)
        .background(theme.background)
    }
}

struct EditButton: View {
    
    @EnvironmentObject var imgBB: RemoteStorageController
    @EnvironmentObject var theme: ThemeController
    
    @State private var showPopover = false
    @State private var showImagePicker = false
    @State private var showFilePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    
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
            EditPopover {
                Button(action: {
                    sourceType = .photoLibrary
                    showPopover = false
                    showImagePicker = true
                }) { Text("Choose from Library")}
                Divider()
                    .overlay(theme.text)
                Button(action: {
                    sourceType = .photoLibrary
                    showPopover = false
                    showImagePicker = true
                }) { Text("Choose from Files")}
            }
            .presentationCompactAdaptation(.popover)
        }
    }
}

#Preview {
    EditButton()
}

