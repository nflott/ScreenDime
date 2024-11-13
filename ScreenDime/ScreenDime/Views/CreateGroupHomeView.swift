//
//  CreateGroupHomeView.swift
//  ScreenDime
//
//  Created by Noah Flott on 11/13/24.
//

import SwiftUI

struct CreateGroupHomeView: View {
    @State private var createGroup = false
    
    var body: some View {
        VStack {
            Text("Create Group")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
            
            Spacer()
            
            Image(systemName: "plus.circle")
                .font(.system(size: 250))
                .frame(width:200, height:300)
                .onTapGesture {
                    createGroup.toggle()
                }
                .padding()
        }
        .navigationBarTitle("Profile", displayMode: .inline)
    }
}

struct CreateGroup_Preview: PreviewProvider {
    static var previews: some View {
        CreateGroupHomeView()
    }
}
