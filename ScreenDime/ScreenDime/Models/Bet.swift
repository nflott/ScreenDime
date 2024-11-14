//
//  Bet.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//
import Foundation
import SwiftData

struct Bet: Identifiable {
    let id = UUID()
    var name: String
    var metric: String
    var appTracking: String
    var participants: [UUID]
    var stakes: String
    var startDate: Date
    var endDate: Date
    
    init(name: String, metric: String, appTracking: String, participants: [UUID], stakes: String, startDate: Date, endDate: Date) {
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
    
    mutating func joinBet(user: UUID) -> String {
        guard !isActive() else {
            return "Bet is currently active. You cannot join."
        }
        
        if participants.contains(where: { $0 == user }) {
            return "\(user) is already a participant."
        } else {
            participants.append(user)
            if let foundUser = Global.shared.appUsers.first(where: { $0.id == user }) {
                    return "\(foundUser.name) has joined the bet."
                } else {
                    return "User not found."
                }
        }
    }
}
