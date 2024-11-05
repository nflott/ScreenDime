//
//  Global.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//

import SwiftUI

struct Global {
    /*
    static var hasOnboarded: Bool {
        get { UserDefaults.standard.bool(forKey: "hasOnboarded") }
        set { UserDefaults.standard.set(newValue, forKey: "hasOnboarded") }
    }*/
    
    /*
    static var hasScreenTimePermission: Bool {
        get { UserDefaults.standard.bool(forKey: "hasScreenTimePermission")}
        set { UserDefaults.standard.set(newValue, forKey: "hasScreenTimePermission") }
    }*/
    
    static var hasOnboarded = false
    static var hasScreenTimePermission = false
    
    static let gradientColors: [Color] = [.green, .mint, .teal, .green.opacity(0.8)]
}

struct Background: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors:Global.gradientColors),
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
