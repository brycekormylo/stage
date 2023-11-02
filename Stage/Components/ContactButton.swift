//
//  ContactButton.swift
//  Fotofolio
//
//  Created by Bryce on 10/23/23.
//

import SwiftUI

struct ContactButton: View {
    
    @EnvironmentObject var theme: ThemeController
    
    var body: some View {
        Button(action: {}) {
            Text("Contact")
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(theme.button)
                }
            
                .foregroundStyle(theme.text)
        }
    }
}

#Preview {
    ContactButton()
}
