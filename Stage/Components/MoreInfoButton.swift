//
//  MoreInfoButton.swift
//  Fotofolio
//
//  Created by Bryce on 10/23/23.
//

import SwiftUI

struct MoreInfoButton: View {
    
    let size: CGFloat = 48
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: size, height: size)
            
        }
    }
}

#Preview {
    MoreInfoButton()
}
