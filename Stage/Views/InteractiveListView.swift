//
//  InteractiveListView.swift
//  Stage
//
//  Created by Bryce on 11/4/23.
//

import SwiftUI
import Combine

struct InteractiveListView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var stageController: StageController
    @EnvironmentObject var imageController: ImageController
    @EnvironmentObject var theme: ThemeController
    
    @Binding var contents: [ID_URL]

    var body: some View {
        ZStack {
            theme.background.ignoresSafeArea()
            List($contents, id: \.self, editActions: [.delete, .move]) { $content in
                HStack {
                    AsyncImage(url: content.url) { phase in
                        phase.image?
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    Spacer()
                    Image(systemName: "line.3.horizontal")
                        .opacity(0.6)
                }
                .frame(height: 120)
                .listRowBackground(theme.background)
            }
            .padding(.top, 80)
            .listStyle(.plain)
            VStack {
                HStack {
                    Text("Change Order")
                        .font(.title2)
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                    }
                    .modifier(CircleButton())
                }
                .padding()
                Spacer()
            }
        }
    }
}
