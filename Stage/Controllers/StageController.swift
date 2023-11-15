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
    let auth: AuthController = AuthController()
    let remoteStorageController = RemoteStorageController()

    var originalStage: Stage?
    @Published var stage: Stage?
    @Published var isEditEnabled: Bool = false {
        didSet {
            if self.isEditEnabled {
                activateBackup()
            } else {
                restore()
            }
        }
    }

    init() {
        Task {
            await self.auth.startSession()
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
            }
        }
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
    
    func updateStage(_ newStage: Stage) async {
        Task {
            if let userID = auth.session?.user.id {
                let compressedStage: CompressedStage = newStage.compressed()
                let query = supabase.database
                    .from("stages")
                    .update(values: ["content": compressedStage.content])
                    .eq(column: "id", value: userID)
                do {
                    try await query.execute().value
                    await loadStageFromUser()
                } catch {
                    print(error)
                }
            }
            await loadStageFromUser()
        }
    }

    
    func createNewStage() async {
        Task {
            print("creating stage")
            if let userID = auth.session?.user.id {
                let newStage = Stage(id: UUID(), userID: userID, name: "New Stage", profession: "Profession", intro: "Intro")
                let compressedStage = newStage.compressed()
                let query = supabase.database
                    .from("stages")
                    .insert(values: ["content": compressedStage.content])
                do {
                    try await query.execute().value
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
            .eq(column: "stage_id", value: compressedStage.id)
        Task {
            do {
                try await query.execute()
            } catch {
                print("Error deleting trace: \(error)")
            }
        }
    }    
}

//struct Editable: ViewModifier {
//
//    @EnvironmentObject private var modeController: ModeController
//    @State private var opacity: CGFloat = 0.0
//    @Binding var selectedImage: UIImage?
//    var offsetX: CGFloat
//    var offsetY: CGFloat
//
//    func body(content: Content) -> some View {
//        ZStack {
//            content
//            EditButton()
//                .offset(CGSize(width: offsetX, height: offsetY))
//                .opacity(opacity)
//                .onChange(of: modeController.isEditEnabled) {
//                    withAnimation(.easeInOut(duration: 0.2)) {
//                        opacity = modeController.isEditEnabled ? 1.0 : 0.0
//                    }
//                }
//        }
//    }
//}



//    let sampleStage = Stage(id: UUID(), userID: UUID(), name: "Millie Worms", profession: "Ball Photographer", intro: "Millie adores Charlie, their tails wagging furiously whenever they're together, and their playful antics create an unbreakable bond of canine affection.", segments: [Segment(id: UUID(), title: "Just the best", content: "She just loves charlie so damn much it is the cutest funniest thing on earth")], header: URL(string: "https://source.unsplash.com/random/600x480/?landscape")!, profileImage: URL(string: "https://source.unsplash.com/random/300x300/?person,profile")!, highlights: sampleImages.enumerated().map { index, url in
//        ID_URL(id: UUID(), url: url, order: index)
//    }, collections: nil)
