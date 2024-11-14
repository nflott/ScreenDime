//
//  Group.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//

import SwiftData
import SwiftUI

struct Group {
    let id = UUID()
    var name: String
    private(set) var members: [UUID]
    private(set) var bets: [UUID]
    
    init(name: String, members: [UUID], bets: [UUID]) {
        self.name = name
        self.members = members
        self.bets = bets
    }
    
    mutating func addMember(user: UUID) {
        if !members.contains(where: { $0 == user }) {
            members.append(user)
        }
    }
    
    mutating func addBet(bet: UUID) {
        if !bets.contains(where: { $0 == bet }) {
            bets.insert(bet, at: 0)
        }
    }
}

