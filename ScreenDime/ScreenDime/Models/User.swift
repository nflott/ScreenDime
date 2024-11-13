//
//  User.swift
//  ScreenDime
//
//  Created by Noah Flott on 11/4/24.
//

import SwiftData

struct User {
    var name: String
    var age: Int
    var phoneNumber: String
    var email: String
    var screenTime: String
    private(set) var invites: [Group]
    private(set) var groups: [Group]
    private(set) var bets: [Bet]
    
    init(name: String, age: Int, phoneNumber: String, screenTime: String, email: String, invites: [Group], groups: [Group], bets: [Bet]) {
        self.name = name
        self.age = age
        self.phoneNumber = phoneNumber
        self.screenTime = screenTime
        self.email = email
        self.invites = []
        self.groups = []
        self.bets = []
    }
    
    mutating func addInvite(group: Group) {
        if !invites.contains(where: { $0.name == group.name } ) {
            invites.append(group)
        }
    }
    
    mutating func addGroup(group: Group, action: Bool) {
        if action && invites.contains(where: { $0.name == group.name } ) {
            groups.append(group)
            invites.removeAll(where: { $0.name == group.name } )
        }
    }
    
    mutating func addBet(bet: Bet, action: Bool) {
        if action && !bets.contains(where: { $0.name == bet.name } ) {
            bets.append(bet)
        }
    }
    
}
