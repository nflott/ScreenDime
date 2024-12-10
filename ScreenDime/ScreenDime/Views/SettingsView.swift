//
//  SettingsView.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/11/24.
//

import SwiftUI

struct SettingsView: View {
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
                VStack {
                    Image(systemName: Global.shared.selectedProfileIcon)
                        .font(.system(size: 125))
                        .padding()
                        .padding([.trailing, .bottom], -10)
                    
                    Button(action: {
                        showProfilePhotoPicker.toggle()
                    }) {
                        Text("    Change")
                            .font(.headline)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                
                
                VStack {
                    HStack {
                        Text("Dastardi")
                            .fontWeight(.bold)
                            .font(.title)
                            .foregroundColor(.white)
                            .padding([.trailing], -50)
                            .padding([.top, .bottom], 10)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text("Luke Currier")
                            .font(.callout)
                            .foregroundColor(.white)
                            .padding([.top], -10)
                            .padding([.trailing], -50)
                        
                        Spacer()
                    }
                }
                Spacer()
            }
            
            Rectangle()
                .fill(Color.white) // Set the color
                .frame(height: 3) // Set the thickness
                .padding(.vertical, 5)
            
            HStack {
                Text("Choose Theme")
                    .fontWeight(.bold)
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                Spacer()
            }
            
            
            Spacer()
            
            HStack {
                Button(action: {
                    showProfilePhotoPicker.toggle()
                }) {
                    Text("Logout")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .font(.headline)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .padding()
                    
                }
            }
        }
        
       
        .navigationBarTitle("Profile", displayMode: .inline)
        .applyBackground()
        .sheet(isPresented: $showProfilePhotoPicker) {
            SettingsPhotoView()
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
