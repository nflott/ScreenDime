//
//  GroupSettingsView.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/13/24.
//

import SwiftUI

struct GroupSettingsView: View {
    var body: some View {
        VStack {
            Text("Group Settings")
                .font(.largeTitle)
                .padding()
        }
        .navigationBarTitle("Group Settings", displayMode: .inline)
        .applyBackground()
    }
}

struct GroupSettings_Previews: PreviewProvider {
    static var previews: some View {
        GroupSettingsView()
    }
}
