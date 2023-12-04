//
//  EditableText.swift
//  Stage
//
//  Created by Bryce on 11/17/23.
//

import SwiftUI

struct EditableField: View {
    @EnvironmentObject var imageController: ImageController
    @EnvironmentObject var theme: ThemeController
    @EnvironmentObject var stageController: StageController
    
    @Binding var content: String
    
    var body: some View {
        Group {
            if stageController.isEditEnabled {
                TextField("\(content)", text: $content)
                    .padding(8)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(theme.button.opacity(0.1))
                    }
                    .multilineTextAlignment(.trailing)
            } else {
                Text(content)
            }
        }
        .foregroundStyle(theme.text)
    }
}

struct EditableText: View {
    
    @EnvironmentObject var imageController: ImageController
    @EnvironmentObject var theme: ThemeController
    @EnvironmentObject var stageController: StageController
    
    @Binding var content: String
    
    var body: some View {
        Group {
            if stageController.isEditEnabled {
                TextEditor(text: $content)
                    .scrollContentBackground(.hidden)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(theme.button.opacity(0.1))
                    }
                    .multilineTextAlignment(.leading)
            } else {
                Text(content)
            }
        }
        .foregroundStyle(theme.text)
    }
}

struct EditTextButton: View {
    @EnvironmentObject var theme: ThemeController
    @EnvironmentObject var stageController: StageController
    
    @State var presentTextEditor: Bool = false
    
    var body: some View {
        ZStack {
            if stageController.isEditEnabled {
                if presentTextEditor {
                    VStack {
                        EditableTextPopover(isPresented: $presentTextEditor)
                        Spacer()
                    }
                    .padding(.top, 120)
                    .transition(.move(edge: .trailing))
                } else {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                presentTextEditor.toggle()
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundStyle(theme.text)
                            }
                            .modifier(CircleButton())
                            .transition(.move(edge: .trailing))
                        }
                        .padding(.bottom, 120)
                    }
                }
            }
        }
        .zIndex(1)
        .animation(
            .interactiveSpring(response: 0.45, dampingFraction: 0.69, blendDuration: 0.74), value: presentTextEditor)
    }

}

struct EditableTextPopover: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Binding var isPresented: Bool
    
    @EnvironmentObject var theme: ThemeController
    @EnvironmentObject var stageController: StageController
    
    @State var title: String = ""
    @State var content: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("New Segment")
                    .font(.custom("Quicksand-Medium", size: 24))
                    .opacity(0.6)
                Spacer()
            }
            .padding(.horizontal)
            TextField("", text: $title)
                .placeholder(when: title.isEmpty) {
                    Text("Title")
                        .foregroundColor(theme.text.opacity(0.6))
                        .font(.custom("Quicksand-Medium", size: 18))
                }
                .padding()
                .background(theme.button.opacity(0.1))
                .cornerRadius(8)
            TextEditor(text: $content)
                .placeholder(when: content.isEmpty) {
                    VStack {
                        Text("Content")
                            .foregroundColor(theme.text.opacity(0.6))
                            .font(.custom("Quicksand-Medium", size: 18))
                        Spacer()
                    }
                    .padding()
                }
                .scrollContentBackground(.hidden)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(theme.button.opacity(0.1))
                }
                .multilineTextAlignment(.leading)
                .frame(maxHeight: 120)
            HStack {
                Spacer()
                Button(action: { isPresented = false }) {
                    Image(systemName: "xmark")
                }
                .modifier(CircleButton())
                Button(action: {
                    submitNewSegment()
                    isPresented = false
                }) {
                    Image(systemName: "checkmark")
                }
                .disabled(title.isEmpty)
                .modifier(CircleButton())
            }
        }
        .padding()
        .background {
            theme.backgroundAccent
                .cornerRadius(12)
        }
        .padding()
        .foregroundStyle(theme.text)
    }
    
    func submitNewSegment() {
        let newSegment = Segment(id: UUID(), title: self.title, content: self.content)
        if var stage = stageController.stage {
            if var segments = stage.segments {
                segments.append(newSegment)
                print(segments)
                stage.segments = segments
            } else {
                stage.segments = [newSegment]
            }
            stageController.stage = stage
        }
    }
}



#Preview {
    EditableText(content: .constant("Sample"))
}
