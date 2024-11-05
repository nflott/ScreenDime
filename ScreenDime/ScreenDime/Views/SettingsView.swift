//
//  SettingsView.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.green, .mint, .teal, .green.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Settings")
                    .font(.largeTitle)
                    .padding()
                // Add your settings options here
            }
            .navigationBarTitle("Settings", displayMode: .inline)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
