//
//  Bet.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//
import Foundation
import SwiftData

struct Bet {
    var name: String
    var metric: String
    var appTracking: String
    private(set) var participants: [User]
    var stakes: String
    var startDate: Date
    var endDate: Date
    
    init(name: String, metric: String, appTracking: String, participants: [User], stakes: String, startDate: Date, endDate: Date) {
        self.name = name
        self.metric = metric
        self.appTracking = appTracking
        self.participants = participants
        self.stakes = stakes
        self.startDate = startDate
        self.endDate = endDate
    }
    
    func isActive() -> Bool {
        let currentDate = Date()
        return currentDate >= startDate && currentDate <= endDate
    }
    
    mutating func joinBet(user: User) -> String {
        guard !isActive() else {
            return "Bet is currently active. You cannot join."
        }
        
        if participants.contains(where: { $0.name == user.name }) {
            return "\(user.name) is already a participant."
        } else {
            participants.append(user)
            return "\(user.name) has joined the bet."
        }
    }
    
    
}
