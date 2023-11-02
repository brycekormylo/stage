//
//  PortfolioHeader.swift
//  Fotofolio
//
//  Created by Bryce on 10/19/23.
//

import SwiftUI

struct ProfileHeader: View {
    var body: some View {
        ZStack {
            BannerImageView()
            ProfileImage(size: 256)
                .offset(y: 192)
        }
    }
}

#Preview {
    ProfileHeader()
}
