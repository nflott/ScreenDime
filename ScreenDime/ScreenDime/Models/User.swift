//
//  User.swift
//  ScreenDime
//
//  Created by Noah Flott on 11/4/24.
//

struct User {
    let name: String
    let age: Int
    let phoneNumber: String
    let email: String
    private(set) var invites: [Group]
    private(set) var groups: [Group]
    
    init(name: String, age: Int, phoneNumber: String, email: String, invites: [Group], groups: [Group]) {
        self.name = name
        self.age = age
        self.phoneNumber = phoneNumber
        self.email = email
        self.invites = []
        self.groups = []
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
    
    
    
}
