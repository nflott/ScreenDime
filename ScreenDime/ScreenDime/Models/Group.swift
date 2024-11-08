//
//  Group.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//
import SwiftData

struct Group {
    var name: String
    private(set) var members: [User]
    private(set) var bets: [Bet]
    
    init(name: String, members: [User], bets: [Bet]) {
        self.name = name
        self.members = members
        self.bets = bets
    }
    
    mutating func addMember(user: User) {
        if !members.contains(where: { $0.name == user.name }) {
            members.append(user)
        }
    }
    
    mutating func addBet(bet: Bet) {
        if !bets.contains(where: { $0.name == bet.name }) {
            bets.append(bet)
        }
    }
}
