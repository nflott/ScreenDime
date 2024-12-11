//
//  Icon.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/19/24.
//

import SwiftUI

struct Icon: View {
    @State private var opacity = 1.0
    @State private var showNextScreen = false
    
    var body: some View {
        VStack {
            Text("SC")
                .font(.custom("", size: 128))
                .fontWeight(.bold)
                .fs(style: 0)
        }
        .applyBackground()
    }
}


struct Icon_Preview: PreviewProvider {
    static var previews: some View {
        Icon()
    }
}
