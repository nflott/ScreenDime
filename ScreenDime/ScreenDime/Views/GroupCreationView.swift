//
//  GroupCreationView.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/13/24.
//

import SwiftUI

struct GroupCreationView: View {
    var body: some View {
        VStack {
            Text("Create Group")
                .font(.largeTitle)
                .padding()
        }
        .navigationBarTitle("Create Group", displayMode: .inline)
        .applyBackground()
    }
}

struct GroupCreation_Previews: PreviewProvider {
    static var previews: some View {
        GroupCreationView()
    }
}
