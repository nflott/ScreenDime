import SwiftUI

struct GroupSettingsView: View {
    @ObservedObject private var global = Global.shared
    @Environment(\.dismiss) var dismiss
    @State private var showActiveBets = true
    @State private var isEditingGroupName = false
    @State private var editedGroupName: String = ""
    @State private var showConfirmationDialog = false

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
                        .fs(style: 2)
                        .fontWeight(.bold)
                        .padding(.leading, 10)
                        .padding(.trailing)
                }
                
                // Title
                Text("Group Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .fs(style: 1)
                                
                Spacer()
                
            }
            .padding()
            
            
            
            // Current group information
            if let selectedGroup = global.groupPages.first(where: { $0.name == global.selectedGroup }) {
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
                                .fs(style: 1)
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
                                editedGroupName = selectedGroup.name
                            }) {
                                Text("Cancel")
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                            }
                            .padding(.horizontal, 5)
                        } else {
                            Text("Current Group: \(selectedGroup.name)")
                                .font(.title2)
                                .fs(style: 1)
                                .padding(.vertical)
                            
                            Button(action: {
                                isEditingGroupName = true
                                editedGroupName = selectedGroup.name
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
                            .fs(style: 1)
                            .padding(.top, 10)
                        
                        ForEach(getUserNamesWithScreenTime(for: selectedGroup.members), id: \.name) { user in
                            HStack {
                                Text(user.name)
                                    .font(.title3)
                                    .fs(style: 1)
                                    .bold()
                                    .padding(.leading)
                                
                                Spacer()
                                
                                Text(user.screenTime)
                                    .font(.body)
                                    .fs(style: 1)
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
                                .foregroundColor(showActiveBets ? .white : .blue)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .background(showActiveBets ? Global.shared.iconColor1.opacity(0.7) : Color.clear)
                                .cornerRadius(8)
                        }
                        
                        Button(action: {
                            showActiveBets = false
                        }) {
                            Text("Inactive Bets")
                                .font(.headline)
                                .foregroundColor(!showActiveBets ? .white : .blue)
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .background(!showActiveBets ? Global.shared.iconColor1.opacity(0.7) : Color.clear)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.vertical)
                    
                    // Bets Section
                    ScrollView {
                        if showActiveBets {
                            betListSection(
                                bets: selectedGroup.bets.compactMap { betId in
                                    global.bets.first { $0.id == betId && $0.isActive() }
                                },
                                title: "No active bets in \(selectedGroup.name)."
                            )
                        } else {
                            betListSection(
                                bets: selectedGroup.bets.compactMap { betId in
                                    global.bets.first { $0.id == betId && !$0.isActive() }
                                },
                                title: "No inactive bets in \(selectedGroup.name)."
                            )
                        }
                    }
                    
                    Spacer()
                }
            } else {
                Text("No group selected.")
                    .fs(style: 1)
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
                    .fs(style: 1)
                    .font(.callout)
                    .bold()
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                ForEach(bets, id: \.id) { bet in
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Bet Name: \(bet.name)")
                            .font(.title3)
                            .fs(style: 1)
                            .bold()
                        
                        Text("Tracking App: \(bet.appTracking)")
                            .font(.subheadline)
                            .fs(style: 1)
                        
                        Text("Participants:")
                            .font(.subheadline)
                            .fs(style: 1)
                            .bold()
                        
                        ForEach(getUserNames(for: bet.participants), id: \.self) { participantName in
                            Text(participantName)
                                .fs(style: 1)
                                .padding(.leading)
                        }
                        
                        Text("Stakes: \(bet.stakes)")
                            .font(.subheadline)
                            .fs(style: 1)
                        
                        Text("Start Date: \(formatDate(bet.startDate))")
                            .font(.subheadline)
                            .fs(style: 1)
                        
                        Text("End Date: \(formatDate(bet.endDate))")
                            .font(.subheadline)
                            .fs(style: 1)
                        
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
