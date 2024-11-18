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
    
    // Function to get user details based on UUIDs
    private func getUserDetails(for memberUUID: UUID) -> (name: String, screenTime: String)? {
        if let user = Global.shared.appUsers.first(where: { $0.id == memberUUID }) {
            return (name: user.name, screenTime: user.screenTime)
        }
        return nil
    }
    
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
                        .foregroundColor(.blue)
                        .fontWeight(.bold)
                        .padding(.leading, 20)
                }
                
                
                Text("\(bet.name)")
                    .font(.largeTitle)
                    .padding()
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
                
                
                Spacer()
                
            }
            .padding()
            
            Text("Started: \(bet.startDate.formatted(date: .abbreviated, time: .omitted))")
                .padding()
                .foregroundColor(.white)
                .font(.title2)
            
            if (daysLeft() > 0) {
                Text("Ends in: \(daysLeft()) days")
                    .foregroundColor(.white)
                    .font(.title2)
            } else {
                Text("This bet has ended.")
                    .foregroundColor(.white)
                    .font(.title2)
            }
            HStack {
                Text("Leaderboard")
                    .font(.title)
                    .padding()
                    .padding([.bottom], -20)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                
                Spacer()
            }
            
            VStack {
                // Loop through participants (UUIDs) and fetch user details
                ForEach(0..<bet.participants.count, id: \.self) { index in
                    if let user = getUserDetails(for: bet.participants[index]) {
                        HStack {
                            // Placeholder for photo circle
                            Circle()
                                .fill(Color.white.opacity(0.8))
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(.gray)
                                )
                            
                            // Member's name with ranking number
                            Text("\(index + 1). \(user.name)")
                                .foregroundColor(.white)
                                .font(.title2)
                            
                            Spacer()
                            
                            // Screen time metric aligned to the right
                            Text(user.screenTime)
                                .foregroundColor(.white)
                                .font(.title2)
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
            .padding(.vertical, 30)
            
            HStack {
                Text("Details")
                    .foregroundColor(.white)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
            }
            .padding(30)
            
            HStack {
                Text("Stakes: \(bet.stakes)")
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.leading, 30)
            .padding(.bottom, 15)
            
            HStack {
                Text("Tracking screen time by: \(bet.metric) use")
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.leading, 30)
            .padding(.bottom, 15)
            
            HStack {
                Text("App(s) tracked: \(bet.appTracking)")
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.leading, 30)
            .padding(.bottom, 15)
            
            Spacer()
        }
        .applyBackground()
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
