//
//  SettingsPhotoView.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//

import SwiftUI
import PhotosUI

struct SettingsPhotoView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showNextScreen = false
    @State private var showIconPicker = false
    @State private var selectedIcon: Picture? = .systemIcon("")
    @ObservedObject var global = Global.shared
    @State private var showConfirmationDialog = false
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack {
                Text("Set Profile Photo")
                    .font(.title)
                    .padding()
                    .fs(style: 0)
                    .fontWeight(.bold)
                
                Global.shared.selectedProfileIcon.toImage()
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .contentShape(Circle())
                    .padding()
                    .onTapGesture {
                        showIconPicker = true
                    }
                
                HStack {
                    Button(action: {
                        showIconPicker = true
                    }) {
                        Text("Choose an Icon")
                            .fs(style: 1)
                            .padding()
                            .cornerRadius(10)
                            .background(Color.clear)
                            .frame(width:150)
                            .bold()
                    }
                    
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()) {
                            Text("Choose a Photo")
                                .fs(style: 1)
                                .bold()
                        }
                        .onChange(of: selectedItem) { newItem in
                            Task {
                                if let selectedItem = newItem {
                                    if let assetData = try? await selectedItem.loadTransferable(type: Data.self),
                                       let image = UIImage(data: assetData) {
                                        global.selectedProfileIcon = .userImage(image)
                                    }
                                }
                            }
                        }
                        .padding()
                }
                .padding()
                
                Button(action: {
                    dismiss()
                }) {
                    Text("Done")
                        .font(.title2)
                        .padding()
                        .fs(style: 0)
                        .bs(style: 1)
                        .cornerRadius(10)
                        .frame(width:200)
                }
                .padding()
            }
            .padding()
            .applyBackground()
            .fullScreenCover(isPresented: $showNextScreen) {
                HomeView()
            }
            .sheet(isPresented: $showIconPicker) {
                IconPickerView()
            }
            
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .fs(style: 1)
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
