//
//  ContactButton.swift
//  Fotofolio
//
//  Created by Bryce on 10/23/23.
//

import SwiftUI

struct ContactButton: View {
    
    @EnvironmentObject var theme: ThemeController
    @State var presentContactInfo: Bool = false
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Button(action: { presentContactInfo.toggle() }) {
                    Text("Contact")
                        .font(.custom("Quicksand-Medium", size: 24))
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(theme.button)
                        }
                        .foregroundStyle(theme.text)
                }
                Spacer()
            }
        }
        .frame(height: (UIScreen.main.bounds.height - 240)/3)
        .sheet(isPresented: $presentContactInfo) {
            ContactSheet()
        }
        
    }
}

struct ContactSheet: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var theme: ThemeController
    @EnvironmentObject var stageController: StageController
    
    @State private var email: String = "Email"
//    @State private var twitter: String = "Twitter"
//    @State private var instagram: String = "Instagram"
    
    var body: some View {
        ZStack {
            theme.background.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("Contact info")
                        .font(.custom("Quicksand-Medium", size: 24))
                        .foregroundStyle(theme.text)
                        .padding()
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                    }
                    .modifier(SideMountedButton(backgroundColor: theme.backgroundAccent))
                }
                .padding(.vertical)
                Group {
                    ZStack {
                        HStack {
                            Text("Email")
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            EditableText(content: $email)
                                .frame(width: UIScreen.main.bounds.width*3/4, height: 48)
                                .multilineTextAlignment(.trailing)
                        }
                        
                    }
//                    HStack {
//                        Text("Twitter")
//                        Spacer()
//                        EditableText(content: $twitter)
//                        
//                    }
//                    HStack {
//                        Text("Instagram")
//                        Spacer()
//                        EditableText(content: $instagram)
//                    }
                }
                .foregroundStyle(theme.text)
                .font(.custom("Quicksand-Medium", size: 18))
                .padding(.horizontal)
                Spacer()
            }
        }
        .onAppear {
            if let segments = stageController.stage?.segments {
                if let email = segments.filter({ $0.email != nil }).first?.email {
                    self.email = email
                } else {
                    var newSegments = segments
                    newSegments.append(Segment(id: UUID(), email: "Email not set"))
                    if var stage = stageController.stage {
                        stage.segments = newSegments
                        stageController.replaceStage(stage)
                    }
                }
            }

        }
    }
}


#Preview {
    ContactButton()
}
