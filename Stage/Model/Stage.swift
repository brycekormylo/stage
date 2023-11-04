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
    var highlights: [URL]?
    var collections: [ImageCollection]?
    
    mutating func setProfileImage(url: URL) {
        self.profileImage = url
    }
    
    mutating func setHeader(url: URL) {
        self.header = url
    }
    
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
