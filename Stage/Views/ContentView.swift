//
//  ContentView.swift
//  Stage
//
//  Created by Bryce on 11/2/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var theme: ThemeController = ThemeController()
    @StateObject var auth: AuthController = AuthController.shared
    @StateObject var stageController: StageController = StageController()
    @StateObject var imageSliderController: ImageSliderController = ImageSliderController()
    @StateObject var imgBB: RemoteStorageController = RemoteStorageController()
    
    @State private var showIntro: Bool = false
    @State private var showLoadingScreen: Bool = false
    
    var body: some View {
        ZStack {
            theme.background.ignoresSafeArea()
            NavigationBar()
            MoreButton()
        }
        .overlay {
            if showIntro {
                AuthView()
                    .transition(.move(edge: .bottom))
            } else if showLoadingScreen {
                ZStack {
                    theme.background
                    ActivityIndicator()
                        .frame(width: 200, height: 200)
                        .foregroundStyle(theme.button)
                }
                .ignoresSafeArea()
            }
            
        }
        .environmentObject(imageSliderController)
        .environmentObject(theme)
        .environmentObject(imgBB)
        .environmentObject(auth)
        .environmentObject(stageController)
        .task {
            await auth.startSession()
            if auth.authChangeEvent != .signedIn {
                showIntro = true
            }
        }
        .onChange(of: auth.authChangeEvent) {
            if auth.authChangeEvent == .signedIn {
                showIntro = false
                Task {
                    await stageController.loadStageFromUser()
                }
            } else {
                showIntro = true
            }
        }
        .onChange(of: stageController.stage) {
            if stageController.stage == nil {
                showIntro = true
            } else {
                showIntro = false
            }
        }
        .animation(
            .easeInOut, value: auth.authChangeEvent)
    }
}

#Preview {
    ContentView()
}
