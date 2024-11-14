//
//  Global.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//

import SwiftUI

class Global: ObservableObject {
    static let shared = Global()
    
    @Published var selectedProfileIcon: String = "person.crop.circle.fill"
    @Published var selectedGroup: String = "Group 1"
    @Published var betsUserIsIn = ["Friendlier Wager", "Friendly Wager"]

    @AppStorage("hasOnboarded") var hasOnboarded: Bool = false
    @AppStorage("hasScreenTimePermission") var hasScreenTimePermission: Bool = false
    
    @Published var appUsers: [User] = []
    @Published var bets: [Bet] = []
    @Published var groupPages: [Group] = []
    
    private init() {
        setup()
    }
    
    private func setup() {
        // create users
        let user = User(name: "You", age: 18, phoneNumber: "1788766756", screenTime: "1h 22m", email: "user@gmail.com", invites: [], groups: [], bets: [])
        let alice = User(name: "Alice", age: 18, phoneNumber: "1788766756", screenTime: "2h 15m", email: "alice@gmail.com", invites: [], groups: [], bets: [])
        let bob = User(name: "Bob", age: 19, phoneNumber: "8972347283", screenTime: "1h 56m", email: "bob@gmail.com", invites: [], groups: [], bets: [])
        let steve = User(name: "Steve", age: 20, phoneNumber: "2987473292", screenTime: "4h 10m", email: "steve@gmail.com", invites: [], groups: [], bets: [])
        let daniel = User(name: "Daniel", age: 20, phoneNumber: "778307348", screenTime: "10h 10m", email: "daniel@gmail.com", invites: [], groups: [], bets: [])
        
        appUsers = [user, alice, bob, steve, daniel]
        
        // create bets
        let friendlierWager = Bet(
            name: "Friendlier Wager",
            metric: "Weekly",
            appTracking: "Instagram",
            participants: [alice.id, bob.id, steve.id, daniel.id],
            stakes: "Loser cleans the bathroom",
            startDate: Date(),
            endDate: Date().addingTimeInterval(200000)
        )
        
        let friendlyWager = Bet(
            name: "Friendly Wager",
            metric: "Weekly",
            appTracking: "All Apps",
            participants: [alice.id, bob.id, steve.id, daniel.id],
            stakes: "Loser does the dishes",
            startDate: Date().addingTimeInterval(-5),
            endDate: Date().addingTimeInterval(-1)
        )
        
        bets = [friendlierWager, friendlyWager]
        
        // create groups
        let group1 = Group(
            name: "The Avengers",
            members: [alice.id, bob.id, steve.id, daniel.id],
            bets: [friendlierWager.id, friendlyWager.id]
        )
        
        groupPages = [group1]

        // assign groups and bets to users
        appUsers.indices.forEach { index in
            appUsers[index].addGroup(group: group1.id)
            
            let userBets = bets.filter { $0.participants.contains(appUsers[index].id) }
            userBets.forEach { bet in
                appUsers[index].addBet(bet: bet.id)
            }
        }

    }
    
    static let gradientColors: [Color] = [.green, .mint, .teal, .green.opacity(0.8)]
}

struct Background: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: Global.gradientColors),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            content
        }
    }
}

extension View {
    func applyBackground() -> some View {
        self.modifier(Background())
    }
}
