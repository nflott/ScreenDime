//
//  GroupView.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//

import SwiftUI

struct GroupView: View {
    var groupName: String
    
    var body: some View {
        VStack {
            Text("\(groupName)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
            
            ScrollView {
                ForEach(0..<5, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.black.opacity(0.7))
                        .frame(height: 150)
                        .cornerRadius(8)
                        .padding(5)
                }
            }
        }
        .applyBackground()
    }
}
