//
//  TabBarView.swift
//  Fotofolio
//
//  Created by Bryce on 10/23/23.
//

import SwiftUI

enum Tab: String, Hashable, CaseIterable {
    case profile = "person"
    case highlights = "eye"
    case collections = "square.grid.3x3"
}

private let buttonDimen: CGFloat = 55

struct BackgroundHelper: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            var parent = view.superview
            repeat {
                if parent?.backgroundColor != nil {
                    parent?.backgroundColor = UIColor.clear
                    break
                }
                parent = parent?.superview
            } while (parent != nil)
        }
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {}
}

struct TabBarView: View {
    
    @Binding var currentTab: Tab
    @EnvironmentObject var theme: ThemeController
    
    @State var shouldPresentTraceCreator: Bool = false
    
    var body: some View {
        HStack {
            TabBarButton(imageName: Tab.profile.rawValue)
                .frame(width: buttonDimen, height: buttonDimen)
                .onTapGesture {
                    currentTab = .profile
                }
            TabBarButton(imageName: Tab.highlights.rawValue)
                .frame(width: buttonDimen, height: buttonDimen)
                .onTapGesture {
                    currentTab = .highlights
                }
            TabBarButton(imageName: Tab.collections.rawValue)
                .frame(width: buttonDimen, height: buttonDimen)
                .onTapGesture {
                    currentTab = .collections
                }
        }
        .padding(6)
        .background { 
            Capsule()
                .fill(theme.backgroundAccent)
        }
        .overlay { SelectedTabCircleView(currentTab: $currentTab) }
        .shadow(color: theme.shadow, radius: 6, x: 4, y: 4)
        .animation(
            .interactiveSpring(response: 0.34, dampingFraction: 0.69, blendDuration: 0.69),
            value: currentTab)
    }
}

private struct TabBarButton: View {
    @EnvironmentObject var theme: ThemeController
    let imageName: String
    var body: some View {
        Image(systemName: imageName)
            .renderingMode(.template)
            .foregroundColor(theme.text)
            .fontWeight(.bold)
            .scaleEffect(1)
            .padding()
            .contentShape(Rectangle())
    }
}

struct SelectedTabCircleView: View {
    
    @Binding var currentTab: Tab
    @EnvironmentObject var theme: ThemeController
    
    private var horizontalOffset: CGFloat {
        switch currentTab {
        case .profile:
            return -64
        case .highlights:
            return 0
        case .collections:
            return 64
        }
    }
    
    var body: some View {
        ZStack {
            Circle()
                .fill(theme.buttonBackground)
                .frame(width: buttonDimen , height: buttonDimen)
            Circle()
                .stroke(theme.buttonBorder.opacity(0.4), lineWidth: 1)
                .frame(width: buttonDimen , height: buttonDimen)
            TabBarButton(imageName: "\(currentTab.rawValue).fill")
                .foregroundColor(theme.text)
        }
        .offset(x: horizontalOffset)
    }
}

#Preview {
    TabBarView(currentTab: .constant(.profile))
}
