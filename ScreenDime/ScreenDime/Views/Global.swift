//
//  Global.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//

import SwiftUI

class Global: ObservableObject {
    static let shared = Global()
    
    @Published var selectedProfileIcon: String = "person.crop.circle.fill"
    @AppStorage("hasOnboarded") var hasOnboarded: Bool = false
    @AppStorage("hasScreenTimePermission") var hasScreenTimePermission: Bool = false
    
    static let gradientColors: [Color] = [.green, .mint, .teal, .green.opacity(0.8)]
}

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
