//
//  ImagePicker.swift
//  Fotofolio
//
//  Created by Bryce on 10/23/23.
//

import SwiftUI

struct ModeToggle: View {
    
    @EnvironmentObject var modeController: ModeController
    @EnvironmentObject var theme: ThemeController
    
    private var size: CGFloat = 48
    
    var body: some View {
        toggleButton
    }
    
    var toggleButton: some View {
        VStack {
            HStack {
                Spacer()
                ZStack {
                    Circle()
                        .fill(modeController.isEditEnabled ? theme.button : theme.background)
                    Image(systemName: modeController.isEditEnabled ? "checkmark" : "pencil")
                        .foregroundStyle(theme.text)
                }
                .frame(width: size, height: size)
                .onTapGesture { modeController.isEditEnabled.toggle() }
            }
            Spacer()
        }
        .ignoresSafeArea()
        .padding(.vertical, 4)
        .padding(.horizontal, 36)
    }
}

