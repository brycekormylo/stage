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
    
    static let shared = AuthController()
    
    let supabase: SupabaseClient = SupabaseClient(supabaseURL: Secrets.supabaseURL, supabaseKey: Secrets.supabaseAnonKey)
    
    private var error: Error?
    @Published private(set) var session: Session?
    @Published private(set) var authChangeEvent: AuthChangeEvent?
    @Published private(set) var stageName: String?
    @Published private(set) var viewOnly: Bool = false
    
    func startSession() async {
        do {
            if let storedSessionInfo = UserDefaults.standard.data(forKey: "userSession"),
               let decodedSession = try? JSONDecoder().decode(Session.self, from: storedSessionInfo) {
                self.session = decodedSession
                self.authChangeEvent = .signedIn
            } else {
                self.session = try await supabase.auth.session
                self.authChangeEvent = (session != nil) ? .signedIn : .signedOut
                if let encodedSession = try? JSONEncoder().encode(session) {
                    UserDefaults.standard.set(encodedSession, forKey: "userSession")
                }
            }
        } catch {
            print(error)
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
                clearStoredSession()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func syncStageName(for stageID: UUID) async {

        let query = supabase.database
            .rpc(fn: "get_stage_name", params: ["stage_id_param": stageID.uuidString.lowercased()])
        do {
            stageName = try await query.execute().value
            print("Stage Name: \(stageName ?? "Not found")")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func setStageName(to name: String, for stageID: UUID) async {
        let query = supabase.database
            .rpc(fn: "update_stage_name", params: ["stage_id_param": stageID.uuidString.lowercased(), "new_name_param": name])
        do {
            try await query.execute()
        } catch {
            print(error)
        }
        await syncStageName(for: stageID)
        
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
    
    func clearStoredSession() {
        UserDefaults.standard.removeObject(forKey: "userSession")
    }
}
