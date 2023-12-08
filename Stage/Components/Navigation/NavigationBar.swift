//
//  NavigationBar.swift
//  Fotofolio
//
//  Created by Bryce on 10/23/23.
//

import SwiftUI

struct NavigationBar: View {

    @AppStorage("selectedTab") private var selectedTab: Tab = Tab.profile
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                ProfileView()
                    .tag(Tab.profile)
                HighlightsView()
                    .tag(Tab.highlights)
                CollectionsView()
                    .tag(Tab.collections)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            TabBarView(currentTab: $selectedTab)
                .padding(.bottom, 28)
        }
        .ignoresSafeArea()
    }
}
