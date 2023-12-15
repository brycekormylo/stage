//
//  EditableText.swift
//  Stage
//
//  Created by Bryce on 11/17/23.
//

import SwiftUI

struct EditableField: View {
    
    @EnvironmentObject var theme: ThemeController
    @EnvironmentObject var stageController: StageController
    
    @Binding var content: String
    @State var presentPopover: Bool = false
    
    var body: some View {
        Text(content)
            .foregroundStyle(theme.text)
            .onTapGesture {
                if stageController.isEditEnabled {
                    presentPopover = true
                }
            }
            .fullScreenCover(isPresented: $presentPopover) {
                EditTextSheetView(content: $content)
                    .clearModalBackground()
            }
    }
}

struct EditableText: View {
    
    @EnvironmentObject var theme: ThemeController
    @EnvironmentObject var stageController: StageController
    
    @Binding var content: String
    @State var presentPopover: Bool = false
    
    var body: some View {
        Text(content)
            .foregroundStyle(theme.text)
            .onTapGesture {
                if stageController.isEditEnabled {
                    presentPopover = true
                }
            }
            .fullScreenCover(isPresented: $presentPopover) {
                EditTextSheetView(content: $content)
                    .clearModalBackground()
            }
    }
}

private struct EditTextSheetView: View {
    
    @EnvironmentObject var theme: ThemeController
    @Environment(\.dismiss) private var dismiss
    
    @Binding var content: String
    @State var newContent: String = ""
    
    
    var body: some View {
        VStack {
            VStack {
                TextEditor(text: $newContent)
                    .scrollContentBackground(.hidden)
                    .padding(4)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(theme.background)
                    }
                    .multilineTextAlignment(.leading)
                    .font(.custom("Quicksand", size: 18))
                HStack {
                    Spacer()
                    Button(action: {
                        content = newContent
                        dismiss()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(theme.button)
                            Image(systemName: "checkmark")
                        }
                    }
                    .frame(width: 110, height: 55)
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(theme.backgroundAccent)
            }
            .frame(height: 240)
            Spacer()
        }
        .padding(.top, 120)
        .padding(20)
        .background(.ultraThinMaterial.opacity(0.4))
        .task {
            self.newContent = content
        }
    }
    
}


#Preview {
    EditableText(content: .constant("Sample"))
}
