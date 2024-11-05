//
//  ProfilePhotoView.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//

import SwiftUI

struct ProfilePhotoView: View {
    @State private var showNextScreen = false
    
    var body: some View {
        VStack {
            Text("Set Profile Photo")
                .font(.title)
                .padding()
                .foregroundColor(.white)
                .fontWeight(.bold)
            
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 250))
                .frame(width:200, height:300)
            
            Button(
                action: {
                    showNextScreen = true
                }){
                    Text("Skip for now")
                        .fontWeight(.bold)
            }
        }
        .padding()
        .applyBackground()
        .fullScreenCover(isPresented: $showNextScreen) {
            DashboardView()
        }
    }
}

struct ProfilePhoto_Previews : PreviewProvider {
    static var previews: some View {
        ProfilePhotoView()
    }
}
