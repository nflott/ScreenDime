//
//  BetViewModel.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//
import SwiftUI

struct BetViewModel: View {
    @State private var showNextScreen = false
    @State private var betName = ""
    
    var body: some View {
        VStack {
            Text("Create a bet")
                .font(.title)
                .padding()
                .foregroundColor(.white)
                .fontWeight(.bold)
            
            TextField("Name of your bet", text: $betName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .fullScreenCover(isPresented: $showNextScreen) {
                    ProfilePhotoView()
                }
//            Image(systemName: "person.crop.circle.fill")
//                .font(.system(size: 250))
//                .frame(width:200, height:300)
            
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

struct BetViewModel_Preview: PreviewProvider {
    static var previews: some View {
        BetViewModel()
    }
}
