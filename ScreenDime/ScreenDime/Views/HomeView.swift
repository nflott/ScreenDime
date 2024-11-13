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
        TabItem(title: Global.shared.selectedGroup, icon: "plus.circle", view: AnyView(GroupView(groupName:Global.shared.selectedGroup)))
    ]
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        showingSettings.toggle()
                    }) {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                            .padding([.leading, .trailing], 10)
                    }
                    .padding()
                    
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
            
            VStack{
                Text(tabs[selectedTab].title)
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding([.top], 26)
                
                Spacer()
            }
        }
    }
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
