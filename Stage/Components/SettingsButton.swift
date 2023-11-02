//
//  SettingsButton.swift
//  Stage
//
//  Created by Bryce on 11/2/23.
//

import SwiftUI

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

struct SettingsButton: View {
    @EnvironmentObject var modeController: ModeController
    @EnvironmentObject var theme: ThemeController
    
    @State private var showPopover = false
    
    private var size: CGFloat = 48
    
    var body: some View {
        settingsButton
    }
    
    var settingsButton: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    showPopover.toggle()
                }) {
                    ZStack {
                        Circle()
                            .fill(modeController.isEditEnabled ? theme.button : theme.background)
                        Image(systemName: modeController.isEditEnabled ? "checkmark" : "gearshape")
                            .foregroundStyle(theme.text)
                    }
                    .frame(width: size, height: size)
                }
                .popover(isPresented: $showPopover,
                         attachmentAnchor: .point(.bottom),
                         arrowEdge: .bottom
                ) { popover }
            }
            Spacer()
        }

        .ignoresSafeArea()
        .padding(.vertical, 4)
        .padding(.horizontal, 36)
    }
    
    var popover: some View {
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
            Button(action: { modeController.isEditEnabled.toggle() }) {
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
