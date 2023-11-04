//
//  ModeController.swift
//  Fotofolio
//
//  Created by Bryce on 10/27/23.
//

import SwiftUI

enum AppMode {
    case edit
    case viewOnly
}

class ModeController: ObservableObject {

    @Published var isEditEnabled: Bool = false
    
}

//struct Editable: ViewModifier {
//    
//    @EnvironmentObject private var modeController: ModeController
//    @State private var opacity: CGFloat = 0.0
//    @Binding var selectedImage: UIImage?
//    var offsetX: CGFloat
//    var offsetY: CGFloat
//    
//    func body(content: Content) -> some View {
//        ZStack {
//            content
//            EditButton()
//                .offset(CGSize(width: offsetX, height: offsetY))
//                .opacity(opacity)
//                .onChange(of: modeController.isEditEnabled) {
//                    withAnimation(.easeInOut(duration: 0.2)) {
//                        opacity = modeController.isEditEnabled ? 1.0 : 0.0
//                    }
//                }
//        }
//    }
//}
