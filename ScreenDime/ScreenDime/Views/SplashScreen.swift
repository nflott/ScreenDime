//
//  SplashScreen.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//

import SwiftUI

struct SplashScreen: View {
    @State private var opacity = 1.0
    @State private var showNextScreen = false
    
    var body: some View {
        ZStack {
            VStack {
                
                Text("ScreenDime")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .opacity(opacity)
                    .onAppear {
                        // Start fade-out animation
                        withAnimation(.easeInOut(duration: 25)) {
                            opacity = 0.0
                        }
                        
                        //Navigate to the next screen after the animation
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showNextScreen = true
                        }
                    }
            }
            .fullScreenCover(isPresented: $showNextScreen) {
                if !Global.shared.hasOnboarded {
                    VerificationView()
                } else {
                    HomeView()
                }
            }
        }
        .applyBackground()
        .transition(.opacity)
    }
}


struct SplashScreen_Preview: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
