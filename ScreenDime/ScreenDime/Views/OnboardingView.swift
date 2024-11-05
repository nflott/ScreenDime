//
//  OnboardingView.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//

import SwiftUI

struct OnboardingView: View {
    @State private var needsToShareData = false
    @State private var showNextScreen = false
    @State private var username = ""
    @State private var isUsernameTaken = false
    @State private var takenUsernames = ["Luke", "Maddie", "Noah"]
    @State private var showConfirmationDialog = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Text("Welcome to ScreenDime!")
                        .font(.largeTitle)
                        .padding()
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    if isUsernameTaken {
                        Text("Username is already taken")
                            .foregroundColor(.red)
                            .font(.title3)
                    }
                    
                    TextField("Enter username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .onChange(of: username) {
                            isUsernameTaken = false
                        }
                        .fullScreenCover(isPresented: $showNextScreen) {
                            ProfilePhotoView()
                        }
                    
                    // If username is less than 3 characters, button shouldn't work.
                    Button(action: {
                        checkUsername()
                    }) {
                        Text("Next")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(username.count < 2 || isUsernameTaken ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                    .disabled(username.count > 2 ? false : true)
                }
                .padding()
                .sheet(isPresented: $needsToShareData) {
                    if !Global.hasScreenTimePermission {
                        PermissionsView()
                    }
                }
                
                if showConfirmationDialog {
                    VStack(spacing: 20) {
                        Text("Confirm Username")
                            .font(.headline)
                        
                        Text("Are you sure you want to change your username to '\(username)'? You can't change it later!")
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        HStack {
                            Button("Cancel") {
                                showConfirmationDialog = false
                            }
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            
                            Button("Confirm") {
                                showConfirmationDialog = false
                                submitUsername()
                            }
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                    .frame(width: 350, height: 300)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .padding()
                }
            }
            .padding()
            .applyBackground()
        }
    }
    
    func checkUsername() {
        isUsernameTaken = takenUsernames.contains(username)
        
        // If the username is unique, add it to the existing list
        if !isUsernameTaken {
            showConfirmationDialog = true
        }
    }
    
    func submitUsername() {
        takenUsernames.append(username)
        showNextScreen = true
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
