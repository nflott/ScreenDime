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
        VStack {
            HStack {
                Button(action: {
                    showingSettings.toggle() // Toggle the modal display
                }) {
                    Image(systemName: "gear")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 40)
                        .foregroundColor(.gray)
                }
                .padding()
                
                Spacer() // Pushes the button to the left
            }
            .padding(.top) // Padding at the top of the HStack
            
            // The rest of your dashboard content goes here
            Text("Your Dashboard")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
            
            Spacer() // Pushes the content to the center
        }
        .applyBackground()
        .sheet(isPresented: $showingSettings) {
            SettingsView().applyBackground()
        }
        
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
