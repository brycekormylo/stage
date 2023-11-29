//
//  StyledButton.swift
//  Stage
//
//  Created by Bryce on 11/10/23.
//

import SwiftUI

struct StyledButton: ViewModifier {
    enum ButtonColor {
        case green
        case blue
        
        func backgroundColor() -> Color {
            switch self {
            case .green:
                return Color.green
            case .blue:
                return Color.blue
            }
        }
        
        func borderColor() -> Color {
            switch self {
            case .green:
                return Color(red: 7/255,
                             green: 171/255,
                             blue: 67/255)
            case .blue:
                return Color(red: 7/255,
                             green: 42/255,
                             blue: 171/255)
            }
        }
    }
    
    let buttonColor: ButtonColor
    
    func body(content: Content) -> some View {
        return content
            .foregroundColor(.white)
            .background(buttonColor.backgroundColor())
            .border(buttonColor.borderColor(),
                    width: 5)
    }
}
