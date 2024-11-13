//
//  Tab.swift
//  ScreenDime
//
//  Created by Noah Flott on 11/13/24.
//

import SwiftUI

struct TabItem: Identifiable {
    let id = UUID()
    var title: String
    var icon: String
    var view: AnyView
}
