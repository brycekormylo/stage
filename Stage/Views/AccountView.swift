//
//  AccountView.swift
//  Stage
//
//  Created by Bryce on 11/3/23.
//

import SwiftUI

struct AccountView: View {
    
    @State var mode: Mode = .signIn
    @State var inEditMode: Bool = false
    @State var confirmed: Bool = false
//    @State var newUsername: String = ""
//    @State var username: String = ""
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var auth: AuthController
    @EnvironmentObject var theme: ThemeController
    @EnvironmentObject var stageController: StageController
    
    enum Mode {
        case signIn, signUp
    }
    
    var body: some View {
        createBody()
            .padding()
            .background(theme.background)
            .task {
                do {
                    guard let userId = auth.session?.user.id else {
                        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "Session is nil"])
                    }
//                    username = await supabase.getFromUserID(userId, column: "username")
                } catch {
                    print(error)
                }
            }
    }
    
    func createBody() -> some View {
        VStack(spacing: 20) {
            Spacer()
            HStack {
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .foregroundStyle(theme.text)
                        .background {
                            Circle()
                                .fill(theme.backgroundAccent)
                        }
                }
            }
            .padding()
            Text("Manage your account")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(theme.text)
                .padding(.bottom)
            
//            buildField("Username", content: username, editable: true)
            buildField("Email", content: auth.session?.user.email)
            buildField("User ID", content: auth.session?.user.id.uuidString)
            buildField("Creation Date", content: auth.session?.user.createdAt.formatted())
            
            buildButtons()
            Spacer()
        }
    }
    
    func buildField(_ fieldLabel: String, content: String? = "", editable: Bool = false) -> some View {
        ZStack {
            HStack {
                if inEditMode && editable {
//                    TextField(content ?? "Not found", text: $newUsername)
//                        .foregroundColor(theme.text)
//                        .padding()
                } else {
                    Text(content ?? "Not found")
                        .padding()
                    
                }
                Spacer()
            }
            .padding(.horizontal, 8)
            .frame(height: 64)
            .foregroundColor(theme.text)
            .background( BorderedCapsule() )
            FieldLabel(fieldLabel: fieldLabel)
                .offset(x: 84, y: -30)
        }
    }
    
    func buildButtons() -> some View {
        VStack {
            editButton()
            deleteAccountButton()
        }
        .padding(.top)
    }
    
    private func editButton() -> some View {
        HStack {
            Spacer()
            Button(action: {
                if !inEditMode {
                    inEditMode.toggle()
                } else {
//                    auth.setUsername(newUsername)
//                    username = newUsername
                    inEditMode.toggle()
                    dismiss()
                }
            }) {
                Text(inEditMode ? "Save" : "Edit Account Info")
                    .foregroundColor(theme.text)
                    .fontWeight(.bold)
                    .padding(16)
            }
            Spacer()
        }
        .background(
            BorderedCapsule(hasColoredBorder: false)
                .shadow(color: theme.shadow, radius: 6, x: 4, y: 4)
        )
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
        .background(BorderedCapsule())
    }
}

#Preview {
    AccountView()
}
