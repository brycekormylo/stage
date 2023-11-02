//
//  ProfileView.swift
//  Fotofolio
//
//  Created by Bryce on 10/23/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var theme: ThemeController
    @State var arrowUp: Bool = false
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    ProfileHeader()
                    info
                        .padding(.top, 196)
                    moreInfo
                        .padding(.vertical, 120)
                    GeometryReader { geo in
                        Color.clear
                            .onChange(of: geo.frame(in: .global).minY) {
                                self.arrowUp = geo.frame(in: .global).minY < 1000
                            }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
        }
        .overlay(alignment: arrowUp ? .top : .bottom) {
            arrowButton
                .padding(arrowUp ? .top : .bottom, arrowUp ? 64 : 108)
        }
        .ignoresSafeArea()
    }
    
    var arrowButton: some View {
        ZStack() {
            Image(systemName: arrowUp ? "chevron.up" : "chevron.down")
                .padding(.vertical, 8)
                .foregroundStyle(theme.text)
        }
    }
    
    var info: some View {
        StyledStack {
            Text("Millie Worms")
                .font(.title)
                .modifier(Editable(offsetX: 100, offsetY: .zero))
            Text("Ball Photographer")
                .opacity(0.6)
            Text("Millie adores Charlie, their tails wagging furiously whenever they're together, and their playful antics create an unbreakable bond of canine affection.")
                .padding(.vertical, 8)
        }
        .frame(height: 200)
    }
    
    var moreInfo: some View {
        StyledStack {
            Text("Millie Worms")
                .font(.title)
            Text("Ball Photographer")
                .opacity(0.6)
            Text("Millie adores Charlie, their tails wagging furiously whenever they're together, and their playful antics create an unbreakable bond of canine affection.")
                .padding(.vertical, 8)
            Spacer()
            Text("Millie Worms")
                .font(.title)
            Text("Ball Photographer")
                .opacity(0.6)
            Text("Millie adores Charlie, their tails wagging furiously whenever they're together, and their playful antics create an unbreakable bond of canine affection.")
                .padding(.vertical, 20)
            ContactButton()
                .padding(.bottom, 40)
        }
        .frame(height: 600)
    }
}

struct StyledStack<Content: View>: View {
    
    @EnvironmentObject var theme: ThemeController
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack {
            content
        }
        .foregroundStyle(theme.text)
        .padding(.horizontal)
    }
    
}

#Preview {
    ProfileView()
}
