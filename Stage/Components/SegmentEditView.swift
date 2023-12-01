//
//  SegmentEditView.swift
//  Stage
//
//  Created by Bryce on 12/1/23.
//

import SwiftUI
import Combine

class InteractiveSegmentListViewModel: ObservableObject {
    
    @Published var orderedSegments: [Segment] = []
    @Published var editMode: EditMode = .inactive
    
    func setOrderedSegments(to segments: [Segment]) {
        self.orderedSegments = segments
    }
    
    func move(from source: IndexSet, to destination: Int) {
        orderedSegments.move(fromOffsets: source, toOffset: destination)
    }
    
    func delete(at offsets: IndexSet) {
        orderedSegments.remove(atOffsets: offsets)
    }
}
struct SegmentOrderChangerButton: View {
    
    @EnvironmentObject var theme: ThemeController
    @EnvironmentObject var stageController: StageController
    
    @State private var presentReorderSheet = false
    
    var body: some View {
        ZStack {
            if stageController.isEditEnabled {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            presentReorderSheet.toggle()
                        }) {
                            Image(systemName: "arrow.up.arrow.down")
                                .foregroundStyle(theme.text)
                        }
                        .modifier(CircleButton())
                        .transition(.move(edge: .trailing))
                    }
                }
                .sheet(isPresented: $presentReorderSheet) {
                    SegmentEditView()
                }
            }
        }
        .zIndex(1)
        .animation(
            .interactiveSpring(response: 0.45, dampingFraction: 0.69, blendDuration: 0.74), value: presentReorderSheet)
    }
    
}

struct SegmentEditView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var stageController: StageController
    @EnvironmentObject var theme: ThemeController
    
    @StateObject private var viewModel = InteractiveSegmentListViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                theme.background.ignoresSafeArea()
                dismissButton
                List {
                    ForEach(viewModel.orderedSegments, id: \.self) { segment in
                        HStack {
                            VStack {
                                Text(segment.title ?? "No title")
                                Text(segment.content ?? "No content")
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
            if let segments = stageController.stage?.segments {
                viewModel.setOrderedSegments(to: segments)
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
                    if var stage = stageController.stage {
                        stage.segments = viewModel.orderedSegments
                        stageController.stage = stage
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
