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
    @State var showingRejectDialog: Bool = false
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
                    .fill(bet.hasStarted() ? activeColor : stillStartingColor) // Green if not started, Blue if started
                    .frame(maxWidth: .infinity, minHeight: dynamicCardHeight()) // Dynamic card height
                    .cornerRadius(10)
                    .shadow(color: bet.hasStarted() ? .blue.opacity(0.6) : .green.opacity(0.6), radius: 10, x: 0, y: 0) // Shadow color based on the state
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    // Title
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    // Only show thumbs up and down if the bet has not started yet
                    if !bet.hasStarted() && !global.betsUserIsIn.contains(title) && !betRejected {
                        Button(action: {
                            showingAcceptDialog.toggle()
                        }) {
                            Image(systemName: "hand.thumbsup.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.blue)
                        }
                        .padding([.trailing], 15)
                        
                        Button(action: {
                            showingRejectDialog.toggle()
                        }) {
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
                    let sortedMembers = getUserDetails(for: members).sorted {
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
        if showingAcceptDialog {
            VStack(spacing: 20) {
                Text("New Bet")
                    .font(.headline)
                
                Text("Join \(title)?")
                    .multilineTextAlignment(.center)
                    .padding()
                
                HStack {
                    Button("Cancel") {
                        showingAcceptDialog = false
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    Button("Confirm") {
                        showingAcceptDialog = false
                        acceptBet()
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
            .frame(width: 350, height: 300)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 10)
            .padding()
        }
        
        if showingRejectDialog {
            VStack(spacing: 20) {
                Text("Are you sure you don't want to join \(title)?")
                    .multilineTextAlignment(.center)
                    .padding()
                
                HStack {
                    Button("Cancel") {
                        showingRejectDialog = false
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    Button("Confirm") {
                        showingRejectDialog = false
                        rejectBet()
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
            }
            .frame(width: 350, height: 300)
            .background(Color.white)
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
    
    private func acceptBet() {
        // Add the bet's title to the 'betsUserIsIn' array
        Global.shared.betsUserIsIn.append(title)
        
        // Find the bet in Global.shared.bets based on the title
        guard let bet = Global.shared.bets.first(where: { $0.name == title }) else {
            print("Bet not found!")
            return
        }
        
        // Add the user to the bet and the bet to the user's list
        Global.shared.addUserToBet(addedUser: Global.shared.mainUser.id, bet: bet.id)
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
        
        if let mainUser = global.appUsers.first(where: { $0.id == global.mainUser.id }), !members.contains(global.mainUser.id) {
            userDetails.insert((name: mainUser.name, screenTime: mainUser.screenTime), at: 0)
        }
        
        print(userDetails)
        return userDetails
    }

}

