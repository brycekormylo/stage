//
//  CircleButton.swift
//  Stage
//
//  Created by Bryce on 11/4/23.
//

import SwiftUI

struct CircleButton: ViewModifier {
    
    @EnvironmentObject var theme: ThemeController
    
    private var size: CGFloat = 48
    
    func body(content: Content) -> some View {
        ZStack {
            Circle()
                .fill(theme.backgroundAccent)
            content
                .foregroundStyle(theme.text)
        }
        .frame(width: size, height: size)
    }
}

struct SideMountedButton: ViewModifier {
    @EnvironmentObject var theme: ThemeController
    
    let backgroundColor: Color
    
    func body(content: Content) -> some View {
        HStack {
            Spacer()
            ZStack {
                Rectangle()
                    .fill(backgroundColor)
                    .cornerRadius(12, corners: [.topLeft, .bottomLeft])
                    .ignoresSafeArea()
                    .frame(width: 110)
                    .offset(x: 55)
                    .shadow(color: theme.background.opacity(0.6), radius: 4)
                content
                    .foregroundStyle(theme.text)
                    .offset(x: 22)
            }
        }
        .frame(height: 55)
        .transition(.move(edge: .trailing))
    }
}
