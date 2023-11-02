//
//  AccountButton.swift
//  Stage
//
//  Created by Bryce on 11/2/23.
//

import SwiftUI

struct AccountButton: View {
    @EnvironmentObject var modeController: ModeController
    @EnvironmentObject var theme: ThemeController
    
    @State private var showPopover = false
    @State private var presentAccountView = false
    
    private var size: CGFloat = 48
    
    var body: some View {
        accountButton
            .fullScreenCover(isPresented: $presentAccountView) {
                AccountView()
            }
    }
    
    var accountButton: some View {
        VStack {
            HStack {
                Button(action: {
                    presentAccountView.toggle()
                }) {
                    ZStack {
                        Circle()
                            .fill(theme.background)
                        Image(systemName: "person")
                            .foregroundStyle(theme.text)
                    }
                    .frame(width: size, height: size)
                }
                Spacer()
            }
            Spacer()
        }
        .ignoresSafeArea()
        .padding(.vertical, 4)
        .padding(.horizontal, 36)
    }
}

#Preview {
    AccountButton()
}
