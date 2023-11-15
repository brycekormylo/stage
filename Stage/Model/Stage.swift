//
//  Stage.swift
//  Fotofolio
//
//  Created by Bryce on 11/2/23.
//

import Foundation
import SwiftUI

struct CompressedStage: Codable, Identifiable{
    var id: UUID = UUID()
    var user_id: UUID
    var content: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case user_id = "user_id"
        case content = "content"
    }
    
    init(id: UUID, user_id: UUID, content: String) {
        self.id = id
        self.user_id = user_id
        self.content = content
    }
    
    func encoded() -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try encoder.encode(self)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            print("Failed to encode compressed stage: \(error)")
        }
        return nil
    }
    
    func decompressed() -> Stage? {
        guard let stageContent = StageContent.decoded(from: content) else {
            print("Error decoding StageContent")
            return nil
        }
        
        let stage = Stage(
            id: id,
            userID: user_id,
            name: stageContent.name,
            profession: stageContent.profession,
            intro: stageContent.intro,
            segments: stageContent.segments,
            header: stageContent.header,
            profileImage: stageContent.profileImage,
            highlights: stageContent.highlights,
            collections: stageContent.collections
        )
        
        return stage
    }

}

struct StageContent: Codable {
    var name: String?
    var profession: String?
    var intro: String?
    var segments: [Segment]?
    var header: URL?
    var profileImage: URL?
    var highlights: [ID_URL]?
    var collections: [ImageCollection]?
    
    static func decoded(from jsonString: String) -> StageContent? {
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Failed to convert content JSON string to data")
            return nil
        }
        
        do {
            let stageContent = try JSONDecoder().decode(StageContent.self, from: jsonData)
            return stageContent
        } catch {
            print("Failed to decode StageContent: \(error)")
            return nil
        }
    }
}

struct Stage: Codable, Identifiable {
    
    var id: UUID = UUID()
    var userID: UUID
    var name: String?
    var profession: String?
    var intro: String?
    var segments: [Segment]?
    var header: URL?
    var profileImage: URL?
    var highlights: [ID_URL]?
    var collections: [ImageCollection]?
    
    func compressed() -> CompressedStage {
        let content = StageContent(name: name, profession: profession, intro: intro, segments: segments, header: header, profileImage: profileImage, highlights: highlights, collections: collections)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try encoder.encode(content)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return CompressedStage(id: id, user_id: userID, content: jsonString)
            }
        } catch {
            print("Failed to encode stage content: \(error)")
        }
        return CompressedStage(id: id, user_id: userID, content: "")
    }
}


struct ID_URL: Codable, Identifiable, Hashable {
    let id: UUID
    let url: URL
    var order: Int
}

struct ImageCollection: Codable, Identifiable {
    
    var id: UUID
    var hexColor: String?
    var title: String?
    var content: [URL]?
    
}

struct Segment: Codable, Identifiable {

    var id: UUID
    var title: String?
    var content: String?
    
}
