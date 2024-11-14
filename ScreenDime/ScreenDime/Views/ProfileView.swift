//
//  ProfileView.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/11/24.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject private var global = Global.shared
    
    @State var showProfilePhotoPicker: Bool = false
    
    var body: some View {
        VStack {
            Text("Your Profile")
                .font(.largeTitle)
                .padding()
                .foregroundColor(.white)
                .fontWeight(.bold)
            
            Spacer()
            
            HStack {
                Button(action: {
                    showProfilePhotoPicker.toggle()
                }) {
                    Text("Change profile picture")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .font(.headline)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .padding()
                    
                }
                
            }
            .padding(.bottom, 150)
            
            Text("More options coming soon!")
                .fontWeight(.bold)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.bottom, 400)
        }
        
       
        .navigationBarTitle("Profile", displayMode: .inline)
        .applyBackground()
        .sheet(isPresented: $showProfilePhotoPicker) {
            ProfilePhotoView()
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
