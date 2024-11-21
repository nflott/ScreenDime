//
//  Global.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//

import SwiftUI

class Global: ObservableObject {
    static let shared = Global()
    static let gradientColors: [Color] = [.green, .mint, .teal, .green.opacity(0.8)]
    
    @Published var selectedProfileIcon: String = "person.crop.circle.fill"
    @Published var selectedGroup: String = "The Avengers"

    @AppStorage("hasOnboarded") var hasOnboarded: Bool = false
    @AppStorage("hasScreenTimePermission") var hasScreenTimePermission: Bool = false
    
    @Published var appUsers: [User] = []
    @Published var mainUser: User = User(name: "You", age: 21, phoneNumber: "987237487", screenTime: "0h 0m", email: "you@gmail.com", invites: [], groups: [], bets: [])
    @Published var bets: [Bet] = []
    @Published var groupPages: [Group] = []
    
    private init() {
        setup()
    }
    
    private func setup() {
        // create users
        let user = User(name: "Eve", age: 18, phoneNumber: "1788766756", screenTime: "1h 22m", email: "user@gmail.com", invites: [], groups: [], bets: [])
        let alice = User(name: "Alice", age: 18, phoneNumber: "1788766756", screenTime: "2h 15m", email: "alice@gmail.com", invites: [], groups: [], bets: [])
        let bob = User(name: "Bob", age: 19, phoneNumber: "8972347283", screenTime: "1h 56m", email: "bob@gmail.com", invites: [], groups: [], bets: [])
        let steve = User(name: "Steve", age: 20, phoneNumber: "2987473292", screenTime: "4h 10m", email: "steve@gmail.com", invites: [], groups: [], bets: [])
        let daniel = User(name: "Daniel", age: 20, phoneNumber: "778307348", screenTime: "10h 10m", email: "daniel@gmail.com", invites: [], groups: [], bets: [])
        
        appUsers.append(contentsOf: [user, alice, bob, steve, daniel])
        
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
        
        let friendliestWager = Bet(
            name: "Friendliest Wager",
            metric: "Weekly",
            appTracking: "All Apps",
            participants: [alice.id],
            stakes: "Loser deals with the mice",
            startDate: Date().addingTimeInterval(220000),
            endDate: Date().addingTimeInterval(500000))
        
        bets.append(contentsOf:[friendliestWager, friendlierWager, friendlyWager])
        
        // create groups
        let group1 = Group(
            name: "The Avengers",
            members: [alice.id, bob.id, steve.id, daniel.id],
            bets: [friendliestWager.id, friendlierWager.id, friendlyWager.id]
        )
        
        let group2 = Group(
            name: "Roomies!",
            members: [bob.id, steve.id, daniel.id],
            bets: [])
        
        groupPages.append(contentsOf:[group1, group2])

        // assign groups and bets to users
        appUsers.indices.forEach { index in
            appUsers[index].addGroup(group: group1.id)
            appUsers[index].addGroup(group: group2.id)
            
            let userBets = bets.filter { $0.participants.contains(appUsers[index].id) }
            userBets.forEach { bet in
                appUsers[index].addBet(bet: bet.id)
            }
        }

    }
    
    func getUser(_ id: UUID) -> User? {
        return appUsers.first { $0.id == id }
    }

    func getBet(_ id: UUID) -> Bet? {
        return bets.first { $0.id == id }
    }

    func getGroup(_ id: UUID) -> Group? {
        return groupPages.first { $0.id == id }
    }
    
    func createBet(name: String, metric: String, appTracking: String, participants: [UUID], stakes: String, startDate: Date, endDate: Date, group: UUID) {
        let newBet = Bet(
            name: name,
            metric: metric,
            appTracking: appTracking,
            participants: participants,
            stakes: stakes,
            startDate: startDate,
            endDate: endDate
        )
        
        bets.append(newBet)
        
        participants.forEach { participantId in
            if let userIndex = appUsers.firstIndex(where: { $0.id == participantId }) {
                appUsers[userIndex].addBet(bet: newBet.id)
            }
        }
        
        if let groupIdx = groupPages.firstIndex(where: { $0.id == group }) {
            groupPages[groupIdx].addBet(bet: newBet.id)
        }
    }
    
    func createGroup(name: String, members: [UUID]) {
        let newGroup = Group(
            name: name,
            members: members,
            bets: []
        )
        
        groupPages.append(newGroup)
        
        members.forEach { memberId in
            if let userIdx = appUsers.firstIndex(where: { $0.id == memberId }) {
                appUsers[userIdx].addGroup(group: newGroup.id)
            }
        }
    }
    
    func addUserToBet(addedUser: UUID, bet: UUID) {
        guard let betIndex = bets.firstIndex(where: { $0.id == bet }) else {
            print("Bet not found!")
            return
        }

        if bets[betIndex].participants.contains(addedUser) {
            print("User is already a participant in the bet.")
            return
        }
        
        print("Calling .joinbet on \(bets[betIndex].name)")
        print("Bet participants: \(bets[betIndex].participants)")
        bets[betIndex].joinBet(user: addedUser)
        print("Bet participants after: \(bets[betIndex].participants)")

        if addedUser == mainUser.id {
            print("addedUser is the Main User")
            print("Main user bets: \(mainUser.bets)")
            mainUser.addBet(bet: bet)
            print("Main user bets: \(mainUser.bets)")
        } else if let userIndex = appUsers.firstIndex(where: { $0.id == addedUser }) {
            print("Added user is NOT the Main User")
            appUsers[userIndex].addBet(bet: bet)
        }
    }
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
