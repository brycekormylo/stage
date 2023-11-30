//
//  InteractiveListView.swift
//  Stage
//
//  Created by Bryce on 11/4/23.
//

import SwiftUI
import Combine

class InteractiveListViewModel: ObservableObject {
    
    @Published var orderedHighlights: [ID_URL] = []
    @Published var editMode: EditMode = .inactive
    
    func setOrderedHighlights(to urls: [ID_URL]) {
        self.orderedHighlights = urls
    }
    
    func move(from source: IndexSet, to destination: Int) {
        orderedHighlights.move(fromOffsets: source, toOffset: destination)
    }
    
    func delete(at offsets: IndexSet) {
        orderedHighlights.remove(atOffsets: offsets)
    }
}


struct InteractiveListView: View {
    
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
                    ForEach(viewModel.orderedHighlights, id: \.self) { highlight in
                        HStack {
                            AsyncImage(url: highlight.url) { phase in
                                phase.image?
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
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
                viewModel.setOrderedHighlights(to: highlights)
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
                Spacer()
                Button(action: {
                    Task {
                        if var stage = stageController.stage {
                            stage.highlights = viewModel.orderedHighlights
                            await stageController.updateStage(stage)
                        }
                    }
                    dismiss()
                }) {
                    Image(systemName: "checkmark")
                }
                .modifier(CircleButton())
                    .zIndex(2.0)
            }
            Spacer()
        }
        .padding(.top, 56)
        .padding(.horizontal, 24)
        .ignoresSafeArea()
    }
}
