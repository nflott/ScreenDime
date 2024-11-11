import SwiftUI

// Custom struct to represent each bet member with name and screen time
struct BetMember {
    var name: String
    var screenTime: String
}

struct BetCardView: View {
    var title: String
    var stakes: String
    var members: [BetMember] // List of bet members with name and screen time
    var isActive: Bool // Determines the card's active status for styling
    var wager: Bet
    
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
                // Title
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
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
    }
}

struct BetCardView_Previews: PreviewProvider {
    static var previews: some View {
        BetCardView(
            title: "Friendly Wager",
            stakes: "Loser buys coffee",
            members: [
                BetMember(name: "Alice", screenTime: "2h 15m"),
                BetMember(name: "Bob", screenTime: "1h 45m"),
                BetMember(name: "Charlie", screenTime: "3h 5m")
            ],
            isActive: true, // Preview the active state
            wager: Bet(name: "Friendly Wager", metric: "", appTracking: "", participants: SDModel.groups[0].members, stakes: "", startDate: Date(), endDate: Date())
        )
        .frame(width: UIScreen.main.bounds.width, height: 200) // Full screen width for preview
    }
}
