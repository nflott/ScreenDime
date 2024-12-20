//
//  PermissionsView.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//

import SwiftUI

struct PermissionsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showPermissionDenialScreen = false
    @State private var showNextScreen = false
    
    var body: some View {
        VStack {
            Text("Screen Time Access")
                .font(.title)
                .padding()
                .fs(style: 0)
            
            Text("To help you track your screen usage, please allow ScreenDime to access your screen time data.")
                .multilineTextAlignment(.center)
                .padding()
                .fs(style: 0)
            
            Button(action: {
                requestScreenTimePermission()
                dismiss()
            }) {
                Text("Allow Access")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .bs(style: 1)
                    .fs(style: 0)
                    .cornerRadius(8)
            }
            .padding()
            
            Button(action: {
                showPermissionDenialScreen = true
            }) {
                Text("Don't grant access")
                    .foregroundColor(Global.shared.iconColor3)
            }
            
        }
        .padding()
        .applyBackground()
        .sheet(isPresented: $showPermissionDenialScreen) {
            PermissionDenialView()
        }
    }
    
    func requestScreenTimePermission() {
        // Handle actual screen time permission logic here
        // Global.hasScreenTimePermission = true
    }
}

struct Permissions_Previews: PreviewProvider {
    static var previews: some View {
        PermissionsView()
    }
}
