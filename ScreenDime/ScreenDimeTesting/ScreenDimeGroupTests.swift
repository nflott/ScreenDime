//
//  ScreenDimeGroupTests.swift
//  ScreenDimeTesting
//
//  Created by Noah Flott on 11/6/24.
//

import XCTest
@testable import ScreenDime

final class ScreenDimeGroupTests: XCTestCase {

    func testGroupCreation() {
        let testGroup = Group(name: "Test Group", members: [], bets: [])
        
        XCTAssertEqual(testGroup.name, "Test Group")
    }
    
    func testGroupJoining() {
        let testGroup = Group(name: "Test Group", members: [], bets: [])
    }
    
    func testUnsuccessfulGroupJoining() {
        
    }
    
    func testBetAddingToGroup() {
        
    }

    func testUnsuccessfulBetAddingToGroup() {
        
    }
}
