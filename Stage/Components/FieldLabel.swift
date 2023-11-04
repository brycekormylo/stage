//
//  FieldLabel.swift
//  Stage
//
//  Created by Bryce on 11/2/23.
//
import SwiftUI

struct FieldLabel: View {
    
    let fieldLabel: String
    @EnvironmentObject var theme: ThemeController
    
    var body: some View {
        Text(fieldLabel)
            .foregroundColor(theme.text.opacity(0.6))
            .font(.subheadline)
            .padding(.horizontal)
        //            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [theme.background, theme.backgroundAccent]),
                            startPoint: UnitPoint(x: 0, y: 0.4),
                            endPoint: UnitPoint(x: 0, y: 0.6)
                        )
                    )
            )
    }
}
