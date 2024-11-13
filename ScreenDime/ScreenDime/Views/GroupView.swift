//
//  GroupView.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//

import SwiftUI

struct GroupView: View {
    @ObservedObject private var global = Global.shared
    
    @State private var showBetCreationView = false
    
    var groupName: String

    var body: some View {
        VStack {
            ScrollView {
                if let selectedGroup = global.groupPages.first(where: {$0.name == Global.shared.selectedGroup}) {
                    ForEach(selectedGroup.bets, id: \.name) { bet in
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
                    if selectedGroup.bets.count <= 0 {
                        Text("No bets yet in \(selectedGroup.name).\nCreate one now!")
                            .foregroundColor(.white)
                            .font(.callout)
                            .bold()
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                }
            }
        }
    }
}

struct Group_Previews: PreviewProvider {
    static var previews: some View {
        GroupView(groupName:Global.shared.selectedGroup)
    }
}
