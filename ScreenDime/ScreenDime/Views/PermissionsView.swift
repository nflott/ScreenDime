//
//  PermissionsView.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//

import SwiftUI

struct PermissionsView: View {
    @Environment(\.dismiss) var dismiss  // Environment property to dismiss the modal
    @State private var showNextScreen = false
    
    var body: some View {
        VStack {
            Text("Screen Time Access")
                .font(.title)
                .padding()
            
            Text("To help you track your screen usage, please allow ScreenDime to access your screen time data.")
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: {
                requestScreenTimePermission()
                dismiss()
            }) {
                Text("Allow Access")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            
        }
        .padding()
        .applyBackground()
    }
    
    func requestScreenTimePermission() {
        // Handle actual screen time permission logic here
        //Global.hasScreenTimePermission = true
    }
}

struct Permissions_Previews: PreviewProvider {
    static var previews: some View {
        PermissionsView()
    }
}
