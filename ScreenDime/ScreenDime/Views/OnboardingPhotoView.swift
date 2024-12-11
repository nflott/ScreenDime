//
//  OnboardingPhotoView.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//

import SwiftUI
import PhotosUI

struct OnboardingPhotoView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showNextScreen = false
    @State private var showIconPicker = false
    @State private var selectedIcon: Picture? = .systemIcon("")
    @ObservedObject var global = Global.shared
    @State private var showConfirmationDialog = false
    @State private var selectedItem: PhotosPickerItem? // Binding to PhotosPickerItem
    
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
                    .aspectRatio(contentMode: .fill) // Change from .scaledToFit to .fill
                    .frame(width: 150, height: 150) // Set fixed frame
                    .clipShape(Circle()) // Clip into a circle
                    .contentShape(Circle()) // Important for tap gesture on the entire circle
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
                    showConfirmationDialog = true
                }) {
                    Text("Finish Profile")
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
            
            if showConfirmationDialog {
                VStack {
                    Spacer()
                    VStack() {
                        Text("Confirm Profile Creation")
                            .font(.headline)
                        
                        Text("Are you ready to get started?")
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        HStack {
                            Spacer()
                            Button("Not Yet") {
                                showConfirmationDialog = false
                            }
                            .padding()
                            .padding([.leading, .trailing], 15)
                            .background(Global.shared.iconColor3)
                            .fs(style: 0)
                            .cornerRadius(8)
                                                        
                            Button("Let's Go!") {
                                showNextScreen = true
                                showConfirmationDialog = false
                            }
                            .padding()
                            .padding([.leading, .trailing], 15)
                            .background(Global.shared.iconColor2)
                            .fs(style: 0)
                            .cornerRadius(8)
                            Spacer()
                        }
                    }
                    .frame(width: 350, height: 300)
                    .background(Global.shared.backgroundColor[0])
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .padding()
                    Spacer()
                }
            }
        }
    }
}

struct IconPickerView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var global = Global.shared
    let icons = [
        "person.crop.circle.fill", "person.circle", "star.fill",
        "flame.circle.fill", "flag.2.crossed.circle", "sun.max.fill", "heart.circle.fill",
        "moon.fill", "snowflake", "circle.hexagongrid.circle.fill",
        "infinity.circle.fill", "hurricane.circle.fill", "line.3.crossed.swirl.circle",
        "theatermasks.circle", "theatermasks.circle.fill", "lightbulb.circle", "poweroutlet.type.f",
        "toilet.circle", "tent.2.circle", "mountain.2.circle"
    ]
    
    let columns = [
        GridItem(.adaptive(minimum: 60)) // Adjust the minimum size for the grid items
    ]
    
    var body: some View {
        VStack {
            Text("Choose an Icon")
                .font(.headline)
                .padding()
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(icons, id: \.self) { icon in
                        Image(systemName: icon)
                            .resizable()
                            .scaledToFit() // Ensure the icon fits within the circle
                            .frame(width: 50, height: 50) // Same size for all icons
                            .clipShape(Circle()) // Crop icon to a circle
                            .padding()
                            .background(
                                Circle()
                                    .fill(global.selectedProfileIcon.isSystemIcon(icon) ? Global.shared.iconColor1 : Color.clear)
                            )
                            .onTapGesture {
                                global.selectedProfileIcon = .systemIcon(icon)
                                dismiss()
                            }
                    }
                }
                .padding()
            }
            
            Button("Close") {
                dismiss()
            }
            .padding()
            .bs(style: 1)
            .fs(style: 0)
            .cornerRadius(8)
        }
        .applyBackground()
    }
}

struct OnboardingPhoto_Previews : PreviewProvider {
    static var previews: some View {
        OnboardingPhotoView()
    }
}
