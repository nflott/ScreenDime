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
    @State private var name = ""
    @State private var dateOfBirth = Date()
    @State private var isUsernameTaken = false
    @State private var takenUsernames = ["Luke", "Maddie", "Noah"]
    @State private var showConfirmationDialog = false
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 20) {
                    Text("Welcome to ScreenDime!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    if isUsernameTaken {
                        Text("Username is already taken")
                            .foregroundColor(.red)
                            .font(.title3)
                    }
                    
                    TextField("Enter username", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .autocapitalization(.none)
                        .onChange(of: username) {
                            isUsernameTaken = false
                        }
                        .disableAutocorrection(true)
                    
                    TextField("Enter your full name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                    
                    HStack {
                        Text("Enter your birthdate:")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                        
                        DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                            .labelsHidden()
                    }
                
                    
                    // Next Button
                    Button(action: {
                        checkUsername()
                    }) {
                        Text("Next")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(canProceed() ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                    .disabled(!canProceed())
                }
                .padding()
                .sheet(isPresented: $needsToShareData) {
                    if !Global.shared.hasScreenTimePermission {
                        PermissionsView()
                    }
                }
                .fullScreenCover(isPresented: $showNextScreen) {
                    ProfilePhotoView()
                }
                
                if showConfirmationDialog {
                    VStack(spacing: 20) {
                        Text("Confirm Username")
                            .font(.headline)
                        
                        Text("Are you sure you want to set your username to '\(username)'? You can't change it later!")
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
    
    func canProceed() -> Bool {
        let calendar = Calendar.current
        let dob = calendar.startOfDay(for: dateOfBirth)
        let today = calendar.startOfDay(for: Date())
            
        return !name.isEmpty /*&& username.count >= 3*/ && !isUsernameTaken && !name.isEmpty /*&& dob < today*/
    }
    
    func checkUsername() {
        isUsernameTaken = takenUsernames.contains(username)
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
