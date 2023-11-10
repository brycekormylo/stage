//
//  AuthController.swift
//  Fotofolio
//
//  Created by Bryce on 11/2/23.
//

import Foundation
import Supabase
import SwiftUI
import Combine
import GoTrue

enum CreateUserError: Error {
    case signUpFailed(String)
}

@MainActor
class AuthController: ObservableObject {
    
    static var shared = AuthController()
    
    let supabase: SupabaseClient = SupabaseClient(supabaseURL: Secrets.supabaseURL, supabaseKey: Secrets.supabaseAnonKey)
    
    private var error: Error?
    @Published private(set) var session: Session?
    @Published private(set) var authChangeEvent: AuthChangeEvent?
    
    init() {
        startSession()
    }
    
    private func startSession() {
        Task {
            do {
                self.session = try await supabase.auth.session
                self.authChangeEvent = (session != nil) ? .signedIn : .signedOut
            } catch {
                print(error)
            }
        }
    }
    
    func login(email: String, password: String) async throws {
        do {
            try await supabase.auth.signIn(email: email, password: password)
            self.session = try await supabase.auth.session
            self.authChangeEvent = .signedIn
        } catch {
            throw CreateUserError.signUpFailed(error.localizedDescription)
        }
    }
    
    func logout() {
        if authChangeEvent == .signedOut { return }
        Task {
            do {
                try await supabase.auth.signOut()
                self.authChangeEvent = .signedOut
                self.session = nil
            } catch {
                print(error)
            }
        }
    }
    
    func createNewUser(email: String, password: String) async throws {
        do {
            try await supabase.auth.signUp(email: email, password: password)
        } catch {
            throw CreateUserError.signUpFailed(error.localizedDescription)
        }
    }
    
    func deleteAccount() {
        
        guard authChangeEvent == .signedOut else { return }
        
        let userID = session!.user.id
        let query = supabase.database.from("users")
            .delete()
            .eq(column: "id", value: userID)
        
        Task {
            do {
                logout()
                try await query.execute()
            } catch {
                print(error)
            }
        }
    }
}
