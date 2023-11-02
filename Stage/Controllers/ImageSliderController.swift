//
//  ImageSliderController.swift
//  Fotofolio
//
//  Created by Bryce on 10/23/23.
//

import Foundation
class ImageSliderController: ObservableObject {
    
    @Published var expandedImage: URL?
    
    func minimizeAll() {
        self.expandedImage = nil
    }
    
    func expandImage(withURL imageURL: URL) {
        self.expandedImage = imageURL
    }
}
