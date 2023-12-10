//
//  ContentView.swift
//  Stage
//
//  Created by Bryce on 11/2/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var themeController: ThemeController = ThemeController()
    @StateObject var auth: AuthController = AuthController.shared
    @StateObject var stageController: StageController = StageController()
    @StateObject var imageSliderController: ImageSliderController = ImageSliderController()
    @StateObject var imageController: ImageController = ImageController()
    @StateObject var imgBB: RemoteStorageController = RemoteStorageController()
    
    @State private var showIntro: Bool = false
    
    var body: some View {
        ZStack {
            themeController.background.ignoresSafeArea()
            NavigationBar()
            MoreButton()
        }
        .overlay {
            if showIntro {
                AuthView()
                    .transition(.move(edge: .bottom))
            }
        }
        .environmentObject(imageSliderController)
        .environmentObject(themeController)
        .environmentObject(imageController)
        .environmentObject(imgBB)
        .environmentObject(auth)
        .environmentObject(stageController)
        .onAppear {
            Task {
                await auth.startSession()
                if auth.authChangeEvent != .signedIn {
                    showIntro = true
                }
            }
        }
        .onChange(of: auth.authChangeEvent) {
            if auth.authChangeEvent == .signedIn {
                showIntro = false
            } else {
                showIntro = true
            }
        }
        .animation(
            .easeInOut, value: auth.authChangeEvent)
    }
}

#Preview {
    ContentView()
}
