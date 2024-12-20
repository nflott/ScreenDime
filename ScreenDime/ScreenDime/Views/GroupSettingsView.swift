import SwiftUI

struct GroupSettingsView: View {
    @ObservedObject private var global = Global.shared
    @Environment(\.dismiss) var dismiss
    @State private var showActiveBets = true
    @State private var isEditingGroupName = false
    @State private var editedGroupName: String = ""
    @State private var showConfirmationDialog = false
    @State private var leaveGroupConfirm = false
    @State private var selectedGroup: Group? = Global.shared.groupPages.first(where: { $0.name == Global.shared.selectedGroup })
    @State private var showHomeView = false

    var body: some View {
        ZStack {
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
                            .padding(.leading, 10)
                            .padding(.trailing)
                    }
                    
                    // Title
                    Text("Group Settings")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .fs(style: 0)
                    
                    Spacer()
                    
                }
                .padding()
                
                VStack {
                    // Group Name Editing Section
                    HStack {
                        if isEditingGroupName {
                            TextField("Group Name", text: $editedGroupName)
                                .textFieldStyle(PlainTextFieldStyle())
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Global.shared.iconColor1, lineWidth: 1)
                                )
                                .fs(style: 0)
                                .font(.title2)
                                .padding(.vertical)
                            
                            Button(action: {
                                showConfirmationDialog = true
                            }) {
                                Text("Save")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }
                            .padding(.horizontal, 5)
                            
                            Button(action: {
                                isEditingGroupName = false
                                editedGroupName = selectedGroup!.name
                            }) {
                                Text("Cancel")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }
                            .padding(.horizontal, 5)
                        } else {
                            Text("\(selectedGroup!.name)")
                                .font(.title2)
                                .fs(style: 0)
                                .padding(.vertical)
                            
                            Button(action: {
                                isEditingGroupName = true
                                editedGroupName = selectedGroup!.name
                            }) {
                                Image(systemName: "pencil")
                                    .fs(style: 1)
                            }
                        }
                    }
                    
                    // List of Current Users in the Group
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Current Users:")
                            .font(.headline)
                            .fs(style: 0)
                            .padding(.top, 10)
                        
                        ForEach(getUserNamesWithScreenTime(for: selectedGroup!.members), id: \.name) { user in
                            HStack {
                                Text(user.name)
                                    .font(.title3)
                                    .fs(style: 0)
                                    .bold()
                                    .padding(.leading)
                                
                                Spacer()
                                
                                Text(user.screenTime)
                                    .font(.body)
                                    .fs(style: 0)
                                    .padding(.trailing)
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Active/Inactive Bets Toggle
                    HStack {
                        Button(action: {
                            showActiveBets = true
                        }) {
                            Text("Active Bets")
                                .font(.headline)
                                .foregroundColor(showActiveBets ? .white : Global.shared.altTextColor)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .background(showActiveBets ? Global.shared.altTextColor.opacity(0.7) : Color.clear)
                                .cornerRadius(8)
                        }
                        
                        Button(action: {
                            showActiveBets = false
                        }) {
                            Text("Inactive Bets")
                                .font(.headline)
                                .foregroundColor(!showActiveBets ? .white : Global.shared.altTextColor)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .background(!showActiveBets ? Global.shared.altTextColor.opacity(0.7) : Color.clear)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.vertical)
                    
                    // Bets Section
                    ScrollView {
                        if showActiveBets {
                            betListSection(
                                bets: selectedGroup!.bets.compactMap { betId in
                                    global.bets.first { $0.id == betId && $0.isActive() }
                                },
                                title: "No active bets in \(selectedGroup!.name)."
                            )
                        } else {
                            betListSection(
                                bets: selectedGroup!.bets.compactMap { betId in
                                    global.bets.first { $0.id == betId && !$0.isActive() }
                                },
                                title: "No inactive bets in \(selectedGroup!.name)."
                            )
                        }
                    }
                    
                    Spacer()
                }
                
                Button(action: {
                    leaveGroupConfirm = true
                }) {
                    Text("Leave Group")
                        .fontWeight(.bold)
                        .frame(maxWidth: 150, maxHeight: 40)
                        .font(.headline)
                        .bs(style: 3)
                        .fs(style: 0)
                        .cornerRadius(8)
                        .padding()
                }
            }
            .padding()
            .applyBackground()
            .alert(isPresented: $showConfirmationDialog) {
                Alert(
                    title: Text("Confirm Name Change"),
                    message: Text("Are you sure you want to change the group name?"),
                    primaryButton: .default(Text("Yes"), action: {
                        if let selectedGroupIndex = global.groupPages.firstIndex(where: { $0.name == global.selectedGroup }) {
                            global.groupPages[selectedGroupIndex].name = editedGroupName
                            global.selectedGroup = editedGroupName
                        }
                        isEditingGroupName = false
                    }),
                    secondaryButton: .cancel(Text("No"), action: {
                        isEditingGroupName = false
                    })
                )
            }
                
            if leaveGroupConfirm {
                if Global.shared.groupPages.count > 1 {
                    VStack(spacing: 20) {
                        Text("Leaving Group")
                            .font(.headline)
                        
                        Text("Are you sure you want to leave this group? You can't return unless you're invited again!")
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        HStack {
                            Button("Cancel") {
                                leaveGroupConfirm = false
                            }
                            .padding()
                            .bs(style: 2)
                            .fs(style: 0)
                            .cornerRadius(8)
                            
                            Button("Leave") {
                                leaveGroup()
                            }
                            .padding()
                            .bs(style: 3)
                            .fs(style: 0)
                            .cornerRadius(8)
                        }
                    }
                    .frame(width: 350, height: 300)
                    .background(Global.shared.backgroundColor[0])
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .padding()
                }
                else {
                    VStack(spacing: 20) {
                        Text("Last Group")
                            .font(.headline)
                        
                        Text("You can't leave this group - it's your last one!")
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        
                            Button("Ok") {
                                leaveGroupConfirm = false
                            }
                            .padding()
                            .bs(style: 2)
                            .fs(style: 0)
                            .cornerRadius(8)
                    }
                    .frame(width: 350, height: 300)
                    .background(Global.shared.backgroundColor[0])
                    .cornerRadius(10)
                    .shadow(radius: 10)
                    .padding()
                }
            }
        }
        .fullScreenCover(isPresented: $showHomeView) {
            HomeView()
        }
    }
    
    private func leaveGroup() {
        if let selectedGroup = selectedGroup {
            global.groupPages.removeAll { $0.id == selectedGroup.id }
            global.selectedGroup = global.groupPages[0].name
            global.showGroupLeftPopup = true 
            showHomeView = true
        }
    }
    
    private func getUserNamesWithScreenTime(for participants: [UUID]) -> [(name: String, screenTime: String)] {
        return participants.compactMap { participantUUID in
            if let user = global.appUsers.first(where: { $0.id == participantUUID }) {
                return (user.name, user.screenTime) // Assuming screenTime is a String
            }
            return nil
        }
    }
    
    private func getUserNames(for participants: [UUID]) -> [String] {
        return participants.compactMap { participantUUID in
            if let user = global.appUsers.first(where: { $0.id == participantUUID }) {
                return user.name
            }
            return nil
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
    
    private func betListSection(bets: [Bet], title: String) -> some View {
        VStack(alignment: .leading) {
            if bets.isEmpty {
                Text(title)
                    .fs(style: 0)
                    .font(.callout)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                ForEach(bets, id: \.id) { bet in
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Bet Name: \(bet.name)")
                            .font(.title3)
                            .fs(style: 0)
                            .bold()
                        
                        Text("Tracking App: \(bet.appTracking)")
                            .font(.subheadline)
                            .fs(style: 0)
                        
                        Text("Participants:")
                            .font(.subheadline)
                            .fs(style: 0)
                            .bold()
                        
                        ForEach(getUserNames(for: bet.participants), id: \.self) { participantName in
                            Text(participantName)
                                .fs(style: 0)
                                .padding(.leading)
                        }
                        
                        Text("Stakes: \(bet.stakes)")
                            .font(.subheadline)
                            .fs(style: 0)
                        
                        Text("Start Date: \(formatDate(bet.startDate))")
                            .font(.subheadline)
                            .fs(style: 0)
                        
                        Text("End Date: \(formatDate(bet.endDate))")
                            .font(.subheadline)
                            .fs(style: 0)
                        
                        Divider()
                            .background(Color.gray)
                            .padding(.vertical, 5)
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct GroupSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        GroupSettingsView()
    }
}
