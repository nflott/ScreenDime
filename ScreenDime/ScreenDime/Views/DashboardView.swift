//
//  DashboardView.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//

import SwiftUI

struct DashboardView: View {
    @State private var showingSettings = false

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(action: {
                        showingSettings.toggle() // Toggle the modal display
                    }) {
                        Image(systemName: "gear") // Using the SF Symbols gear icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 40) // Adjust the size as needed
                            .foregroundColor(.gray) // Change color as needed
                    }
                    .padding() // Add some padding around the button
                    
                    Spacer() // Pushes the button to the left
                }
                .padding(.top) // Padding at the top of the HStack
                
                // The rest of your dashboard content goes here
                Text("Hello, World!")
                    .font(.largeTitle)
                    .padding()
                
                Spacer() // Pushes the content to the center
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView()
            }
        }
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
