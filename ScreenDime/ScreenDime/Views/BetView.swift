//
//  BetView.swift
//  ScreenDime
//
//  Created by Noah Flott on 11/13/24.
//

import SwiftUI

struct BetView: View {
    @State var bet: Bet
    
    var body: some View {
        VStack {
            Text("\(bet.name)")
                .font(.largeTitle)
                .padding()
                .foregroundColor(.white)
                .fontWeight(.bold)
            
            
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
            
            VStack {
                
                ForEach(0..<bet.participants.count, id: \.self) { member in
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
                        Text("\(member + 1). \(bet.participants[member].name)")
                            .foregroundColor(.white)
                            .font(.title2)
                        
                        Spacer()
                        
                        //Screen time metric aligned to the right
                        Text(bet.participants[member].screenTime)
                            .foregroundColor(.white)
                            .font(.title2)
                    }
                    .padding(.horizontal, 20)
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

struct BetPreview: PreviewProvider {
    static var previews: some View {
        BetView(bet: Bet(name: "Friendly Wager", metric: "Daily average", appTracking: "Snapchat", participants: [User(name: "Noah", age: 22, phoneNumber: "0000000000", screenTime: "2 hours", email: "email", invites: [], groups: [], bets: []), User(name: "Noah", age: 22, phoneNumber: "0000000000", screenTime: "2 hours", email: "email", invites: [], groups: [], bets: [])], stakes: "$30", startDate: Date(), endDate: Date()))
    }
}
