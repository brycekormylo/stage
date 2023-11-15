//
//  AccountView.swift
//  Fotofolio
//
//  Created by Bryce on 11/2/23.
//

import SwiftUI

struct AuthView: View {

    @State var email: String = ""
    @State var password: String = ""
    @State var confirmedPassword: String = ""
    @State var mode: Mode = .signUp
    @State var error: Error?
    @State var errorMessage: String?
    @State var loginInProgress: Bool = false
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var auth: AuthController
    @EnvironmentObject var theme: ThemeController
    
    enum Mode {
        case signIn, signUp
    }
    
    var body: some View {
        ZStack {
            VStack (spacing: 16){
                HStack {
                    Spacer()
                    Button(action: {dismiss()} ) {
                        Image(systemName: "xmark")
                            .foregroundColor(theme.text)
                            .padding()
                            .background(Capsule().fill(theme.backgroundAccent))
                            .shadow(color: theme.shadow, radius: 4, x: 2, y: 2)
                    }
                }
                Text("Welcome to Stage")
                    .font(.title2)
                    .foregroundColor(theme.text)
                    .padding(.bottom)
                TextField("", text: $email)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(theme.text)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background {
                        ZStack {
                            VStack(spacing: 2) {
                                Spacer()
                                theme.text.opacity(0.4)
                                    .frame(height: 1)
                                HStack {
                                    Text("Email")
                                        .foregroundColor(theme.text.opacity(0.6))
                                    Spacer()
                                }
                            }
                        }
                        .offset(y: 12)
                    }

                SecureField("",text: $password)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(theme.text)
                    .textContentType(.password)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background {
                        ZStack {
                            VStack(spacing: 2) {
                                Spacer()
                                theme.text.opacity(0.4)
                                    .frame(height: 1)
                                HStack {
                                    Text("Password")
                                        .foregroundColor(theme.text.opacity(0.6))
                                    Spacer()
                                }
                            }
                        }
                        .offset(y: 12)
                    }

                SecureField("", text: $confirmedPassword)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(theme.text)
                    .textContentType(.password)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background {
                        ZStack {
                            VStack(spacing: 2) {
                                Spacer()
                                theme.text.opacity(0.4)
                                    .frame(height: 1)
                                HStack {
                                    Text("Confirm Password")
                                        .foregroundColor(theme.text.opacity(0.6))
                                    Spacer()
                                }
                            }
                        }
                        .offset(y: 12)
                    }
                    .opacity(mode == .signUp ? 1.0 : 0.0)
                    .animation(.easeInOut, value: mode)
                if let error = errorMessage {
                    Text(error)
                }
                buttons
                Spacer()
            }
            .padding()
            .background(theme.background)
        }
    }

    var buttons: some View {
        VStack {
            mainActionButton
            modeToggle
        }
        .padding(.top, 32)
    }
    
    var mainActionButton: some View {
        HStack {
            Spacer()
            Button(action: {
                if mode == .signUp && password != confirmedPassword {
                    errorMessage = "Passwords do not match"
                }
                if mode == .signUp && password == confirmedPassword {
                    Task {
                        do {
                            try await auth.createNewUser(email: email, password: password)
                            try await auth.login(email: email, password: password)
                            dismiss()
                        } catch CreateUserError.signUpFailed(let errorMessage) {
                            self.errorMessage = errorMessage
                        } catch {
                            self.errorMessage = error.localizedDescription
                        }
                    }
                    withAnimation { mode = .signUp }
                }
                if mode == .signIn {
                    Task {
                        do {
                            try await auth.login(email: email, password: password)
                            dismiss()
                        } catch {
                            self.errorMessage = "Invalid Login Credentials"
                        }
                    }
                }
            }) {
                Text(mode == .signIn ? "Log In" : "Sign Up")
                    .bold()
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
    
    var modeToggle: some View {
        HStack {
            Spacer()
            Button(action: {
                withAnimation{ mode = (mode == .signIn) ? .signUp : .signIn}
            }) {
                Text(mode == .signUp ? "Log in instead" : "Sign up instead")
                    .padding(16)
                    .foregroundColor(theme.text)
            }
            Spacer()
        }
        .background {
            RoundedRectangle(cornerRadius: 8)
                .stroke(theme.accent, lineWidth: 1)
                .shadow(color: theme.shadow, radius: 6, x: 4, y: 4)
        }
    }
}


