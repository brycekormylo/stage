//
//  Stage.swift
//  Fotofolio
//
//  Created by Bryce on 11/2/23.
//

import Foundation

struct Stage: Codable, Identifiable {
    
    var id: UUID
    var name: String
    var header: URL
    var profileImage: URL
    var highlights: [URL]
    var collections: [ImageCollection]
    
}

struct ImageCollection: Codable, Identifiable {
    
    var id: UUID
    var title: String
    var content: [URL]
    
}
