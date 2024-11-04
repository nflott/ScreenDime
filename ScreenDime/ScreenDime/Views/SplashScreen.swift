//
//  SplashScreen.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//

import SwiftUI

struct SplashScreen: View {
    // Properties to control navigation and opacity
    @State private var opacity = 1.0
    @State private var navigateToNextScreen = false
    
    // User's app status - these would be based on your app's state management or a data model
    @AppStorage("hasOnboarded") private var hasOnboarded: Bool = false
    @AppStorage("hasScreenTimePermission") private var hasScreenTimePermission: Bool = false
    
    var body: some View {
        ZStack {
            // Splash content (e.g., logo or app name)
            VStack {
                Text("ScreenDime")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .opacity(opacity)
                    .onAppear {
                        // Start fade-out animation
                        withAnimation(.easeInOut(duration: 2)) {
                            opacity = 0.0
                        }
                        
                        // Navigate to the next screen after the animation
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            navigateToNextScreen = true
                        }
                    }
            }
            // Conditionally show the next screen based on the user's onboarding status
            if navigateToNextScreen {
                if !hasOnboarded {
                    OnboardingView()  // User hasn't completed onboarding
                } else if !hasScreenTimePermission {
                    PermissionsView()  // User hasn't granted screen time permission
                } //else {
                    //Dashboard()  // User is fully onboarded and has permissions
                //}
            }
        }
        .transition(.opacity)
    }
}

struct SplashScreen_Preview: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
