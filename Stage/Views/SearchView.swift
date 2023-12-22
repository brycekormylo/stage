//
//  SearchView.swift
//  Stage
//
//  Created by Bryce on 12/20/23.
//

import SwiftUI

struct SearchView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var theme: ThemeController
    @EnvironmentObject private var stageController: StageController
    
    @State var searchInput: String = ""
    @State var results: [StageName]?
    
    var body: some View {
        ZStack {
            theme.background.ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                    }
                    .modifier(SideMountedButton(theme.button))
                    .zIndex(2.0)
                }
                Spacer()
            }
            .padding(.top, 16)
            VStack {
                TextField("", text: $searchInput)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(theme.text)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding(18)
                    .background {
                        ZStack {
                            VStack(spacing: 2) {
                                Spacer()
                                theme.text.opacity(0.4)
                                    .frame(height: 1)
                                HStack {
                                    Text("Enter Stage Name")
                                        .foregroundColor(theme.text.opacity(0.6))
                                    Spacer()
                                }
                            }
                        }
                        .offset(y: 12)
                    }
                    .overlay {
                        HStack {
                            Spacer()
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(theme.text)
                        }
                        .padding()
                    }
                VStack {
                    if let searchResults = results {
                        ForEach(searchResults, id: \.self) { result in
                            SearchResult(result: result)
                                .onTapGesture {
                                    dismiss()
                                }
                        }
                    } else {
                        Text("No results")
                            .foregroundStyle(theme.text)
                            .font(.custom("quicksand-regular", size: 18))
                            .padding()
                    }
                }
                .padding(.vertical)
                Spacer()
                
            }
            .padding()
            .padding(.top, 64)
            .onChange(of: searchInput) {
                if searchInput.count >= 4 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        Task {
                            self.results = await stageController.getStageNames(by: searchInput)
                        }
                    }
                } else {
                    self.results = []
                }
            }
        }
    }
}

private struct SearchResult: View {
    
    @EnvironmentObject private var theme: ThemeController
    @EnvironmentObject private var stageController: StageController
    
    let result: StageName
    @State var profileImageURL: URL?
    
    var body: some View {
        Button(action: {
            Task {
                await stageController.loadStageFromID(result.stage_id)
            }
        }) {
            HStack {
                AsyncImage(url: profileImageURL) { image in
                    image
                        .resizable()
                } placeholder: {
                    Circle()
                }
                .frame(width: 64, height: 64)
                .clipShape(Circle())
                .padding(.trailing)
                Text("@\(result.stage_name)")
                    .font(.custom("quicksand-regular", size: 18))
                Spacer()
                Image(systemName: "chevron.right")
            }
            .foregroundStyle(theme.text)
            .padding()
        }
        .task {
            Task {
                profileImageURL = await stageController.getProfileImageFromID(result.stage_id)
            }
        }
    }
    
}

#Preview {
    SearchView()
}
