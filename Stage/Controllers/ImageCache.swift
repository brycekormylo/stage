//
//  ImageCacheController.swift
//  Stage
//
//  Created by Bryce on 11/15/23.
//

import Foundation
import SwiftUI


//class ImageCache: ObservableObject {
//    
//    var header: Image
//    var profile: Image
//    
//}

class ImageWrapper: NSObject {
    let image: Image
    
    init(image: Image) {
        self.image = image
    }
}


class ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSURL, ImageWrapper>()
    
    func getImage(url: URL?) -> Image? {
        guard let url = url else { return nil }
        return cache.object(forKey: url as NSURL)?.image
    }
    
    func setImages(images: [URL: Image]) {
        for (url, image) in images {
            cache.setObject(ImageWrapper(image: image), forKey: url as NSURL)
        }
    }
}


struct CachedAsyncImage: View {
    
    let url: URL?
    @EnvironmentObject private var theme: ThemeController
    
    var body: some View {
        if let url = url, let image = ImageCache.shared.getImage(url: url) {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .onAppear {
                        ImageCache.shared.setImages(images: [url!: image])
                    }
            } placeholder: {
                theme.backgroundAccent
            }
        }
    }
}
