//
//  PermissionsView.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//

import SwiftUI

struct PermissionsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var permissionGranted = false
    
    var body: some View {
        VStack {
            Text("Screen Time Access")
                .font(.title)
                .padding()
            
            Text("To help you track your screen usage, please allow ScreenDime to access your screen time data.")
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: {
                // Here you'd call a method in your service to request permission
                requestScreenTimePermission()
                permissionGranted = true
            }) {
                Text("Allow Access")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(permissionGranted ? Color.green : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            
            if permissionGranted {
                Button(action: {
                    // Dismiss the view after permission is granted
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
        .padding()
    }
    
    func requestScreenTimePermission() {
        // This function will eventually handle the actual screen time permissions
        print("Screen time permission requested")
    }
}

struct Permissions_Previews: PreviewProvider {
    static var previews: some View {
        PermissionsView()
    }
}
