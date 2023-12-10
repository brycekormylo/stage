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

private let buttonDimen: CGFloat = 56

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
            Rectangle()
                .fill(theme.backgroundAccent)
                .cornerRadius(22)
        }
        .shadow(color: theme.background.opacity(0.6), radius: 4)
        .overlay { SelectedTabCircleView(currentTab: $currentTab) }
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
            Rectangle()
                .fill(theme.backgroundAccent)
                .cornerRadius(16)
                .frame(width: buttonDimen , height: buttonDimen)
//            Circle()
//                .fill(theme.button.opacity(0.2))
//                .frame(width: buttonDimen , height: buttonDimen)
            RoundedRectangle(cornerRadius: 16.0)
                .strokeBorder(theme.button, lineWidth: 1.4)
//                .cornerRadius(16)
                .frame(width: buttonDimen , height: buttonDimen)
            TabBarButton(imageName: "\(currentTab.rawValue).fill")
                .scaleEffect(1.1)
                .foregroundColor(theme.text)
        }
        .offset(x: horizontalOffset)
    }
}

#Preview {
    TabBarView(currentTab: .constant(.profile))
}
