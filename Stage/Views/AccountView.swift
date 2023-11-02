//
//  AccountView.swift
//  Fotofolio
//
//  Created by Bryce on 11/2/23.
//

import SwiftUI

struct AccountView: View {
    
    @EnvironmentObject var auth: AuthController
    @EnvironmentObject var theme: ThemeController
    
    @Environment(\.dismiss) private var dismiss
    
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        ZStack {
            theme.background.ignoresSafeArea()
            VStack(spacing: 24) {
                HStack {
                    Spacer()
                    dismissButton
                }
                .padding()
                Text("Account")
                TextField("Email", text: $email)
                TextField("Password", text: $password)
                loginButton
            }
            .foregroundStyle(theme.text)
        }
    }
    
    var loginButton: some View {
        Button(action: {
            dismiss()
//            Task {
//                try await auth.login(email: email, password: password)
//            }
        }) {
            Text("Submit")
                .padding()
                .background(theme.background)
        }
    }
    
    var dismissButton: some View {
        Button(action: {
            dismiss()
        }) {
            ZStack {
                Circle()
                    .fill(theme.button)
                    .frame(height: 36)
                Image(systemName: "xmark")
            }
        }
    }
}
