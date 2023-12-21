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
    
    @State var stageName: String = "cutestuff"
    @State var presentUsernameChanger: Bool = false
    
    enum Mode {
        case signIn, signUp
    }
    
    var body: some View {
        createBody()
            .background(theme.background)
            .task {
                if let stageID = stageController.stage?.id {
                    print(stageID)
                    await auth.syncStageName(for: stageID)
                    if let stageName = auth.stageName {
                        self.stageName = stageName
                    } else {
                        self.stageName = ""
                    }
                }
            }
    }
    
    func createBody() -> some View {
        VStack {
            HStack {
                Text("Account")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(theme.text)
                    .padding()
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .foregroundStyle(theme.text)
                }
                .modifier(SideMountedButton(theme.button))
            }
            .padding(.top, 36)
            VStack(spacing: 20) {
                buildField("Email", content: auth.session?.user.email)
                buildField("Creation Date", content: auth.session?.user.createdAt.formatted())
                buildUsernameChanger("Stage Name")
                buildButtons()
                Spacer()
            }
            .padding()
        }
        .font(.custom("Quicksand-Medium", size: 18))
    }
    
    func buildUsernameChanger(_ fieldLabel: String, editable: Bool = false) -> some View {
        ZStack {
            HStack {
                Button(action: { presentUsernameChanger = true }) {
                    HStack {
                        if stageName != "" {
                            Text("@\(stageName.lowercased())")
                        } else {
                            Text("Tap to set up")
                        }
                        Image(systemName: "pencil")
                            .scaleEffect(0.8)
                            .padding(8)
                            .background {
                                Circle()
                                    .strokeBorder(theme.button.opacity(0.8), lineWidth: 1.4)
                            }
                            .padding(.horizontal)
                    }
                }
                .foregroundStyle(theme.text)
                .frame(height: 64)
                .frame(minWidth: 110)
                .fullScreenCover(isPresented: $presentUsernameChanger, 
                                 onDismiss: {
                    Task {
                        if let id = stageController.stage?.id {
                            await auth.setStageName(to: stageName, for: id)
                        }
                    }
                }) {
                    EditUsernameSheetView(content: $stageName)
                        .clearModalBackground()
                }
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
                dismiss()
            }) {
                Text("Log out")
                    .padding(16)
                    .foregroundColor(theme.text)
            }
            Spacer()
        }
        .background {
            RoundedRectangle(cornerRadius: 12)
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
            RoundedRectangle(cornerRadius: 12)
                .fill(theme.backgroundAccent)
                .strokeBorder(theme.accent)
                .shadow(color: theme.shadow, radius: 6, x: 4, y: 4)
        }
    }
}

private struct EditUsernameSheetView: View {
    
    @EnvironmentObject var theme: ThemeController
    @Environment(\.dismiss) private var dismiss
    
    @Binding var content: String
    @State var newContent: String = ""
    
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Use this to share your profile!")
                        .font(.custom("Quicksand", size: 18))
                        .padding(.bottom)
                    Spacer()
                }
                TextField(content, text: $newContent)
                    .scrollContentBackground(.hidden)
                    .textCase(.lowercase)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(theme.background)
                    }
                    .multilineTextAlignment(.leading)
                    .font(.custom("Quicksand", size: 18))
                HStack {
                    Spacer()
                    Button(action: {
                        content = newContent
                        dismiss()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(theme.button)
                            Image(systemName: "checkmark")
                        }
                    }
                    .frame(width: 110, height: 55)
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(theme.backgroundAccent)
            }
            .frame(height: 240)
            Spacer()
        }
        .padding(.top, 120)
        .padding(20)
        .background(.ultraThinMaterial.opacity(0.4))
        .task {
            self.newContent = content
        }
    }
    
}

#Preview {
    AccountView()
}
