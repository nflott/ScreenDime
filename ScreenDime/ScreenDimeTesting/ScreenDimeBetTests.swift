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

}
