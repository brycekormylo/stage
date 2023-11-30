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
                    .background(Color.clear)
                    .multilineTextAlignment(.center)
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
                    .multilineTextAlignment(.center)
            } else {
                Text(content)
            }
        }
        .foregroundStyle(theme.text)
    }
}

#Preview {
    EditableText(content: .constant("Sample"))
}
