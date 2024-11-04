//
//  OnboardingView.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//

import SwiftUI

struct OnboardingView: View {
    @State private var showPermissionsScreen = false
    @State private var showVerificationScreen = false
    @State private var username = ""
    
    var body: some View {
        VStack {
            Text("Welcome to ScreenDime!")
                .font(.largeTitle)
                .padding()
            
            TextField("Enter username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                showPermissionsScreen = true
            }) {
                Text("Next")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .padding()
        .sheet(isPresented: $showPermissionsScreen) {
            PermissionsView()
        }
        .sheet(isPresented: $showVerificationScreen) {
            VerificationView()
        }
    }
}



struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
