//
//  GroupView.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//

import SwiftUI

struct GroupView: View {
    @ObservedObject private var global = Global.shared
        
    var groupName: String

    var body: some View {
        VStack {
            ScrollView {
                // Fetch the selected group
                if let selectedGroup = global.groupPages.first(where: { $0.name == global.selectedGroup }) {
                    
                    // Display the bets for the group
                    ForEach(selectedGroup.bets, id: \.self) { betId in
                        if let bet = global.bets.first(where: { $0.id == betId }) {
                            VStack(alignment: .leading) {
                                BetCardView(
                                    bet: bet,
                                    title: bet.name,
                                    stakes: bet.stakes,
                                    members: bet.participants,
                                    isActive: bet.isActive()
                                )
                            }
                        }
                    }
                    .padding([.top], 8)
                    
                    // Show message if no bets are available
                    if selectedGroup.bets.isEmpty {
                        Text("No bets yet in \(selectedGroup.name).\nCreate one now!")
                            .fs(style: 0)
                            .font(.callout)
                            .bold()
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                }
            }
        }
        .padding()
    }

    // Helper function to get user names from UUIDs
    private func getUserNames(for participants: [UUID]) -> [String] {
        // Fetch users' names from the global user list using their UUID
        return participants.compactMap { participantUUID in
            global.appUsers.first { $0.id == participantUUID }?.name
        }
    }
}

struct Group_Previews: PreviewProvider {
    static var previews: some View {
        GroupView(groupName: Global.shared.selectedGroup)
    }
}
