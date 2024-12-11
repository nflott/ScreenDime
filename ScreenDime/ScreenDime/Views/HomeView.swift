//
//  HomeView.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/11/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var global = Global.shared

    @State private var showingGroupSettings = false
    @State private var showingGroupCreation = false
    @State private var showingProfile = false
    @State private var showingGroupSelector = false
    @State private var showingBetCreation = false
    @State private var selectedTab = 0
    @State private var tabs: [TabItem] = [
        TabItem(title: "Dashboard", icon: "house.fill", view: AnyView(DashView())),
        TabItem(title: Global.shared.selectedGroup, icon: "plus.circle", view: AnyView(GroupView(groupName:Global.shared.selectedGroup)))

    ]
        
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    if(selectedTab == 0) {
                        Button(action: {
                            showingProfile.toggle()
                        }) {
                            Image(systemName: Global.shared.selectedProfileIcon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .fs(style: 1)
                                .padding([.leading, .trailing], 10)
                        }
                        .padding()
                        .padding([.top, .bottom], -30)
                        
                        Spacer()
                    }
                    else {
                        Button(action: {
                            showingGroupSettings.toggle()
                        }) {
                            Image(systemName: "person.2.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .fs(style: 1)
                                .padding([.leading, .trailing], 10)
                        }
                        .padding()
                        .padding([.top, .bottom], -30)
                        
                        Spacer()
                    }
                }
                .padding([.top, .bottom], 10)
                
                TabView(selection: $selectedTab) {
                    ForEach(Array(tabs.enumerated()), id: \.element.id) { index, tab in
                        tab.view
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(height: 725)
                
                HStack {
                    ForEach(0..<tabs.count, id: \.self) { index in
                        Circle()
                            .fill(index == selectedTab ? Global.shared.iconColor1 : Color.gray)
                            .frame(width: 15, height: 15)
                            .onTapGesture {
                                selectedTab = index
                            }
                    }
                }
            }
            .applyBackground()
            .sheet(isPresented: $showingGroupSettings) {
                GroupSettingsView()
            }
            .sheet(isPresented: $showingGroupCreation) {
                GroupCreationView()
            }
            .sheet(isPresented: $showingProfile) {
                SettingsView()
            }
            .sheet(isPresented: $showingBetCreation) {
                CreateBetView()
            }
            
            // Display the group name or settings icon based on the tab
            if selectedTab == 0 {
                VStack {
                    Text(tabs[selectedTab].title)
                        .font(.largeTitle)
                        .fs(style: 1)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .top)
                        .padding([.top], 26)
                        .padding([.top, .bottom], -10)
                    
                    Spacer()
                }
            }
            else {
                VStack {
                    Button(action: {
                        showingGroupSelector.toggle()
                    }) {
                        HStack(spacing: 4) {
                            Text(global.selectedGroup)
                                .font(.largeTitle)
                                .fs(style: 1)
                                .fontWeight(.bold)
                                .underline()

                            Image(systemName: "arrowtriangle.down.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 10, height: 10)
                                .fs(style: 1)
                        }
                        .frame(maxWidth: .infinity, alignment: .top)
                        .padding([.top], 26)
                        .padding([.top, .bottom], -10)
                    }
                    .buttonStyle(PlainButtonStyle())
                    

                    if showingGroupSelector {
                        dropdownMenu()
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .animation(.easeInOut, value: showingGroupSelector)
                    }

                    Spacer()
                }
            }

            if selectedTab == 1 {
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            showingBetCreation.toggle()
                        }) {
                            Circle()
                                .fill(Global.shared.iconColor1)
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Image(systemName: "plus")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        .fs(style: 1)
                                )
                                .shadow(radius: 10)
                        }
                        .padding([.bottom, .trailing], 20)
                    }
                }
            }
        }
        .onChange(of: global.selectedGroup) {
            tabs[1].title = global.selectedGroup
        }
    }

    
    @ViewBuilder
    private func dropdownMenu() -> some View {
       VStack {
           ForEach(Global.shared.groupPages, id: \.name) { group in
               Button(action: {
                   Global.shared.selectedGroup = group.name
                   showingGroupSelector = false
               }) {
                   Text(group.name)
                       .fs(style: 1)
                       .frame(maxWidth: .infinity)
                       .padding()
                       .background(Global.shared.iconColor1)
                       .cornerRadius(8)
               }
           }
           
           Button(action: {
               showingGroupSelector = false
               showingGroupCreation = true
           }) {
               Text("New")
                   .fs(style: 1)
                   .frame(maxWidth: .infinity)
                   .padding()
                   .background(Global.shared.iconColor2.opacity(0.7))
                   .cornerRadius(8)
           }
       }
       .padding()
       .background(Global.shared.textColor.opacity(0.9))
       .cornerRadius(12)
       .shadow(radius: 5)
       .padding(.horizontal, 20)
    }
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
