//
//  OnboardingPhotoView.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//

import SwiftUI

struct OnboardingPhotoView: View {
    @Environment(\.dismiss) var dismiss
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
                    .fs(style: 1)
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
                            .fs(style: 1)
                            .padding()
                            .cornerRadius(10)
                            .background(Color.clear)
                    }
                    
                    Button(action: {
                        showImagePicker = true
                    }) {
                        Text("Choose a photo")
                            .fs(style: 1)
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
                        .fs(style: 1)
                        .background(selectedIcon == Global.shared.selectedProfileIcon ? Color.gray : Global.shared.iconColor1)
                        .cornerRadius(10)
                        .frame(width:200)
                }
                .padding()
                .disabled(selectedIcon == Global.shared.selectedProfileIcon)
            }
            .padding()
            .applyBackground()
            .fullScreenCover(isPresented: $showNextScreen) {
                HomeView()
            }
            .sheet(isPresented: $showIconPicker) {
                IconPickerView()
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePickerView()
            }
            
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
                        .padding(.leading, 10)
                        .padding(.trailing)
                }
                .padding()
                
                Spacer()
            }
            
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
                    .fs(style: 1)
                    .fs(style: 1)
            }
        }
    }
}

struct OnboardingPhoto_Previews : PreviewProvider {
    static var previews: some View {
        OnboardingPhotoView()
    }
}
