//
//  ScreenDimeBetTests.swift
//  ScreenDimeTesting
//
//  Created by Noah Flott on 11/6/24.
//

import XCTest
@testable import ScreenDime

final class ScreenDimeBetTests: XCTestCase {

    func testSuccessfulBetCreation() {
        let name = "Test Bet"
        let testGroup = Group(name: "Test Group", members: [], bets: [])
        let metric = "Daily average"
        let appTracking = "All apps"
        let participants = [User(name: "Test User", age: 23, phoneNumber: "0000000000", email: "user@user.com", invites: [], groups: [], bets: [])]
        let stakes = "Dishes"
        let startDate = Date()
        let endDate = Date()
        
        let bet = Bet(name: name, group: testGroup, metric: metric, appTracking: appTracking, participants: participants, stakes: stakes, startDate: startDate, endDate: endDate)
        
        XCTAssertEqual(bet.name, name)
    }
    
    func testBetJoining() {
        let testGroup = Group(name: "Test Group", members: [], bets: [])
        let participant = User(name: "Test User", age: 23, phoneNumber: "0000000000", email: "user@user.com", invites: [], groups: [], bets: [])
        var bet = Bet(name: "Test Bet", group: testGroup, metric: "Daily average", appTracking: "All apps", participants: [], stakes: "Dishes", startDate: Date(), endDate: Date())
        
        let message = bet.joinBet(user: participant)
        
        XCTAssertEqual(message, "\(participant.name) has joined the bet.")
    }

    func testUnsuccessfulBetJoining() {
        let testGroup = Group(name: "Test Group", members: [], bets: [])
        let participant = User(name: "Test User", age: 23, phoneNumber: "0000000000", email: "user@user.com", invites: [], groups: [], bets: [])
        var bet = Bet(name: "Test Bet", group: testGroup, metric: "Daily average", appTracking: "All apps", participants: [], stakes: "Dishes", startDate: Date(), endDate: Date())
        
        let msg = bet.joinBet(user: participant)
        
        XCTAssertEqual(bet.joinBet(user: participant), "\(participant.name) is already a participant.")
    }
    
    func testInactiveBetJoining() {
        let testGroup = Group(name: "Test Group", members: [], bets: [])
        let participant = User(name: "Test User", age: 23, phoneNumber: "0000000000", email: "user@user.com", invites: [], groups: [], bets: [])
        var bet = Bet(name: "Test Bet", group: testGroup, metric: "Daily average", appTracking: "All apps", participants: [], stakes: "Dishes", startDate: Date(timeIntervalSince1970: 10000), endDate: Date().addingTimeInterval(10000))
        
        let message = bet.joinBet(user: participant)
        
        XCTAssertEqual(message, "Bet is currently active. You cannot join.")
    }
}
