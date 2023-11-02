//
//  BannerImageView.swift
//  Fotofolio
//
//  Created by Bryce on 10/23/23.
//

import SwiftUI

struct BannerImageView: View {
    
    @EnvironmentObject var imageController: ImageController
    
    var body: some View {
        VStack {
            AsyncImage(url: imageController.bannerURL) { result in
                result.image?
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .ignoresSafeArea()
            }
            Spacer()
        }
    }
}

#Preview {
    BannerImageView()
}
