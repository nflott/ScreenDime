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
    @State private var showWheelPicker = false
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
                        .fs(style: 1)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    if isUsernameTaken {
                        Text("Username is already taken")
                            .fs(style: 4)
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
                    
                    ZStack {
                        HStack {
                            Text("Enter your birthdate:")
                                .fs(style: 1)
                                .fontWeight(.bold)
                            
                            Button(action: {
                                showWheelPicker = true
                            }) {
                                Text(formatDate(date: dateOfBirth))
                                    .fs(style: 2)
                            }
                        }
                        
                        if showWheelPicker {
                            VStack {
                                DatePicker("Select Date", selection: $dateOfBirth, displayedComponents: .date)
                                    .datePickerStyle(.wheel)
                                    .labelsHidden()
                                
                                Button("Done") {
                                    showWheelPicker = false
                                }
                                .padding()
                                .fs(style: 1)
                                .fs(style: 1)
                                .cornerRadius(8)
                            }
                            .padding()
                            .applyBackground()
                            .cornerRadius(12)
                            .shadow(radius: 10)
                        }
                    }
                
                    
                    // Next Button
                    Button(action: {
                        checkUsername()
                    }) {
                        Text("Next")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(canProceed() ? Global.shared.iconColor1 : Color.gray)
                            .fs(style: 1)
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
                    OnboardingPhotoView()
                }
                
                if showConfirmationDialog {
                    VStack(spacing: 20) {
                        Text("Confirm Username")
                            .font(.headline)
                        
                        Text("Are you sure you want to set your username to \(username)?")
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        HStack {
                            Button("Cancel") {
                                showConfirmationDialog = false
                            }
                            .padding()
                            .fs(style: 3)
                            .fs(style: 1)
                            .cornerRadius(8)
                            
                            Button("Confirm") {
                                showConfirmationDialog = false
                                submitUsername()
                            }
                            .padding()
                            .fs(style: 2)
                            .fs(style: 1)
                            .cornerRadius(8)
                        }
                    }
                    .frame(width: 350, height: 300)
                    .background(Global.shared.backgroundColor[0])
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .padding()
                }
            }
            .padding()
            .applyBackground()
        }
    }
    
    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy" // Truncated month format
        return formatter.string(from: date)
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
        //takenUsernames.append(username)
        showNextScreen = true
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
