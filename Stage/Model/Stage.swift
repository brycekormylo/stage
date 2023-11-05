//
//  Stage.swift
//  Fotofolio
//
//  Created by Bryce on 11/2/23.
//

import Foundation
import SwiftUI

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
    
    mutating func setProfileImage(url: URL) {
        self.profileImage = url
    }
    
    mutating func setHeader(url: URL) {
        self.header = url
    }
    
    mutating func setName(_ name: String) {
        self.name = name
    }
    
    mutating func setHighlights(_ urls: [ID_URL]) {
        self.highlights = urls
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
