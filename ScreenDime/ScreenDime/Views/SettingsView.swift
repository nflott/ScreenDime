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
                            .fs(style: 2)
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
                    .fs(style: 0)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
            }
            
            HStack {
                VStack {
                    Global.shared.selectedProfileIcon.toImage()
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 125, height: 125)
                        .clipShape(Circle())
                        .contentShape(Circle())
                        .padding()
                    
                    Button(action: {
                        showProfilePhotoPicker.toggle()
                    }) {
                        Text("    Change")
                            .font(.headline)
                            .fs(style: 0)
                            .cornerRadius(8)
                    }
                }
                
                
                VStack {
                    HStack {
                        Text("Dastardi")
                            .fontWeight(.bold)
                            .font(.title)
                            .fs(style: 0)
                            .padding([.trailing], -50)
                            .padding([.top, .bottom], 10)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text("Luke Currier")
                            .font(.callout)
                            .fs(style: 0)
                            .padding([.top], -10)
                            .padding([.trailing], -50)
                        
                        Spacer()
                    }
                }
                Spacer()
            }
            
            Rectangle()
                .fill(Global.shared.textColor)
                .frame(height: 3)
                .padding(.vertical, 5)
            
            HStack {
                Text("Choose Theme")
                    .fontWeight(.bold)
                    .font(.title)
                    .fs(style: 0)
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
                        .fs(style: 0)
                        .fs(style: 0)
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