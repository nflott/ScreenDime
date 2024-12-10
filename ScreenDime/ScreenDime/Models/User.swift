//
//  User.swift
//  ScreenDime
//
//  Created by Noah Flott on 11/4/24.
//

import SwiftData
import Foundation
import SwiftUI

struct User: Identifiable {
    let id = UUID()
    var name: String
    var age: Int
    var phoneNumber: String
    var email: String
    var screenTime: String
    var profilePicture: Image?
    private(set) var invites: [UUID]
    private(set) var groups: [UUID]
    private(set) var bets: [UUID]
    
    init(name: String, age: Int, phoneNumber: String, screenTime: String, email: String, invites: [Group], groups: [Group], bets: [Bet], profilePicture: Image? = nil) {
        self.name = name
        self.age = age
        self.phoneNumber = phoneNumber
        self.screenTime = screenTime
        self.email = email
        self.invites = []
        self.groups = []
        self.bets = []
        self.profilePicture = profilePicture
    }
    
    mutating func addInvite(group: UUID) {
        if !invites.contains(where: { $0 == group } ) {
            invites.append(group)
        }
    }
    
    mutating func addGroup(group: UUID/*, action: Bool*/) {
        /*if action && invites.contains(group.id) { */
            if !groups.contains(group) {
                groups.append(group)
            }
            invites.removeAll(where: { $0 == group } )
       // }
    }
    
    mutating func addBet(bet: UUID/*, action: Bool*/) {
        if /*action &&*/ !bets.contains(where: { $0 == bet } ) {
            bets.append(bet)
        }
    }
}
