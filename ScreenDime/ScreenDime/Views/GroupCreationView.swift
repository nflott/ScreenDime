import SwiftUI

struct GroupCreationView: View {
    @ObservedObject var global = Global.shared
    @Environment(\.dismiss) var dismiss
    
    @State private var showNextScreen = false
    @State var groupName = ""
    @State private var members: [UUID] = []  // Store User instances instead of names
    @State private var searchText = ""
    @State private var matchedUsers: [UUID] = [] // Track matched users for dropdown
    
    var body: some View {
        VStack {
            Text("Create a New Group")
                .font(.largeTitle)
                .padding()
                .foregroundColor(.white)
                .fontWeight(.bold)
            
            Text("Group Name")
                .foregroundColor(.white)
            
            TextField("Name your group", text: $groupName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Text("Group Members")
                .foregroundColor(.white)
            
            TextField("Search Group Members", text: $searchText)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: searchText) {
                    filterMatchedUsers() // Update matched users whenever search text changes
                }
            
            // Display dropdown with matched users that are not already added to the group
            ForEach(matchedUsers, id: \.self) { userUUID in
                if let user = global.appUsers.first(where: { $0.id == userUUID }) {
                    HStack {
                        Text(user.name)  // Display user's name
                            .foregroundColor(.primary)
                        Spacer()
                        Button(action: {
                            members.append(user.id)  // Add the user to the members list
                            searchText = ""           // Clear the search text
                            filterMatchedUsers()      // Refresh matched users after adding
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                                .font(.title2)
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            // List of added users below the search field
            if !members.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Added Members:")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.leading)
                    
                    // Use LazyVGrid for wrapping layout
                    let columns = [
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible(), spacing: 10)
                    ]
                    
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(members, id: \.self) { userUUID in
                            if let user = global.appUsers.first(where: { $0.id == userUUID }) {
                                ZStack {
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                        .frame(width: 40, height: 40) // Fixed size for consistency
                                    Text(user.name.prefix(1)) // Display first initial
                                        .foregroundColor(.white)
                                        .font(.headline)
                                }
                                .overlay(
                                    Button(action: {
                                        // Remove the user from members list
                                        members.removeAll { $0 == userUUID }
                                        filterMatchedUsers() // Refresh matched users after removal
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.red)
                                            .offset(x: 10, y: -10) // Position close to top-right
                                    }
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal)
            }

            
            Spacer()
            
            // Create group and save it to the current group
            Button(action: {
                Global.shared.createGroup(name: groupName, members: members)
                Global.shared.selectedGroup = groupName
                dismiss()
            }) {
                Text("Create Group")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .font(.headline)
                    .background(fieldsCompleted() ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding()
            }
            .disabled(fieldsCompleted() ? false : true)
        }
        .padding()
        .applyBackground()
        .onAppear {
            // Initialize matchedUsers with all users when the view appears
            matchedUsers = global.appUsers.map { $0.id }
        }
    }
    
    // Function to check for completed fields
    func fieldsCompleted() -> Bool {
        return (groupName != "") && !members.isEmpty
    }
    
    // Function to update matched users based on searchText
    func filterMatchedUsers() {
        // Only filter if there is search text, otherwise show all users
        if searchText.isEmpty {
            matchedUsers = global.appUsers
                .filter { !members.contains($0.id) } // Exclude already-added members
                .map { $0.id }
        } else {
            matchedUsers = global.appUsers
                .filter { user in
                    user.name.lowercased().hasPrefix(searchText.lowercased()) && // Name should match search text
                    !members.contains(user.id)  // Exclude already-added members
                }.map { $0.id }
        }
    }
}

// Preview for testing
struct GroupCreationView_Previews: PreviewProvider {
    static var previews: some View {
        GroupCreationView()
    }
}
