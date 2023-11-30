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
    
    private var height: CGFloat = 48
    @State private var width: CGFloat = 48
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                HStack(spacing: 18) {
                    if isExtended && !stageController.isEditEnabled {
                        options
                    }
                    if stageController.isEditEnabled {
                        Text("Save")
                            .foregroundStyle(theme.text)
                    }
                    Image(systemName: stageController.isEditEnabled ? "checkmark" : "ellipsis")
                        .foregroundStyle(theme.text)
                }
                .frame(height: height)
                .padding(.horizontal)
                .background {
                    Capsule()
                        .fill(stageController.isEditEnabled ? theme.button : theme.backgroundAccent)
                }
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
        .ignoresSafeArea()
        .padding(.vertical, 4)
        .padding(.horizontal, 36)
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
            presentAccountView.toggle()
        }) {
            Image(systemName: "person")
        }
        .sheet(isPresented: $presentAccountView) {
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
