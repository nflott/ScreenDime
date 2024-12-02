//
//  ProfileView.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/11/24.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject private var global = Global.shared
    
    @Environment(\.dismiss) var dismiss
    
    @State var showProfilePhotoPicker: Bool = false
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .foregroundColor(.blue)
                            .fontWeight(.bold)
                            .padding(.leading, 20)
                            .padding(.trailing, 25)
                    }
                    
                    Spacer()
                }
                .padding()
                
                Text("App Settings")
                    .font(.largeTitle)
                    .padding()
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
            }
            
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
