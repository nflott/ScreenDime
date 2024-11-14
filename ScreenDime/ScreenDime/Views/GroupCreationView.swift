import SwiftUI

struct GroupCreationView: View {
    @ObservedObject var global = Global.shared
    @Environment(\.dismiss) var dismiss
    
    @State private var showNextScreen = false
    @State var groupName = ""
    @State private var members: [User] = []  // Store User instances instead of names
    @State private var searchText = ""
    @State private var matchedUsers: [User] = [] // Track matched users for dropdown
    
    // Temporary data -----
    let storedUsers = [
        User(name: "Alice", age: 25, phoneNumber: "123-456-7890", screenTime: "2h", email: "alice@example.com", invites: [], groups: [], bets: []),
        User(name: "Bob", age: 30, phoneNumber: "987-654-3210", screenTime: "3h", email: "bob@example.com", invites: [], groups: [], bets: []),
        User(name: "Charlie", age: 22, phoneNumber: "555-666-7777", screenTime: "1h", email: "charlie@example.com", invites: [], groups: [], bets: []),
        User(name: "David", age: 28, phoneNumber: "444-555-6666", screenTime: "2h", email: "david@example.com", invites: [], groups: [], bets: []),
        User(name: "Eve", age: 29, phoneNumber: "333-444-5555", screenTime: "2h", email: "eve@example.com", invites: [], groups: [], bets: [])
    ]
    // ----

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
                .onChange(of: searchText) { newValue in
                    filterMatchedUsers() // Update matched users whenever search text changes
                }
            
            // Display dropdown with matched users that are not already added to the group
            ForEach(matchedUsers, id: \.email) { user in
                HStack {
                    Text(user.name)
                        .foregroundColor(.primary)
                    Spacer()
                    Button(action: {
                        members.append(user)  // Add the user to members list
                        searchText = ""       // Clear the search text
                        filterMatchedUsers()   // Refresh matched users
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                            .font(.title2)
                    }
                }
                .padding(.horizontal)
            }
            
            // List of added users below the search field
            if !members.isEmpty {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Added Members:")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.leading)
                    
                    HStack(spacing: 10) {
                        ForEach(members, id: \.email) { user in
                            HStack {
                                Text(user.name.prefix(1)) // Show the first letter of the user's name
                                    .foregroundColor(.white)
                                    .font(.title2)
                                    .padding()
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white, lineWidth: 2)
                                    )
                                
                                Button(action: {
                                    // Remove the user from members list
                                    members.removeAll { $0.email == user.email }
                                    filterMatchedUsers() // Refresh matched users after removal
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    .padding(.leading)
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            // Create group and save it to the current group
            Button(action: {
                let newGroup = Group(
                    name: groupName,
                    members: members,  // Save User instances to the group
                    bets: []
                )
                Global.shared.groupPages.append(newGroup)
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
    }
    
    // Function to check for completed fields
    func fieldsCompleted() -> Bool {
        return (groupName != "") && !members.isEmpty
    }
    
    // Function to update matched users based on searchText
    func filterMatchedUsers() {
        matchedUsers = storedUsers.filter { user in
            user.name.lowercased().hasPrefix(searchText.lowercased()) &&  // Name should start with searchText
            !members.contains(where: { $0.email == user.email })          // Avoid already added members
        }
    }
}

// Preview for testing
struct GroupCreationView_Previews: PreviewProvider {
    static var previews: some View {
        GroupCreationView()
    }
}
