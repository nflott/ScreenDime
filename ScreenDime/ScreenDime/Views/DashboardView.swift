//
//  DashboardView.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//

import SwiftUI

struct DashboardView: View {
    @State private var showingSettings = false
    @State var backgroundOffset: Int = 0
    @State private var rectangleCount = 2 // Initial count of rectangles
    @State private var selectedPage = 0
    private let totalPages = 4 // Total number of pages

    let pageTitles = ["Dashboard 1", "Dashboard 2", "Dashboard 3", "Dashboard 4"] // Titles for each page

    var body: some View {
        
        VStack {
            GeometryReader { g in
                ZStack {
                    // Center the Text within the screen width
                    Text(pageTitles[selectedPage])
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: g.size.width, height: 40, alignment: .center)
                    
                    // Align the Button to the left
                    HStack {
                        Button(action: {
                            showingSettings.toggle() // Toggle the modal display
                        }) {
                            Image(systemName: "gear")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        .padding()
                        
                        Spacer() // Push the button to the left
                    }
                }
                .padding(.top) // Padding at the top of the entire ZStack
                
                TabView(selection: $selectedPage) {
                    ForEach(0..<totalPages, id: \.self) { pageIndex in
                        ScrollView(.vertical, showsIndicators: true) {
                            VStack(spacing: 0) {
                                ForEach(0..<rectangleCount, id: \.self) { _ in
                                    Rectangle()
                                        .fill(Color.black.opacity(0.7))
                                        .frame(width: g.size.width-10, height: 200)
                                        .cornerRadius(5)
                                        .padding(5)
                                        .frame(maxWidth: .infinity, maxHeight: 210)
                                }
                                // Plus icon button
                                Button(action: {
                                    rectangleCount += 1 // Increment the count when tapped
                                }) {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.blue) // Background color for the button
                                        .cornerRadius(20) // Make it circular
                                }
                                .padding(.bottom, 20) // Bottom padding for the button
                                
                                Spacer()
                                    .frame(height: 100) // Additional scrollable space below the button
                            }
                        }
                        .tag(pageIndex) // Set tag to identify page in TabView
                    }
                }
                .frame(height: g.size.height * 0.8) // Adjust height if needed
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always)) // Enable paging with dots indicator
                .padding(.top, 90)
                .onChange(of: selectedPage) { newValue in
                    backgroundOffset = newValue // Update the backgroundOffset whenever the page changes
                }
            
                ZStack {
                    Rectangle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 400, height: 70)
                        .cornerRadius(10)
                    
                    HStack {
                        ForEach(0..<totalPages, id: \.self) { index in
                            Circle()
                                .fill(self.getColorForIndex(index))
                                .frame(width: backgroundOffset == index ? 40 : 20, height: backgroundOffset == index ? 40 : 20)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 3)
                                )
                                .animation(.default, value: backgroundOffset)
                        }
                    }
                }
                .position(x: g.size.width / 2, y: g.size.height / 1.1)
            }
        }
        .applyBackground()
        .sheet(isPresented: $showingSettings) {
            SettingsView().applyBackground()
        }
    }
    
    // Helper function to determine color based on index
    private func getColorForIndex(_ index: Int) -> Color {
        switch index {
        case 0: return Color.black
        case 1: return Color.red
        case 2: return Color.blue
        case 3: return Color.yellow
        default: return Color.gray
        }
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
