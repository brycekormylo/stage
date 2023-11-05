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
    @EnvironmentObject var auth: AuthController
    
    @State private var showPopover = false
    @State private var presentAccountView = false
    
    
    var body: some View {
        accountButton
            .sheet(isPresented: $presentAccountView) {
                if auth.authChangeEvent == .signedIn {
                    AccountView()
                } else {
                    AuthView()
                }
            }
    }
    
    var accountButton: some View {
        VStack {
            HStack {
                Button(action: {
                    presentAccountView.toggle()
                }) {
                    Image(systemName: "person")
                }
                .modifier(CircleButton())
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
