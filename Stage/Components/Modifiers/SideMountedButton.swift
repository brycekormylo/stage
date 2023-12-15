//
//  SideMountedButton.swift
//  Stage
//
//  Created by Bryce on 12/14/23.
//

import SwiftUI


struct SideMountedButton: ViewModifier {
    
    @EnvironmentObject var theme: ThemeController
    
    let color: Color
    @State var bordered: Bool
    
    init(_ color: Color, bordered: Bool = false) {
        self.color = color
        self.bordered = bordered
    }
    
    
    func body(content: Content) -> some View {
        HStack {
            Spacer()
            ZStack {
                if !bordered {
                    Rectangle()
                        .fill(color)
                        .cornerRadius(12, corners: [.topLeft, .bottomLeft])
                        .ignoresSafeArea()
                        .frame(width: 110)
                        .offset(x: 55)
                        .shadow(color: theme.shadow, radius: 4)
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(theme.backgroundAccent)
                        .strokeBorder(color, lineWidth: 1.4)
                        .cornerRadius(12, corners: [.topLeft, .bottomLeft])
                        .ignoresSafeArea()
                        .frame(width: 110)
                        .offset(x: 55)
                        .shadow(color: theme.shadow, radius: 4)
                }
                content
                    .foregroundStyle(theme.text)
                    .offset(x: 22)
            }
        }
        .frame(height: 55)
        .transition(.move(edge: .trailing))
    }
}

