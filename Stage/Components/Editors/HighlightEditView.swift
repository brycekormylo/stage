//
//  InteractiveListView.swift
//  Stage
//
//  Created by Bryce on 11/4/23.
//

import SwiftUI
import Combine

class InteractiveListViewModel: ObservableObject {
    
    @Published var orderedImages: [ID_URL] = []
    @Published var editMode: EditMode = .inactive
    
    func setOrderedImages(to urls: [ID_URL]) {
        self.orderedImages = urls
    }
    
    func move(from source: IndexSet, to destination: Int) {
        orderedImages.move(fromOffsets: source, toOffset: destination)
    }
    
    func delete(at offsets: IndexSet) {
        orderedImages.remove(atOffsets: offsets)
    }
}


struct HighlightEditView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var stageController: StageController
    @EnvironmentObject var theme: ThemeController

    @StateObject private var viewModel = InteractiveListViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                theme.background.ignoresSafeArea()
                dismissButton
                List {
                    ForEach(viewModel.orderedImages, id: \.self) { highlight in
                        HStack {
                            AsyncImage(url: highlight.url) { phase in
                                phase.image?
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 120, height: 120)
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 12)
                                    )
                            }
                            Spacer()
                        }
                        .onDrag {
                            return NSItemProvider()
                        }
                        .frame(height: 120)
                        .listRowBackground(theme.background)
                    }
                    .onMove(perform: viewModel.move)
                    .onDelete(perform: viewModel.delete)
                }
                .padding(.top, 80)
                .listStyle(.plain)
                .environment(\.editMode, $viewModel.editMode)
                .foregroundStyle(theme.text)
            }
        }
        .onAppear {
            viewModel.editMode = .active
            if let highlights = stageController.stage?.highlights {
                viewModel.setOrderedImages(to: highlights)
            }
        }
        .onDisappear {
            viewModel.editMode = .inactive
        }
    }
    
    var dismissButton: some View {
        VStack {
            HStack {
                Text("Adjust order")
                    .font(.title2)
                    .padding(.horizontal, 24)
                Spacer()
                Button(action: {
                    if var stage = stageController.stage {
                        stage.highlights = viewModel.orderedImages
                        stageController.replaceStage(stage)
                    }
                    dismiss()
                }) {
                    Image(systemName: "checkmark")
                }
                .modifier(SideMountedButton(theme.button))
                .zIndex(2.0)
            }
            Spacer()
        }
        .padding(.top, 16)
    }
}
