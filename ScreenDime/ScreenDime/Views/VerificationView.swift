//
//  VerificationView.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//

import SwiftUI

struct VerificationView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var phoneNumber = ""
    @State private var verificationCode = ""
    @State private var codeSent = false
    
    var body: some View {
        VStack {
            Text("Verify your phone number")
                .font(.title)
                .padding()
            
            TextField("Enter your phone number", text: $phoneNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .keyboardType(.phonePad)
            
            Button(action: {
                // Trigger code sending logic
                codeSent = true
            }) {
                Text("Send Code")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            
            if codeSent {
                TextField("Enter verification code", text: $verificationCode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    // Validate the code here
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Verify")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
        .padding()
    }
}

struct VerificationView_Previews: PreviewProvider {
    static var previews: some View {
        VerificationView()
    }
}
