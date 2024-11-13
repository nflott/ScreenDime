//
//  Global.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//

import SwiftUI

class Global: ObservableObject {
    // Singleton instance
    static let shared = Global()
    
    // App-wide settings with @AppStorage
    @AppStorage("selectedProfileIcon") var selectedProfileIcon: String = "person.crop.circle.fill"
    @AppStorage("hasOnboarded") var hasOnboarded: Bool = false
    @AppStorage("hasScreenTimePermission") var hasScreenTimePermission: Bool = false

    // Static constant, accessible anywhere
    static let gradientColors: [Color] = [.green, .mint, .teal, .green.opacity(0.8)]
}

// Background view modifier for global gradient
struct Background: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: Global.gradientColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            content
        }
    }
}

extension View {
    func applyBackground() -> some View {
        self.modifier(Background())
    }
}
