//
//  BetView.swift
//  ScreenDime
//
//  Created by Noah Flott on 11/13/24.
//

import SwiftUI

struct BetView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var bet: Bet
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                        .fs(style: 1)
                        .fontWeight(.bold)
                        .padding(.leading, 20)
                }
                
                
                Text("\(bet.name)")
                    .font(.largeTitle)
                    .padding()
                    .fs(style: 0)
                    .fontWeight(.bold)
                
                
                
                Spacer()
                
            }
            .padding()
            
            Text("Started: \(bet.startDate.formatted(date: .abbreviated, time: .omitted))")
                .padding()
                .fs(style: 0)
                .font(.title2)
            
            if (daysLeft() > 0) {
                Text("Ends in: \(daysLeft()) days")
                    .fs(style: 0)
                    .font(.title2)
            } else {
                Text("This bet has ended.")
                    .fs(style: 0)
                    .font(.title2)
            }
            HStack {
                Text("Leaderboard")
                    .font(.title)
                    .padding()
                    .padding([.bottom], -20)
                    .fs(style: 0)
                    .fontWeight(.bold)
                
                Spacer()
            }
            
            VStack {
                let userDetails = bet.participants.map { getUserDetails(for: $0) }
                let sortedMembers = userDetails.compactMap { $0 }.sorted {
                    screenTimeToMinutes($0.screenTime) < screenTimeToMinutes($1.screenTime)
                }
                ForEach(sortedMembers, id: \.name) { user in
                    HStack {
                        Circle()
                            .fs(style: 0)
                            .frame(width: 50, height: 50)
                            .overlay(
                                user.name == "You"
                                    ? Global.shared.selectedProfileIcon.toImage()
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(Circle())
                                        .frame(width: 50, height: 50)
                                        .foregroundStyle(betStatusColor)
                                        .contentShape(Circle())
                                    : Image(systemName: "person.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(Circle())
                                        .frame(width: 25, height: 25)
                                        .foregroundStyle(betStatusColor)
                                        .contentShape(Circle()) 
                            )
                        
                        // Member's name with ranking number
                        Text("\(sortedMembers.firstIndex(where: { $0.name == user.name })! + 1). \(user.name)")
                            .fs(style: 0)
                            .font(.title2)
                        
                        Spacer()
                        
                        // Screen time metric aligned to the right
                        Text(user.screenTime)
                            .fs(style: 0)
                            .font(.title2)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .padding(.vertical, 30)

            
            HStack {
                Text("Details")
                    .fs(style: 0)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
            }
            .padding(30)
            
            HStack {
                Text("Stakes: \(bet.stakes)")
                    .fs(style: 0)
                
                Spacer()
            }
            .padding(.leading, 30)
            .padding(.bottom, 15)
            
            HStack {
                Text("Tracking screen time by: \(bet.metric) use")
                    .fs(style: 0)
                
                Spacer()
            }
            .padding(.leading, 30)
            .padding(.bottom, 15)
            
            HStack {
                Text("App(s) tracked: \(bet.appTracking)")
                    .fs(style: 0)
                
                Spacer()
            }
            .padding(.leading, 30)
            .padding(.bottom, 15)
            
            Spacer()
        }
        .applyBackground(color:betStatusColor)
    }
    
    private var betStatusColor: Color {
        let currentDate = Date()
        if currentDate < bet.startDate {
            return Global.shared.iconColor2
        } else if currentDate > bet.endDate {
            return Global.shared.iconColor3
        } else {
            return Global.shared.iconColor1
        }
    }
    
    private func screenTimeToMinutes(_ time: String) -> Int {
        let regex = try! NSRegularExpression(pattern: "(\\d+)(h|m)", options: [])
        let nsRange = NSRange(time.startIndex..<time.endIndex, in: time)
        var minutes = 0
        
        regex.enumerateMatches(in: time, options: [], range: nsRange) { match, _, _ in
            if let match = match {
                let value = (time as NSString).substring(with: match.range(at: 1))
                let unit = (time as NSString).substring(with: match.range(at: 2))
                if unit == "h" {
                    minutes += Int(value)! * 60
                } else if unit == "m" {
                    minutes += Int(value)!
                }
            }
        }
        
        return minutes
    }
    
    private func getUserDetails(for memberUUID: UUID) -> (name: String, screenTime: String)? {
        if let user = Global.shared.appUsers.first(where: { $0.id == memberUUID }) {
            return (name: user.name, screenTime: user.screenTime)
        }
        else if memberUUID == Global.shared.mainUser.id {
            return (name: Global.shared.mainUser.name, screenTime: Global.shared.mainUser.screenTime)
        }
        return nil
    }
    
    private func daysLeft() -> Int {
        let calendar = Calendar.current
        
        let date1 = calendar.startOfDay(for: Date())
        let date2 = calendar.startOfDay(for: bet.endDate)
        
        let components = calendar.dateComponents([.day], from: date1, to: date2)
        return components.day ?? 0
    }
}

struct BetView_Preview: PreviewProvider {
    static var previews: some View {
        BetView(bet: Bet(
            name: "Friendly Wager",
            metric: "Weekly",
            appTracking: "All Apps",
            participants: [],
            stakes: "Loser does the dishes",
            startDate: Date().addingTimeInterval(-5),
            endDate: Date().addingTimeInterval(-1)
        ))
    }
    
}
