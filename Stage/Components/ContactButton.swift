//
//  ContactButton.swift
//  Fotofolio
//
//  Created by Bryce on 10/23/23.
//

import SwiftUI

struct ContactButton: View {
    
    @EnvironmentObject var theme: ThemeController
    @State var presentContactInfo: Bool = false
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Button(action: { presentContactInfo.toggle() }) {
                    Text("Contact")
                        .font(.custom("Quicksand-Medium", size: 24))
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(theme.button)
                        }
                        .foregroundStyle(theme.text)
                }
                Spacer()
            }
        }
        .frame(height: (UIScreen.main.bounds.height - 240)/3)
        .sheet(isPresented: $presentContactInfo) {
            ContactSheet()
        }
        
    }
}

struct ContactSheet: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var theme: ThemeController
    
    var body: some View {
        ZStack {
            theme.background.ignoresSafeArea()
            Text("Contact info")
                .font(.custom("Quicksand-Medium", size: 24))
                .foregroundStyle(theme.text)
        }
        
    }
    
}

#Preview {
    ContactButton()
}
