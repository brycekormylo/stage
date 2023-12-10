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
                        .modifier(SideMountedButton(backgroundColor: theme.accent))
                    }
                }
                .sheet(isPresented: $presentReorderSheet) {
                    SegmentEditView()
                }
            }
        }
        .zIndex(1)
        .animation(
            .interactiveSpring(response: 0.45, dampingFraction: 0.69, blendDuration: 0.69), value: presentReorderSheet)
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
                                HStack {
                                    Spacer()
                                    Text(segment.title ?? "No title")
                                        .font(.custom("Quicksand-Medium", size: 24))
                                }
                                Text(segment.content ?? "No content")
                                    .font(.custom("Quicksand-Medium", size: 18))
                            }
                            .foregroundStyle(theme.text)
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
                .padding(.top, 140)
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
                    .foregroundStyle(theme.text)
                    .font(.custom("Quicksand-Medium", size: 28))
                Spacer()
                Button(action: {
                    if var stage = stageController.stage {
                        stage.segments = viewModel.orderedSegments
                        stageController.replaceStage(stage)
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
