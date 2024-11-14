import SwiftUI

struct BetCardView: View {
    var bet: Bet
    var title: String
    var stakes: String
    var members: [User] // List of bet members with name and screen time
    var isActive: Bool // Determines the card's active status for styling
    
    @State var showingFullBet: Bool = false
    @State var showingAcceptDialog: Bool = false
    @State var showingRejectDialog: Bool = false
    
    // Colors for active and inactive states
    let activeColor: Color = .green
    let inactiveColor: Color = .gray
    

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
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Button(action: {
                showingFullBet.toggle()
            }) {
                Rectangle()
                    .fill(isActive ? activeColor : inactiveColor)
                    .frame(maxWidth: .infinity, minHeight: dynamicCardHeight()) // Dynamic card height
                    .cornerRadius(10)
                    .shadow(color: isActive ? .green.opacity(0.6) : .clear, radius: 10, x: 0, y: 0) // Glow effect for active cards
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    // Title
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    if isActive {
                        Button(
                            action: {
                                showingAcceptDialog.toggle()
                            }){
                                Image(systemName: "hand.thumbsup.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.blue)
                            }
                            .padding([.trailing], 15)
                        
                        Button(
                            action: {
                                showingRejectDialog.toggle()
                            }){
                                Image(systemName: "hand.thumbsdown.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.red)
                            }
                    }
                }
                // Stakes text
                Text("Stakes: \(stakes)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                                
                // Bet members
                VStack(alignment: .leading, spacing: 4) {
                    let sortedMembers = members.sorted {
                        screenTimeToMinutes($0.screenTime) < screenTimeToMinutes($1.screenTime)
                    }
                    
                    ForEach(Array(sortedMembers.prefix(3).enumerated()), id: \.element.name) { index, member in
                        HStack {
                            // Placeholder for photo circle
                            Circle()
                                .fill(Color.white.opacity(0.8))
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 15, height: 15)
                                        .foregroundColor(.gray)
                                )
                            
                            // Member's name with ranking number
                            Text("\(index + 1). \(member.name)")
                                .foregroundColor(.white)
                                .font(.footnote)
                            
                            Spacer()
                            
                            // Screen time metric aligned to the right
                            Text(member.screenTime)
                                .foregroundColor(.white)
                                .font(.footnote)
                        }
                    }
                    
                    // Show "+X more" if there are more than 3 members
                    if members.count == 0 {
                        Text("No one's here yet...")
                            .foregroundColor(.white)
                    }
                    if members.count > 3 {
                        Text("+\(members.count - 3) more")
                            .foregroundColor(.white)
                            .font(.footnote)
                            .padding([.top], 2)
                    }
                }
            }
            .padding(15)
        }
        .padding(5)
        .sheet(isPresented: $showingFullBet) {
            BetView(bet: bet)
        }
    }
    
    // Adjust card height based on the number of members
    private func dynamicCardHeight() -> CGFloat {
        switch members.count {
        case 0:
            return 100
        case 1:
            return 105
        case 2:
            return 155
        default:
            return 180
        }
    }
}

struct BetCardView_Previews: PreviewProvider {
    static var previews: some View {
        BetCardView(
            bet: Bet(name: "Friendly Wager", metric: "Daily average", appTracking: "Snapchat", participants: [User(name: "Noah", age: 22, phoneNumber: "0000000000", screenTime: "2 hours", email: "email", invites: [], groups: [], bets: []), User(name: "Noah", age: 22, phoneNumber: "0000000000", screenTime: "2 hours", email: "email", invites: [], groups: [], bets: [])], stakes: "$30", startDate: Date(), endDate: Date()),
            title: "Friendly Wager",
            stakes: "Loser buys coffee",
            members: [
                User(name: "Alice", age:18, phoneNumber:"1788766756", screenTime: "2h 15m", email: "alice@gmail.com", invites:[], groups:[], bets:[]),
                User(name: "Bob", age:19, phoneNumber:"8972347283", screenTime: "1h 56m", email: "bob@gmail.com", invites:[], groups:[], bets:[]),
                User(name: "Steve", age:20, phoneNumber:"2987473292", screenTime: "4h 10m", email: "steve@gmail.com", invites:[], groups:[], bets:[]),
                User(name: "Steve", age:20, phoneNumber:"2987473292", screenTime: "10h 10m", email: "steve2@gmail.com", invites:[], groups:[], bets:[]),
                User(name: "Steve", age:20, phoneNumber:"2987473292", screenTime: "1h 50m", email: "steve3@gmail.com", invites:[], groups:[], bets:[])
            ],
            isActive: true // Preview the active state
        )
        .frame(width: UIScreen.main.bounds.width, height: 100) // Full screen width for preview
    }
}
