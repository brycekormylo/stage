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
    
    var body: some View {
        ZStack {
            themeController.background.ignoresSafeArea()
            NavigationBar()
            MoreButton()
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
            }
        }
    }
}

#Preview {
    ContentView()
}
