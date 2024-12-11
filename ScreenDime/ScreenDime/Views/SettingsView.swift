import SwiftUI

struct SettingsView: View {
    @ObservedObject private var global = Global.shared
    
    @Environment(\.dismiss) var dismiss
    
    @State var showProfilePhotoPicker: Bool = false
    @State private var pushNotificationsEnabled: Bool = false // Toggle state for push notifications
    @State private var showUsernameEdit: Bool = false // State for username edit
    @State private var username: String = "Dastardi" // Username state to hold the current value
    @State private var showComingSoonPopup: Bool = false // State to show "Coming Soon" popup
    
    @State private var showSplashScreen: Bool = false // State to control the navigation
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    // Header with back button and title
                    HStack {
                        // Back button
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.blue)
                                .fontWeight(.bold)
                        }
                        .padding(.leading, 20)
                        
                        Spacer()
                        
                        // Title
                        Text("App Settings")
                            .font(.title)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Spacer() // Ensure spacing on both sides of the title
                        
                        // Empty space to align the title with the back arrow
                        Spacer().frame(width: 25)
                    }
                    .padding(.top, 30) // Adjusts vertical padding to bring it higher
                    
                    // Profile Section
                    VStack {
                        // Profile Image
                        Image(systemName: Global.shared.selectedProfileIcon)
                            .font(.system(size: 125))
                        
                        // Change button below the profile image, with less padding to move it closer
                        Button(action: {
                            showProfilePhotoPicker.toggle()
                        }) {
                            Text("Change")
                                .font(.headline)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .padding(.top, -20)
                                .padding(.bottom, 10)
                        }
                        
                        // Username Section with Pencil Icon
                        HStack(spacing: 10) {
                            VStack {
                                // If editing, show a TextField, otherwise show static text
                                if showUsernameEdit {
                                    TextField("Username", text: $username)
                                        .fontWeight(.bold)
                                        .font(.title)
                                        .foregroundColor(.white) // Set the text color to white when editing
                                        .padding(10)
                                        .background(Color.white.opacity(0.3)) // Semi-transparent white background
                                        .cornerRadius(8)
                                        .frame(width: 200) // Limit the width
                                } else {
                                    Text(username) // Display the username normally
                                        .fontWeight(.bold)
                                        .font(.title)
                                        .foregroundColor(.white)
                                        .padding(.bottom, 5)
                                }
                            }
                            
                            // Show Save button when editing, otherwise show pencil icon
                            if showUsernameEdit {
                                Button(action: {
                                    showUsernameEdit.toggle() // Toggle back to non-editing mode
                                    // You can add save action here to persist the username
                                }) {
                                    Text("Save")
                                        .fontWeight(.bold)
                                        .foregroundColor(.blue) // Blue text color for the Save button
                                        .padding(.horizontal)
                                        .padding(.vertical, 8)
                                }
                            } else {
                                Button(action: {
                                    showUsernameEdit.toggle() // Toggle to start editing
                                }) {
                                    Image(systemName: "pencil")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                }
                            }
                        }
                        .padding(.bottom, 5)
                        
                        // Full Name Section
                        Text("lcurrier@gmailcom")
                            .foregroundColor(.white)
                        // Full Name Section
                        Text("Luke Currier")
                            .foregroundColor(.white)
                            .padding(.bottom, 10)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 30)
                    
                    // Resources Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Resources")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        // Change 'My stores' to 'Change theme' with a color palette icon and arrow
                        HStack {
                            Image(systemName: "paintpalette")
                                .foregroundColor(.gray)
                                .frame(width: 24, height: 24)
                            
                            Text("Change theme")
                                .font(.body)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right") // Small arrow
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                        .onTapGesture {
                            showComingSoonPopup.toggle() // Trigger the "Coming Soon" popup when tapped
                        }
                        
                        // Push Notifications with Toggle
                        ToggleOption(iconName: "bell", title: "Push notifications", isOn: $pushNotificationsEnabled)
                            .onChange(of: pushNotificationsEnabled) { _ in
                                showComingSoonPopup.toggle() // Show "Coming Soon" when toggled
                            }
                        
                        // Changed Face ID to Privacy with an arrow
                        ProfileOption(iconName: "shield", title: "Privacy", badgeCount: nil, showArrow: true)
                            .onTapGesture {
                                showComingSoonPopup.toggle() // Trigger the "Coming Soon" popup when tapped
                            }
                        
                        // Support Option
                        ProfileOption(iconName: "questionmark.circle", title: "Support", badgeCount: nil, showArrow: true)
                            .onTapGesture {
                                showComingSoonPopup.toggle() // Trigger the "Coming Soon" popup when tapped
                            }
                
                    }
                    .padding()
                    
                    Spacer()
                    
                    // Logout Button with Navigation Link to Splash Screen
                    NavigationLink(destination: SplashScreen(), isActive: $showSplashScreen) {
                        Button(action: {
                            showSplashScreen.toggle() // Trigger navigation when logout is pressed
                        }) {
                            Text("Logout")
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .font(.headline)
                                .foregroundColor(.white)
                                .background(Color.red)
                                .cornerRadius(8)
                                .padding()
                        }
                    }
                }
                .padding()
                .applyBackground()
                .cornerRadius(10) // Optional: to add rounded corners to the whole screen
            }
            .navigationBarHidden(true) // Hide default navigation bar
            .sheet(isPresented: $showProfilePhotoPicker) {
                SettingsPhotoView()
            }
            .alert(isPresented: $showComingSoonPopup) {
                Alert(title: Text("Coming Soon"), message: Text("This feature is coming soon!"), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct ProfileOption: View {
    let iconName: String
    let title: String
    var badgeCount: Int? = nil
    var showArrow: Bool = false // New property to decide if an arrow is shown
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.gray)
                .frame(width: 24, height: 24)
            
            Text(title)
                .font(.body)
                .foregroundColor(.white)
            
            Spacer()
            
            if let badgeCount = badgeCount {
                Text("\(badgeCount)")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(6)
                    .background(Circle().fill(Color.green))
            }
            
            if showArrow {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(8)
    }
}

struct ToggleOption: View {
    let iconName: String
    let title: String
    @Binding var isOn: Bool // Binding to toggle push notifications
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.gray)
                .frame(width: 24, height: 24)
            
            Text(title)
                .font(.body)
                .foregroundColor(.white)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: .blue)) // Customize the toggle appearance
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(8)
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
