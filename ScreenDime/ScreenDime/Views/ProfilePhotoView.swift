//
//  ProfilePhotoView.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//

import SwiftUI

struct ProfilePhotoView: View {
    @State private var showNextScreen = false
    @State private var showIconPicker = false
    @State private var showImagePicker = false
    @State private var selectedIcon = ""
    @ObservedObject var global = Global.shared
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                Text("Set Profile Photo")
                    .font(.title)
                    .padding()
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
                Image(systemName: Global.shared.selectedProfileIcon)
                    .font(.system(size: 250))
                    .frame(width:200, height:300)
                    .onTapGesture {
                        showIconPicker = true
                    }
                    .padding()
                
                HStack {
                    Button(action: {
                        showIconPicker = true
                    }) {
                        Text("Choose an icon")
                            .foregroundColor(.white)
                            .padding()
                            .cornerRadius(10)
                            .background(Color.clear)
                    }
                    
                    Button(action: {
                        showImagePicker = true
                    }) {
                        Text("Choose a photo")
                            .foregroundColor(.white)
                            .padding()
                            .cornerRadius(10)
                            .background(Color.clear)
                    }
                }
                .padding()
                
                Button(action: {
                    showNextScreen = true
                }) {
                    Text("Set Photo")
                        .font(.title2)
                        .padding()
                        .foregroundColor(.white)
                        .background(selectedIcon == Global.shared.selectedProfileIcon ? Color.gray : Color.blue)
                        .cornerRadius(10)
                        .frame(width:200)
                }
                .padding()
                .disabled(selectedIcon == Global.shared.selectedProfileIcon)
            }
            .padding()
            .applyBackground()
            .fullScreenCover(isPresented: $showNextScreen) {
                DashboardView()
            }
            .sheet(isPresented: $showIconPicker) {
                IconPickerView()
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePickerView()
            }
            
            Button(action: {
                showNextScreen = true
            }) {
                Text("Skip for now")
                    .padding(8)
                    .foregroundColor(.white)
            }
            .padding()
        }
    }
}

struct IconPickerView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var global = Global.shared
    let icons = ["person.crop.circle.fill", "person.circle", "star.fill", "heart.fill"]
    
    var body: some View {
        VStack {
            Text("Choose an Icon")
                .font(.headline)
                .padding()
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(icons, id: \.self) { icon in
                        Image(systemName: icon)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding()
                            .onTapGesture {
                                Global.shared.selectedProfileIcon = icon
                                dismiss()
                            }
                    }
                }
            }
            .padding()
            
            Button("Close") {
                dismiss()
            }
        }
    }
}
struct ImagePickerView : View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            Text("Image picker coming soon!")
                .font(.headline)
                .padding()
            
            Button(action: {
                dismiss()
            }) {
                Text("Dismiss")
                    .frame(width:120)
                    .padding()
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .background(Color.blue)
            }
        }
    }
}

struct ProfilePhoto_Previews : PreviewProvider {
    static var previews: some View {
        ProfilePhotoView()
    }
}
