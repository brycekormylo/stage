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
