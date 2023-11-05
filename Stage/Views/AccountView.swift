//
//  AccountView.swift
//  Stage
//
//  Created by Bryce on 11/3/23.
//

import SwiftUI

struct AccountView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var auth: AuthController
    @EnvironmentObject var theme: ThemeController
    @EnvironmentObject var stageController: StageController
    
    @State var mode: Mode = .signIn
    @State var inEditMode: Bool = false
    @State var confirmed: Bool = false
    
    enum Mode {
        case signIn, signUp
    }
    
    var body: some View {
        createBody()
            .padding()
            .background(theme.background)
    }
    
    func createBody() -> some View {
        VStack(spacing: 20) {
            HStack {
                Text("Manage account")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(theme.text)
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .foregroundStyle(theme.text)
                }
                .modifier(CircleButton())
            }
            .padding()
            buildField("Email", content: auth.session?.user.email)
            buildField("Creation Date", content: auth.session?.user.createdAt.formatted())
            buildButtons()
            Spacer()
        }
    }
    
    func buildField(_ fieldLabel: String, content: String? = "", editable: Bool = false) -> some View {
        ZStack {
            HStack {
                Text(content ?? "Not found")
                    .padding(.horizontal, 8)
                    .frame(height: 64)
                    .foregroundColor(theme.text)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            HStack {
                Text(fieldLabel)
                    .foregroundColor(theme.text.opacity(0.6))
                    .offset(x: 0, y: -30)
                Spacer()
            }
        }
    }
    
    func buildButtons() -> some View {
        VStack {
            logoutButton()
            deleteAccountButton()
        }
        .padding(.top)
    }
    
    private func logoutButton() -> some View {
        HStack {
            Spacer()
            Button(action: {
                auth.logout()
            }) {
                Text("Log out")
                    .padding(16)
                    .foregroundColor(theme.text)
            }
            Spacer()
        }
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(theme.button)
                .shadow(color: theme.shadow, radius: 6, x: 4, y: 4)
        }
    }
    
    private func deleteAccountButton() -> some View {
        HStack {
            Spacer()
            Button(action: {
                if confirmed {
                    auth.deleteAccount()
                    dismiss()
                } else {
                    confirmed.toggle()
                }
            }) {
                Text(confirmed ? "Are you sure?" : "Delete Account")
                    .foregroundColor(.red)
                    .padding(16)
                    .foregroundColor(theme.text)
            }
            Spacer()
        }
        .background {
            RoundedRectangle(cornerRadius: 8)
                .fill(theme.backgroundAccent)
                .strokeBorder(theme.button)
                .shadow(color: theme.shadow, radius: 6, x: 4, y: 4)
        }
    }
}

#Preview {
    AccountView()
}
