//
//  Tab.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/11/24.
//

import SwiftUI

struct TabItem: Identifiable {
    let id = UUID()
    var title: String
    var icon: String
    var view: AnyView
}
