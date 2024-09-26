//
//  ContentView.swift
//  ScreenDime
//
//  Created by Luke Currier on 9/24/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showNotifications = false
    @State private var showCreateOverlay = false
    @State private var selectedTab = 0
    
    var body: some View {
        ZStack {
            // Main TabView for navigation
            TabView(selection: $selectedTab) {
                HomeView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                    .tag(0)
                
                GroupsView()
                    .tabItem {
                        Image(systemName: "person.3.fill")
                        Text("Groups")
                    }
                    .tag(1)
                
                Color.clear // Placeholder for Create tab
                    .tabItem {
                        Image(systemName: "plus.app.fill")
                        Text("Create")
                    }
                    .tag(2)
                
                StatisticsView()
                    .tabItem {
                        Image(systemName: "chart.bar.fill")
                        Text("Statistics")
                    }
                    .tag(3)
            }
            .accentColor(.teal)
            
            // Notification bell button
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showNotifications.toggle()
                        }
                    }) {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.teal)
                            .clipShape(Circle())
                    }
                }
                .padding()
                Spacer()
            }
            
            // Create overlay
            if showCreateOverlay {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showCreateOverlay = false
                        }
                    }
                CreateOverlay(isPresented: $showCreateOverlay)
                    .transition(.move(edge: .bottom))
            }
            
            // Clickable area to dismiss notifications
            if showNotifications {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showNotifications = false
                        }
                    }
            }
        }
        .onChange(of: selectedTab) { oldValue, newValue in
            if newValue == 2 {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showCreateOverlay = true
                    selectedTab = oldValue
                }
            }
        }
        .overlay(
            NotificationSidebar(isPresented: $showNotifications)
        )
    }
}

struct HomeView: View {
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.3), Color.teal.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            // Welcome text
            Text("Welcome to Your Dashboard")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .background(Color.green.opacity(0.7))
                .cornerRadius(10)
        }
    }
}

struct GroupsView: View {
    var body: some View {
        ZStack {
            // Background gradient (consistent with HomeView)
            LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.3), Color.teal.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            Text("Groups View")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .background(Color.green.opacity(0.7))
                .cornerRadius(10)
        }
    }
}

struct StatisticsView: View {
    var body: some View {
        ZStack {
            // Background gradient (consistent with HomeView)
            LinearGradient(gradient: Gradient(colors: [Color.green.opacity(0.3), Color.teal.opacity(0.3)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            Text("Statistics View")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .background(Color.green.opacity(0.7))
                .cornerRadius(10)
        }
    }
}

struct CreateOverlay: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 20) {
                Text("Create a Bet")
                    .font(.title)
                    .fontWeight(.bold)
                
                Button(action: {
                    // Action for creating a bet
                }) {
                    Text("Select Group")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.teal)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isPresented = false
                    }
                }) {
                    Text("Cancel")
                        .foregroundColor(.red)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
        }
        // Ensure the overlay takes up the full screen width
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .transition(.move(edge: .bottom))
    }
}

struct NotificationSidebar: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                VStack {
                    Text("Notifications")
                        .font(.title)
                        .padding()
                    
                    List {
                        Text("Notification 1")
                        Text("Notification 2")
                        Text("Notification 3")
                    }
                }
                .frame(width: 300)
                .background(Color.green)
                .offset(x: isPresented ? 0 : 300)
                .animation(.easeInOut(duration: 0.3), value: isPresented)
            }
            // Remove the background color here to allow tapping outside to dismiss
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
