//
//  SettingsPhotoView.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//

import SwiftUI

struct SettingsPhotoView: View {
    @Environment(\.dismiss) var dismiss
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
                    dismiss()
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

struct SettingsPhoto_Previews : PreviewProvider {
    static var previews: some View {
        SettingsPhotoView()
    }
}
