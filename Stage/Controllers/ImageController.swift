//
//  ImageController.swift
//  Fotofolio
//
//  Created by Bryce on 10/23/23.
//

import Foundation

class ImageController: ObservableObject {
    
    @Published var bannerURL: URL = URL(string: "https://source.unsplash.com/random/600x480/?landscape")!
    @Published var profileURL: URL = URL(string: "https://source.unsplash.com/random/300x300/?person,profile")!
    
}
