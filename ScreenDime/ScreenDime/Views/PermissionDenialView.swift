//
//  PermissionDenialView.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/5/24.
//

import SwiftUI

struct PermissionDenialView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showPermissionsView = false
    
    public var body: some View {
        VStack {
            Text("In order to work, ScreenDime needs to access your phone's screen time.")
                .font(.title2)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
            
            Text("You'll be able to manage who sees it, and we won't share your data with anyone!")
                .font(.title2)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: {
                dismiss()
            }) {
                Text("Try Again")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .applyBackground()
        .sheet(isPresented: $showPermissionsView) {
            PermissionsView()
        }
    }
}

struct PermissionDenial_Previews: PreviewProvider {
    static var previews: some View {
        PermissionDenialView()
    }
}
