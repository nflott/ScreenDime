//
//  HomeView.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/11/24.
//

import SwiftUI

struct HomeView: View {
    @State private var showingSettings = false
    @State private var selectedTab = 0
    @State private var tabs: [TabItem] = [
        TabItem(title: "Dashboard", icon: "house.fill", view: AnyView(DashView())),
        TabItem(title: "Create", icon: "plus.circle", view: AnyView(CreateGroupHomeView()))
    ]
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    showingSettings.toggle()
                }) {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                        .padding([.leading, .trailing], 10)
                        .padding([.top, .bottom], 8)
                }
                
                Spacer()
                
                Text(tabs[selectedTab].title)
                    .font(.title)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer()
            }
            .padding([.top, .bottom], 10)

            TabView(selection: $selectedTab) {
                ForEach(Array(tabs.enumerated()), id: \.element.id) { index, tab in
                    tab.view
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            HStack {
                ForEach(0..<tabs.count, id: \.self) { index in
                    Circle()
                        .fill(index == selectedTab ? Color.blue : Color.gray)
                        .frame(width: 15, height: 15)
                        .onTapGesture {
                            selectedTab = index
                        }
                }
            }
        }
        .applyBackground()
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
