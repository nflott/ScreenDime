//
//  VerificationView.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//

import SwiftUI

struct VerificationView: View {
    @State private var needsToShareData = true
    @State private var showNextView = false
    @State private var phoneNumber = ""
    @State private var givenCode = 123
    @State private var inputCode = ""
    @State private var codeSent = false
    @State private var areaCode = "+1"
    @State private var showCodeDialog = false
    @State private var skipToHome: Bool = false
    
    let areaCodes = ["+1", "+44", "+61", "+91", "+38"]

    private var isPhoneNumberValid: Bool {
        let phoneNumberPattern = "^[0-9]{10}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneNumberPattern)
        return predicate.evaluate(with: phoneNumber)
    }

    var body: some View {
        ZStack {
            VStack {
                if !codeSent {
                    Text("Verify your phone number")
                        .font(.title)
                        .padding()
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing:0) {
                        Picker("Select Area Code", selection: $areaCode) {
                            ForEach(areaCodes, id: \.self) { code in
                                Text(code).tag(code)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        
                        TextField("Enter your phone number", text: $phoneNumber)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.phonePad)
                    }
                    .padding()
                    
                    Button(action: {
                        codeSent = true
                        givenCode = getRandomCode()
                        showCodeDialog = true
                    }) {
                        Text("Send Code")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isPhoneNumberValid ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .disabled(!isPhoneNumberValid)
                }
                
                if codeSent {
                    Text("Verify your phone number")
                        .font(.title)
                        .padding()
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    TextField("Enter verification code", text: $inputCode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: {
                        showNextView = true
                    }) {
                        Text("Verify")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(String(givenCode) != inputCode ? Color.gray : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                    .disabled(String(givenCode) != inputCode)
                    
                    Button(action: {
                        givenCode = getRandomCode()
                        showCodeDialog = true
                    }) {
                        Text("Send another code")
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding()
            .applyBackground()
            .sheet(isPresented: $needsToShareData) {
                if !Global.shared.hasScreenTimePermission {
                    PermissionsView()
                }
            }
            .fullScreenCover(isPresented: $showNextView) {
                OnboardingView()
            }
            .fullScreenCover(isPresented: $skipToHome) {
                HomeView()
            }
            
//            VStack {
//                HStack {
//                    Button(action: {
//                        skipToHome.toggle()
//                    }) {
//                        Text("Skip Onboarding")
//                            .font(.title3)
//                            .foregroundColor(.white)
//                    }
//                    Spacer()
//                }
//                Spacer()
//            }
            
            if showCodeDialog {
                VStack(spacing: 20) {
                    Text("Your code is \(givenCode)!")
                        .multilineTextAlignment(.center)
                        .padding()
                        
                    Button("OK") {
                        showCodeDialog = false
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .frame(width: 200, height: 150)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 10)
                .padding()
            }
        }
        .padding()
        .applyBackground()
    }
    
    func getRandomCode() -> Int {
        let fourDigits = (0..<3).map { _ in Int.random(in: 0...9) }
        let value = fourDigits.reduce(0) { $0 * 10 + $1 }
        return value
    }
}

struct Verification_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView()
    }
}
