//
//  CollectionOrderEditButton.swift
//  Stage
//
//  Created by Bryce on 12/15/23.
//

import SwiftUI
import Combine

class InteractiveCollectionListViewModel: ObservableObject {
    
    @Published var orderedCollections: [ImageCollection] = []
    @Published var editMode: EditMode = .inactive
    
    func setOrderedCollections(to collections: [ImageCollection]) {
        self.orderedCollections = collections
    }
    
    func move(from source: IndexSet, to destination: Int) {
        orderedCollections.move(fromOffsets: source, toOffset: destination)
    }
    
    func delete(at offsets: IndexSet) {
        orderedCollections.remove(atOffsets: offsets)
    }
}


struct CollectionOrderEditView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var stageController: StageController
    @EnvironmentObject var theme: ThemeController
    
    @StateObject private var viewModel = InteractiveCollectionListViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                theme.background.ignoresSafeArea()
                dismissButton
                List {
                    ForEach(viewModel.orderedCollections, id: \.self) { collection in
                        Text(collection.title)
                        .onDrag {
                            return NSItemProvider()
                        }
                        .frame(height: 60)
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
            if let collections = stageController.stage?.collections {
                viewModel.setOrderedCollections(to: collections)
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
                    .foregroundStyle(theme.text)
                    .font(.custom("Quicksand-Medium", size: 32))
                Spacer()
                Button(action: {
                    if var stage = stageController.stage {
                        stage.collections = viewModel.orderedCollections
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
