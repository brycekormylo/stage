//
//  SettingsButton.swift
//  Stage
//
//  Created by Bryce on 11/2/23.
//

import SwiftUI

struct SettingsButton: View {
    @EnvironmentObject var modeController: ModeController
    @EnvironmentObject var theme: ThemeController
    
    @State private var showPopover = false
    
    private var height: CGFloat = 48
    @State private var width: CGFloat = 48
    
    var body: some View {
        settingsButton
    }
    
    var settingsButton: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    modeController.isEditEnabled ? modeController.isEditEnabled.toggle() : showPopover.toggle()
                }) {
                    ZStack {
                        Capsule()
                            .fill(modeController.isEditEnabled ? theme.button : theme.background)
                        Image(systemName: modeController.isEditEnabled ? "checkmark" : "gearshape")
                            .foregroundStyle(theme.text)
                    }
                    .frame(width: width, height: height)
                }
                .popover(isPresented: $showPopover,
                         attachmentAnchor: .point(.bottom),
                         arrowEdge: .bottom
                ) { SettingsPopover() }
            }
            Spacer()
        }
        .onChange(of: modeController.isEditEnabled) {
            withAnimation {
                width = modeController.isEditEnabled ? width*2.4 : width/2.4
            }
        }
        .ignoresSafeArea()
        .padding(.vertical, 4)
        .padding(.horizontal, 36)
    }
}

struct SettingsPopover: View {
    
    @EnvironmentObject private var theme: ThemeController
    @EnvironmentObject private var modeController: ModeController
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        PopoverMenu {
            Button(action: { theme.toggleTheme() }) {
                HStack {
                    Text(theme.isDarkMode ? "Dark Mode" : "Light mode")
                    Spacer()
                    Image(systemName: theme.isDarkMode ? "moon" : "sun.max")
                        .foregroundStyle(theme.text)
                }
                .padding(.horizontal, 8)
            }
            Divider()
                .overlay(theme.text)
            Button(action: {
                modeController.isEditEnabled.toggle()
                dismiss()
            }) {
                HStack {
                    Text("Edit stage")
                    Spacer()
                    Image(systemName: "pencil")
                }
                .padding(.horizontal)
            }
        }
        .presentationCompactAdaptation(.popover)
    }
}

struct PopoverMenu<Content: View>: View {
    
    @EnvironmentObject var theme: ThemeController
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack(spacing: 18) {
            content
        }
        .foregroundStyle(theme.text)
        .padding()
        .padding(.vertical, 4)
        .frame(width: 180)
        .background(theme.background)
    }
}

