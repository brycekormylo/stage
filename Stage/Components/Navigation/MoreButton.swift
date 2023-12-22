//
//  MoreButton.swift
//  Stage
//
//  Created by Bryce on 11/8/23.
//

import SwiftUI

struct MoreButton: View {
    
    @EnvironmentObject var auth: AuthController
    @EnvironmentObject var stageController: StageController
    @EnvironmentObject var theme: ThemeController
    
    @State private var presentAccountView = false
    @State private var isExtended = false
    @State private var showConfirmation = false
    
    private var height: CGFloat = 55
    @State private var width: CGFloat = 55
    
    var body: some View {
        ZStack {
            if isExtended && !stageController.isEditEnabled {
                Rectangle()
                    .fill(.regularMaterial.opacity(0.6))
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isExtended = false
                        }
                    }
            }
            VStack {
                HStack {
                    Spacer()
                    if stageController.isEditEnabled {
                        Button(action: {
                            showConfirmation = true
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(theme.backgroundAccent)
                                    .strokeBorder(theme.accent, lineWidth: 1.4)
                                    .cornerRadius(12)
                                    .frame(width: height, height: height)
                                    .shadow(color: theme.shadow, radius: 4)
                                Image(systemName: "trash")
                                    .foregroundStyle(Color.red)
                            }
                        }
                        .confirmationDialog("Discard changes?", isPresented: $showConfirmation) {
                            Button("Discard changes?", role: .destructive) {
                                stageController.discardChanges()
                                stageController.isEditEnabled.toggle()
                                withAnimation(.interactiveSpring(response: 0.45, dampingFraction: 0.69, blendDuration: 0.74)) {
                                    self.isExtended = false
                                }
                            }
                        }
                        .padding(.horizontal, 4)
                        
                    }
                    HStack(spacing: 18) {
                        if isExtended && !stageController.isEditEnabled {
                            options
                        }
                        if stageController.isEditEnabled {
                            Text("Save")
                                .foregroundStyle(theme.text)
                                .font(.custom("Quicksand-Medium", size: 18))
                        }
                        Image(systemName: stageController.isEditEnabled ? "checkmark" : "ellipsis")
                            .foregroundStyle(theme.text)
                    }
                    .frame(height: height)
                    .padding(.horizontal)
                    .background {
                        Rectangle()
                            .fill(stageController.isEditEnabled ? theme.button : theme.backgroundAccent)
                            .cornerRadius(12, corners: [.topLeft, .bottomLeft])
                    }
                    .shadow(color: theme.shadow, radius: 4)
                    .onTapGesture {
                        withAnimation(.interactiveSpring(response: 0.45, dampingFraction: 0.69, blendDuration: 0.74)) {
                            if stageController.isEditEnabled {
                                stageController.submitChanges()
                            }
                            isExtended.toggle()
                        }
                    }
                }
                Spacer()
            }
            .shadow(color: theme.shadow, radius: 8, x: 0, y: 0)
            .ignoresSafeArea()
            .padding(.vertical, 4)
        }
    }
    
    var options: some View {
        HStack(spacing: 18) {
            accountButton
            themeButton
            editButton
        }
        .foregroundStyle(theme.text)
    }
    

    
    var themeButton: some View {
        Button(action: {
            theme.toggleTheme()
        }) {
            Image(systemName: theme.isDarkMode ? "sun.max" : "moon")
        }
    }
    
    var accountButton: some View {
        Button(action: {
            if auth.authChangeEvent != .signedIn {
                stageController.clearStage()
            } else {
                presentAccountView.toggle()
            }
        }) {
            Image(systemName: auth.authChangeEvent == .signedIn ? "person" : "xmark")
        }
        .sheet(
            isPresented: $presentAccountView,
            onDismiss: {
                withAnimation(.interactiveSpring(response: 0.34, dampingFraction: 0.69, blendDuration: 0.69)) {
                    isExtended = false
                }
        }) {
            if auth.authChangeEvent == .signedIn {
                AccountView()
            } else {
                AuthView()
            }
        }
    }
    
    var editButton: some View {
        Button(action: {
            if auth.authChangeEvent == .signedIn {
                withAnimation(.interactiveSpring(response: 0.34, dampingFraction: 0.69, blendDuration: 0.69)) {
                        stageController.isEditEnabled.toggle()
                }
            }
        }) {
            Image(systemName: "pencil")
                .opacity(auth.authChangeEvent == .signedIn ? 1.0 : 0.4)
        }
    }

}
