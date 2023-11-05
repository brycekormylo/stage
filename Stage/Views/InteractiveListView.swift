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
    
    @EnvironmentObject var imageController: ImageController
    @EnvironmentObject var theme: ThemeController
    
    @Binding var contents: [ID_URL]

    var body: some View {
        ZStack {
            theme.background.ignoresSafeArea()
//            List($contents, id: \.self, editActions: [.delete, .move]) { $content in
            List {
                ForEach(contents) { content in
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
                .onMove(perform: move)
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
    
    private func move(from source: IndexSet, to destination: Int) {
        var revisedContents = contents
        revisedContents.move(fromOffsets: source, toOffset: destination )
        for reverseIndex in stride( from: revisedContents.count - 1, through: 0, by: -1 ) {
            revisedContents[ reverseIndex ].order = Int( reverseIndex )
        }
        contents = revisedContents
    }
}
