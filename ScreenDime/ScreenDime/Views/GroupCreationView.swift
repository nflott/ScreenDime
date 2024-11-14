import SwiftUI

struct GroupCreationView: View {
    @ObservedObject var global = Global.shared
    @Environment(\.dismiss) var dismiss
    
    @State private var showNextScreen = false
    @State var groupName = ""
    @State private var searchText = ""
    
    // random temp user data -----
    @State private var members: [User] = []
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
            
            // Write in a name for the group
            TextField("Name your group", text: $groupName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
        
            Text("Group Members")
                .foregroundColor(.white)
            
            // Invite group members
            TextField("Add Group Members", text: $searchText)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // Display search result with an add button if the user exists in storedUsers
            if let matchedUser = storedUsers.first(where: { $0.name.localizedCaseInsensitiveContains(searchText) && !members.contains(where: { $0.name == $0.name }) }) {
                HStack {
                    Text(matchedUser.name)
                        .foregroundColor(.primary)
                    Spacer()
                    Button(action: {
                        // Add the matched user to the members list
                        members.append(matchedUser)
                        searchText = "" // Clear search text after adding
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
                    
                    // Display each added user in a circle with an x button
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
    
    func fieldsCompleted() -> Bool {
        return (groupName != "") && !members.isEmpty
    }
}


struct GroupCreationView_Previews: PreviewProvider {
    static var previews: some View {
        GroupCreationView()
    }
}
