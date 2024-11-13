//
//  GroupView.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//

import SwiftUI

struct GroupView: View {
    @State private var showBetCreationView = false
    
    var groupName: String
    
    @State var groupPages: [Group] = [
        Group(name: "Group 1",
              members: [],
              bets: [Bet(name: "Friendlier Wager",
                         metric: "Weekly",
                         appTracking: "Instagram",
                         participants: [User(name: "Alice", age:18, phoneNumber:"1788766756", screenTime: "2h 15m",                 email: "alice@gmail.com", invites:[], groups:[], bets:[]),
                                        User(name: "Bob", age:19, phoneNumber:"8972347283", screenTime: "1h 56m", email: "bob@gmail.com", invites:[], groups:[], bets:[]),
                                        User(name: "Steve", age:20, phoneNumber:"2987473292", screenTime: "4h 10m", email: "steve@gmail.com", invites:[], groups:[], bets:[])],
                         stakes: "Loser cleans the bathroom",
                         startDate: Date().addingTimeInterval(-2),
                         endDate: Date().addingTimeInterval(3)),
                     Bet(name: "Friendly Wager",
                         metric: "Weekly",
                         appTracking: "All Apps",
                         participants: [User(name: "Alice", age:18, phoneNumber:"1788766756", screenTime: "2h 15m",                 email: "alice@gmail.com", invites:[], groups:[], bets:[]),
                                        User(name: "Bob", age:19, phoneNumber:"8972347283", screenTime: "1h 56m", email: "bob@gmail.com", invites:[], groups:[], bets:[]),
                                        User(name: "Steve", age:20, phoneNumber:"2987473292", screenTime: "4h 10m", email: "steve@gmail.com", invites:[], groups:[], bets:[])],
                         stakes: "Loser does the dishes",
                         startDate: Date().addingTimeInterval(-5),
                         endDate: Date().addingTimeInterval(-1))]),
        Group(name: "Group 2",
              members: [],
              bets: []),
        Group(name: "Group 3",
              members: [],
              bets: []),
            ]

    var body: some View {
        VStack {
            ScrollView {
                if let selectedGroup = groupPages.first(where: {$0.name == Global.shared.selectedGroup}) {
                    ForEach(selectedGroup.bets, id: \.name) { bet in
                        VStack(alignment: .leading) {
                            BetCardView(
                                title: bet.name,
                                stakes: bet.stakes,
                                members: bet.participants,
                                isActive: bet.isActive()
                            )
                        }
                    }
                }
                else {
                    Text("No bets yet in \(groupName)")
                        .foregroundColor(.gray)
                }
                Button(action: {
                    showBetCreationView.toggle()
                }) {
                    Text("Create New Bet")
                        .padding()
                        .frame(width:180)
                }
            }
        }
        .sheet(isPresented: $showBetCreationView) {
            CreateBetView()
        }
    }
}

struct Group_Previews: PreviewProvider {
    static var previews: some View {
        GroupView(groupName:Global.shared.selectedGroup)
    }
}
