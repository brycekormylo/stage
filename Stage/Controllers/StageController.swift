//
//  StageController.swift
//  Fotofolio
//
//  Created by Bryce on 11/2/23.
//

import Foundation
import Supabase
import SwiftUI

@MainActor
class StageController: ObservableObject {
    
    let supabase: SupabaseClient = SupabaseClient(supabaseURL: Secrets.supabaseURL, supabaseKey: Secrets.supabaseAnonKey)

    @Published var stage: Stage?

    
    let auth = AuthController.shared
    
    let sampleStage = Stage(id: UUID(), userID: UUID(), name: "Millie Worms", profession: "Ball Photographer", intro: "Millie adores Charlie, their tails wagging furiously whenever they're together, and their playful antics create an unbreakable bond of canine affection.", segments: [Segment(id: UUID(), title: "Just the best", content: "She just loves charlie so damn much it is the cutest funniest thing on earth")], header: URL(string: "https://source.unsplash.com/random/600x480/?landscape")!, profileImage: URL(string: "https://source.unsplash.com/random/300x300/?person,profile")!, highlights: nil, collections: nil)
    
    init() {
        self.stage = sampleStage
    }
    
    func loadStageFromUser(_ id: UUID? = nil) async {
        if let userID = id ?? auth.session?.user.id {
            let query = supabase.database
                .from("stages")
                .select()
                .match(query: ["id": userID])
            do {
                stage = try await query.execute().value
            } catch {
                print(error)
            }
        }
    }
    
    func deleteStage(_ stage: Stage) {
        let query = supabase.database
            .from("stages")
            .delete()
            .eq(column: "stage_id", value: stage.id)
        Task {
            do {
                try await query.execute()
            } catch {
                print("Error deleting trace: \(error)")
            }
        }
    }
    
    func getEncodedStage() -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try encoder.encode(stage)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            print("Failed to encode stage: \(error)")
        }
        return nil
    }
    
    func decodeStage(_ stagejson: String) {
        if let jsonData = stagejson.data(using: .utf8) {
            let decoder = JSONDecoder()
            do {
                let stage = try decoder.decode(Stage.self, from: jsonData)
                self.stage = stage
            } catch {
                print("Failed to decode stage: \(error)")
            }
        }
    }
    
}
