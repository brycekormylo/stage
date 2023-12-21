//
//  StageController.swift
//  Fotofolio
//
//  Created by Bryce on 11/2/23.
//

import Foundation
import Supabase
import SwiftUI

enum AppMode {
    case edit
    case viewOnly
}

@MainActor
class StageController: ObservableObject {
    
    let supabase: SupabaseClient = SupabaseClient(supabaseURL: Secrets.supabaseURL, supabaseKey: Secrets.supabaseAnonKey)
    let auth = AuthController.shared
    let remoteStorageController = RemoteStorageController()

    private (set) var originalStage: Stage?
    
    @Published var stage: Stage?

    @Published var isEditEnabled: Bool = false {
        didSet {
            if oldValue != isEditEnabled {
                if isEditEnabled {
                    activateBackup()
                } else {
                    clearBackup()
                }
            }
        }
    }

    init() {
        Task {
            if auth.authChangeEvent != .signedIn {
                await self.auth.startSession()
            }
            await self.loadStageFromUser()
            if stage == nil {
                await createNewStage()
            }
        }
    }
    
    private func activateBackup() {
        self.originalStage = stage
    }
    
    private func restore() {
        self.stage = originalStage
        clearBackup()
    }
    
    private func clearBackup() {
        self.originalStage = nil
    }
    
    func submitChanges() {
        Task {
            if let stage = stage {
                await updateStage(stage)
                await loadStageFromUser()
                self.isEditEnabled = false
            }
        }
    }
    
    func discardChanges() {
        restore()
    }
    
    func clearStage() {
        self.stage = nil
    }
    
    func loadStageFromUser(_ id: UUID? = nil) async {
        if let userID = id ?? auth.session?.user.id {
            let query = supabase.database
                .from("stages")
                .select()
                .match(query: ["user_id": userID])
            do {
                let results: [CompressedStage] = try await query.execute().value
                if let firstResult = results.first {
                    self.stage = firstResult.decompressed()
                } else {
                    print("No results found")
                }
            } catch {
                print("Loading Stage error: \(error)")
            }
        }
    }
    
    func getProfileImageFromID(_ stageID: UUID) async -> URL? {
        let query = supabase.database
            .from("stages")
            .select()
            .match(query: ["id": stageID])
        
        do {
            let results: [CompressedStage] = try await query.execute().value
            if let firstResult = results.first {
                return firstResult.decompressed()?.profileImage
            } else {
                print("No results found")
            }
        } catch {
            print("Loading Stage error: \(error)")
        }
        
        return nil
    }
    
    func loadStageFromID(_ stageID: UUID) async {
        let query = supabase.database
            .from("stages")
            .select()
            .match(query: ["id": stageID])
        do {
            let results: [CompressedStage] = try await query.execute().value
            if let firstResult = results.first {
                self.stage = firstResult.decompressed()
            } else {
                print("No results found")
            }
        } catch {
            print("Loading Stage error: \(error)")
        }
    
    }
    
    func getStageNames(by searchInput: String) async -> [StageName] {
        let query = supabase.database
            .rpc(fn: "get_stage_names_by_input", params: ["search_input": searchInput])
        
        do {
            let result: [StageName] = try await query.execute().value
            
            return result
            
        } catch {
            print(error)
            return []
        }
    }
    
    func replaceStage(_ newStage: Stage) {
        Task {
            await MainActor.run {
                self.stage = newStage
            }
        }
    }
    
    private func updateStage(_ newStage: Stage) async {
        Task {
            if let userID = auth.session?.user.id {
                let compressedStage: CompressedStage = newStage.compressed()
                let query = supabase.database
                    .from("stages")
                    .update(values: ["content": compressedStage.content])
                    .eq(column: "user_id", value: userID)
                do {
                    try await query.execute()
                    await loadStageFromUser()
                    print("Stage updated sucessfully")
                } catch {
                    print(error)
                }
            }
            await loadStageFromUser()
        }
    }

    
    func createNewStage() async {
        Task {
            if let userID = auth.session?.user.id {
                let newStage = Stage(id: UUID(), userID: userID)
                let compressedStage = newStage.compressed()
                let query = supabase.database
                    .from("stages")
                    .insert(values: ["content": compressedStage.content])
                do {
                    try await query.execute()
                } catch {
                    print(error)
                }
            }
            await loadStageFromUser()
        }
    }
    
    func deleteStage(_ stage: Stage) {
        let compressedStage = stage.compressed()
        let query = supabase.database
            .from("stages")
            .delete()
            .eq(column: "id", value: compressedStage.id)
        Task {
            do {
                try await query.execute()
            } catch {
                print("Error deleting trace: \(error)")
            }
        }
    }    
}
