//
//  Global.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//

import SwiftUI

final class Global: ObservableObject {
    static let shared = Global()
    
    //@Published var backgroundColor: [Color] = [.green, .mint, .teal, .green.opacity(0.8)]
    @Published var backgroundColor: [Color] = [Color(hex: "faf3dd")]
    @Published var textColor: Color = Color(hex: "#5e6472")
    @Published var altTextColor: Color = Color(hex: "43a3b1")
    @Published var iconColor1: Color = Color(hex: "aed9e0")
    @Published var iconColor2: Color = Color(hex: "b8f2e6")
    @Published var iconColor3: Color = Color(hex: "ffa69e")
    
    @Published var selectedProfileIcon: Picture = .systemIcon("person.crop.circle.fill")
    @Published var selectedGroup: String = "The Avengers"

    @AppStorage("hasOnboarded") var hasOnboarded: Bool = false
    @AppStorage("hasScreenTimePermission") var hasScreenTimePermission: Bool = false
    
    @Published var appUsers: [User] = []
    @Published var mainUser: User = User(name: "You", age: 21, phoneNumber: "987237487", screenTime: "4h 24m", email: "you@gmail.com", invites: [], groups: [], bets: [])
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
            return
        }
        
        print(bets[betIndex].joinBet(user: addedUser))

        if addedUser == mainUser.id {
            mainUser.addBet(bet: bet)
        } else if let userIndex = appUsers.firstIndex(where: { $0.id == addedUser }) {
            appUsers[userIndex].addBet(bet: bet)
        }
    }
}

enum Picture {
    case systemIcon(String)
    case userImage(UIImage)
    
    func isSystemIcon(_ name: String) -> Bool {
        if case .systemIcon(let systemName) = self {
            return systemName == name
        }
        return false
    }
    
    func toImage() -> Image {
        switch self {
        case .systemIcon(let systemName):
            return Image(systemName: systemName)
        case .userImage(let uiImage):
            return Image(uiImage: uiImage)
        }
    }
}

struct Background: ViewModifier {
    var color: Color? = nil
    
    func body(content: Content) -> some View {
        ZStack {
            if let color = color {
                color.edgesIgnoringSafeArea(.all)
            } else {
                LinearGradient(
                    gradient: Gradient(colors: Global.shared.backgroundColor),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
            }
            
            content
        }
    }
}

struct ForegroundStyle: ViewModifier {
    var style: Int

    func body(content: Content) -> some View {
        switch style {
        case 0:
            content
                .foregroundColor(Global.shared.textColor)
                .font(.system(size: 16, weight: .regular))
        case 1:
            content
                .foregroundColor(Global.shared.altTextColor)
                .font(.system(size: 16, weight: .regular))
        case 2:
            content
                .foregroundColor(Global.shared.iconColor1)
                .font(.system(size: 16, weight: .regular))
        case 3:
            content
                .foregroundColor(Global.shared.iconColor2)
                .font(.system(size: 16, weight: .regular))
        case 4:
            content
                .foregroundColor(Global.shared.iconColor3)
                .font(.system(size: 16, weight: .regular))
        case 5: content
                .foregroundColor(Global.shared.backgroundColor[0])
                .font(.system(size: 16, weight: .regular))
        default:
            content // Fallback for undefined styles is the basic text color
                .foregroundColor(Global.shared.textColor)
                .font(.system(size: 16, weight: .regular))
        }
    }
}

struct BackgroundStyle: ViewModifier {
    var style: Int

    func body(content: Content) -> some View {
        switch style {
        case 1:
            content
                .background(Global.shared.iconColor1)
        case 2:
            content
                .background(Global.shared.iconColor2)
        case 3:
            content
                .background(Global.shared.iconColor3)
        default:
            content // Fallback for undefined styles is the basic button color
                .background(Global.shared.iconColor1)
        }
    }
}


extension View {
    func applyBackground(color: Color? = nil) -> some View {
        self.modifier(Background(color: color))
    }
    func fs(style: Int) -> some View {
        self.modifier(ForegroundStyle(style: style))
    }
    func bs(style: Int) -> some View {
        self.modifier(BackgroundStyle(style: style))
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: Double
        (a, r, g, b) = (1.0,
                        Double((int >> 16) & 0xFF) / 255.0,
                        Double((int >> 8) & 0xFF) / 255.0,
                        Double(int & 0xFF) / 255.0)
        self.init(.sRGB, red: r, green: g, blue: b, opacity: a)
    }
}
