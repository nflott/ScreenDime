//
//  ScreenTime.swift
//  ScreenDime
//
//  Created by Maddie lebiedzinski on 11/13/24.
//

import Foundation

struct ScreenTime {
    let date: Date  // The specific day or start of a period
    var totalMinutes: Int  // Total screen time in minutes
    var appUsage: [AppScreenTime]  // Detailed app-level usage data
}

struct AppScreenTime {
    let appName: String
    var minutesUsed: Int
}
