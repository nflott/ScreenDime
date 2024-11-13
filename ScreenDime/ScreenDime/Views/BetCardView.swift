import SwiftUI

struct BetCardView: View {
    var bet: Bet
    var title: String
    var stakes: String
    var members: [User] // List of bet members with name and screen time
    var isActive: Bool // Determines the card's active status for styling
    
    @State var showingFullBet: Bool = false
    
    // Colors for active and inactive states
    let activeColor: Color = .green
    let inactiveColor: Color = .gray
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .fill(isActive ? activeColor : inactiveColor)
                .frame(maxWidth: .infinity, minHeight: 200) // Full width
                .cornerRadius(10)
                .shadow(color: isActive ? .green.opacity(0.6) : .clear, radius: 10, x: 0, y: 0) // Glow effect for active cards
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    // Title
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(
                        action: {
                            showingFullBet.toggle()
                        }){
                            Image(systemName: "ellipsis")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.blue)
                        }
                }
                // Stakes text
                Text("Stakes: \(stakes)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                
                Spacer()
                
                // Bet members
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(Array(members.prefix(3).enumerated()), id: \.element.name) { index, member in
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
                }
            }
            .padding(15)
        }
        .padding(5)
        
        .sheet(isPresented: $showingFullBet) {
            BetView(bet: bet)
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
                User(name: "Steve", age:20, phoneNumber:"2987473292", screenTime: "4h 10m", email: "steve@gmail.com", invites:[], groups:[], bets:[])
            ],
            isActive: true // Preview the active state
        )
        .frame(width: UIScreen.main.bounds.width, height: 200) // Full screen width for preview
    }
}
