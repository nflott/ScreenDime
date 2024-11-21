import SwiftUI

struct BetCardView: View {
    @ObservedObject var global = Global.shared
    
    var bet: Bet
    var title: String
    var stakes: String
    var members: [UUID]
    var isActive: Bool
    
    @State var showingFullBet: Bool = false
    @State var showingAcceptDialog: Bool = false
    @State var betRejected: Bool = false
    
    // Colors for active and inactive states
    let activeColor: Color = .blue
    let inactiveColor: Color = .gray
    let stillStartingColor: Color = .green
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Button(action: {
                showingFullBet.toggle()
            }) {
                // Set color based on the bet's start status
                Rectangle()
                    .fill(cardColor())
                    .frame(maxWidth: .infinity, minHeight: dynamicCardHeight()) // Dynamic card height
                    .cornerRadius(10)
                    .shadow(color: cardShadowColor(), radius: 10, x: 0, y: 0) // Shadow color based on the state
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    // Title
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)

                    Spacer()

                    // Status message or button
                    if bet.hasEnded() {
                        // Display "Bet Ended" text
                        Text("Bet Ended")
                            .font(.footnote)
                            .foregroundColor(.white.opacity(0.7))
                    } else if !bet.hasStarted() {
                        if global.mainUser.bets.contains(bet.id) {
                            // Display countdown to when it starts
                            let countdown = bet.startDate.timeIntervalSinceNow
                            if countdown > 0 {
                                Text("Starts in \(formatCountdown(countdown))")
                                    .font(.footnote)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        } else {
                            // Show "Join Bet" button
                            Button(action: {
                                print("Showing accept dialog")
                                showingAcceptDialog.toggle()
                            }) {
                                Text("Join Bet")
                                    .scaledToFit()
                                    .frame(width: 80, height: 40)
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }
                            .padding([.trailing], 15)
                        }
                    } else {
                        // Display time remaining for active bet
                        let timeRemaining = bet.endDate.timeIntervalSinceNow
                        if timeRemaining > 0 {
                            Text("Time left: \(formatCountdown(timeRemaining))")
                                .font(.footnote)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                }

                
                // Stakes text
                Text("Stakes: \(stakes)")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
                                
                // Bet members
                VStack(alignment: .leading, spacing: 4) {
                    let sortedMembers = getUserDetails(for: bet.participants).sorted {
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
                    
                    
                    if members.count == 0 {
                        Text("No one's here yet...")
                            .foregroundColor(.white)
                    }
                    
                    // Show "+X more" if there are more than 3 members
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
        if showingAcceptDialog {
            VStack(spacing: 20) {
                
                Text("Join \(title)?")
                    .multilineTextAlignment(.center)
                    .padding()
                
                HStack {
                    Button("Cancel") {
                        print("Cancelling...")
                        showingAcceptDialog = false
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    Button("Confirm") {
                        print("Accepting Bet")
                        acceptBet()
                        showingAcceptDialog = false
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
            .frame(width: 215, height: 175)
            .multilineTextAlignment(.center)
            .applyBackground()
            .cornerRadius(10)
            .shadow(radius: 10)
            .padding()
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
    
    private func formatCountdown(_ interval: TimeInterval) -> String {
        let seconds = Int(interval) % 60
        let minutes = (Int(interval) / 60) % 60
        let hours = (Int(interval) / 3600)
        
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else if minutes > 0 {
            return "\(minutes)m \(seconds)s"
        } else {
            return "\(seconds)s"
        }
    }
    
    private func acceptBet() {
        guard let bet = Global.shared.bets.first(where: { $0.name == title }) else {
            print("Bet not found!")
            return
        }
        print("Adding \(bet.name) to main user")
        Global.shared.addUserToBet(addedUser: Global.shared.mainUser.id, bet: bet.id)
    }
    
    private func cardColor() -> Color {
        if bet.hasEnded() {
            return inactiveColor
        } else if !bet.hasStarted() {
            return stillStartingColor
        } else {
            return activeColor
        }
    }

    private func cardShadowColor() -> Color {
        if bet.hasEnded() {
            return inactiveColor.opacity(0.6)
        } else if !bet.hasStarted() {
            return stillStartingColor.opacity(0.6)
        } else {
            return activeColor.opacity(0.6)
        }
    }

    private func rejectBet() {
        betRejected = true
    }
    
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

    private func getUserDetails(for members: [UUID]) -> [(name: String, screenTime: String)] {
        var userDetails = members.compactMap { memberUUID in
            if let user = global.appUsers.first(where: { $0.id == memberUUID }) {
                return (name: user.name, screenTime: user.screenTime)
            } else {
                return nil
            }
        }

        if members.contains(global.mainUser.id) {
            if let mainUser = global.appUsers.first(where: { $0.id == global.mainUser.id }) {
                userDetails.insert((name: mainUser.name, screenTime: mainUser.screenTime), at: 0)
            }
        }

        print("\(title): \(userDetails)")
        return userDetails
    }
}

