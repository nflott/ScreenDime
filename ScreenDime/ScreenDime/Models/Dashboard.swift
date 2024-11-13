//
//  Dashboard.swift
//  ScreenDime
//
//  Created by Maddie lebiedzinski on 11/13/24.
//

struct Dashboard {
    var user: User
    var weeklyScreenTime: [ScreenTime]
    
    init(user: User) {
        self.user = user
        self.weeklyScreenTime = []
    }
}
