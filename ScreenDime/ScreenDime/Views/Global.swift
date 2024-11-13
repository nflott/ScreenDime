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
    @Published var selectedGroup: String = "Group 2"
    
    @AppStorage("hasOnboarded") var hasOnboarded: Bool = false
    @AppStorage("hasScreenTimePermission") var hasScreenTimePermission: Bool = false
    
    @Published var groupPages: [Group] = [
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
