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
    @State private var givenCode = "1234"
    @State private var inputCode = ""
    @State private var codeSent = false
    @State private var areaCode = "+1"
    
    let areaCodes = ["+1", "+44", "+61", "+91", "+38"]

    private var isPhoneNumberValid: Bool {
        let phoneNumberPattern = "^[0-9]{10}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", phoneNumberPattern)
        return predicate.evaluate(with: phoneNumber)
    }

    var body: some View {
        VStack {
            if !codeSent {
                Text("Verify your phone number")
                        .font(.title)
                        .padding()

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

                    // Send code button
                    Button(action: {
                        codeSent = true
                    }) {
                        Text("Send Code")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isPhoneNumberValid ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                    .disabled(!isPhoneNumberValid)
            }

            if codeSent {
                Text("Verify your phone number")
                    .font(.title)
                    .padding()
                
                TextField("Enter verification code", text: $inputCode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    showNextView = true
                }) {
                    Text("Verify")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(givenCode != inputCode ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
                .disabled(givenCode != inputCode)
            }
        }
        .padding()
        .applyBackground()
        .sheet(isPresented: $needsToShareData) {
            if !Global.hasScreenTimePermission {
                PermissionsView()
            }
        }
        .fullScreenCover(isPresented: $showNextView) {
            OnboardingView()
        }
    }
}

struct Verification_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView()
    }
}
