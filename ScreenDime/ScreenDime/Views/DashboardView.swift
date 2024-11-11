import SwiftUI

struct DashboardView: View {
    @State private var showingSettings = false
    @State private var showingNewBet = false
    @State var backgroundOffset = 0
    @State private var selectedPage = 0
    @State private var groupPages: [Group] = SDModel.groups
    @State private var rectangleCounts: [Int] = Array(repeating: 2, count: 4)
    
    let dashboardTitle = "Dashboard"
    let circleColors: [Color] = [.black, .red, .blue, .yellow, .green, .purple, .orange]
    
    var totalPages: Int {
        return 2 + groupPages.count
    }

    var body: some View {
        VStack {
            GeometryReader { g in
                ZStack {
                    Text(getPageTitle(for: selectedPage))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: g.size.width, height: 40, alignment: .center)
                    
                    HStack {
                        Button(action: {
                            showingSettings.toggle()
                        }) {
                            Image(systemName: "gear")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        .padding()
                        
                        Spacer()
                    }
                }
                .padding(.top)
                
                TabView(selection: $selectedPage) {
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(spacing: 0) {
                            ForEach(0..<2, id: \.self) { _ in
                                Rectangle()
                                    .fill(Color.black.opacity(0.7))
                                    .frame(width: g.size.width - 10, height: 200)
                                    .cornerRadius(5)
                                    .padding(5)
                                    .frame(maxWidth: .infinity, maxHeight: 210)
                            }
                        }
                    }
                    .tag(0)
                    
                    ForEach(0..<groupPages.count, id: \.self) { pageIndex in
                        ScrollView(.vertical, showsIndicators: true) {
                            VStack(spacing: 0) {
                                ForEach(0..<groupPages[pageIndex].bets.count, id: \.self) { _ in
                                    BetCardView(
                                        title: "Friendly Wager",
                                        stakes: "Loser buys coffee",
                                        members: [
                                            BetMember(name: "Alice", screenTime: "2h 15m"),
                                            BetMember(name: "Bob", screenTime: "1h 45m"),
                                            BetMember(name: "Charlie", screenTime: "3h 5m")
                                        ],
                                        isActive: true, // Preview the active state
                                        wager: Bet(name: "Friendly Wager", metric: "", appTracking: "", participants: SDModel.groups[0].members, stakes: "", startDate: Date(), endDate: Date())
                                    )
                                }
                                Button(action: {
                                    showingNewBet = true
                                    rectangleCounts[pageIndex] += 1
                                }) {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.blue)
                                        .cornerRadius(20)
                                }
                                .padding(.bottom, 20)
                                Spacer()
                                    .frame(height: 100)
                                
                                Button(action: {
                                    deleteGroup(at: pageIndex)
                                }) {
                                    Text("Delete Group")
                                        .font(.footnote)
                                        .foregroundColor(.red)
                                }
                                .padding(.bottom, 20)
                                
                                Spacer()
                                    .frame(height: 100)
                            }
                        }
                        .tag(pageIndex + 1)
                    }
                    
                    VStack {
                        Spacer()
                        Button(action: {
                            addNewGroupPage()
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.blue)
                        }
                        Spacer()
                    }
                    .tag(groupPages.count + 1)
                }
                .frame(height: g.size.height * 0.8)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .padding(.top, 90)
                .onChange(of: selectedPage) { newValue in
                    backgroundOffset = newValue
                }
                
                //NAV BAR
                ZStack {
                    Rectangle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 400, height: 70)
                        .cornerRadius(10)
                    
                    HStack(spacing: 15) {
                        ForEach(0..<totalPages, id: \.self) { index in
                            Circle()
                                .fill(circleColors[index % circleColors.count])
                                .frame(width: backgroundOffset == index ? 40 : 20, height: backgroundOffset == index ? 40 : 20)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 3)
                                )
                                .onTapGesture {
                                    selectedPage = index
                                }
                        }
                    }
                    .withAnimation(.default)
                }
                .position(x: g.size.width / 2, y: g.size.height / 1.1)
            }
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width > 10 {
                            if self.backgroundOffset > 0 {
                                self.backgroundOffset -= 1
                            }
                        } else if value.translation.width < -10 {
                            if self.backgroundOffset < totalPages - 1 {
                                self.backgroundOffset += 1
                            }
                        }
                    }
            )
        }
        .applyBackground()
        .fullScreenCover(isPresented: $showingNewBet) {
            BetViewModel(group: groupPages[selectedPage - 1])
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView().applyBackground()
        }
    }
    
    private func addNewGroupPage() {
        let newPageTitle = "Group \(groupPages.count + 1)"
        groupPages.append(Group(name: newPageTitle, members: [], bets: []))
        rectangleCounts.append(2)
        selectedPage = groupPages.count
    }
    
    private func deleteGroup(at index: Int) {
        groupPages.remove(at: index)
        rectangleCounts.remove(at: index)
        if selectedPage > groupPages.count {
            selectedPage = groupPages.count
        }
    }
    
    private func getPageTitle(for pageIndex: Int) -> String {
        if pageIndex == 0 {
            return dashboardTitle
        } else if pageIndex <= groupPages.count {
            return groupPages[pageIndex - 1].name
        } else {
            return "Add Group"
        }
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
