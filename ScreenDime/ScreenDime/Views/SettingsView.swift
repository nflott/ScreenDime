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
// <<<<<<< maddie_working
        NavigationStack {
            ScrollView {
// =======
//         VStack {
//             ZStack {
//                 HStack {
//                     Button(action: {
//                         dismiss()
//                     }) {
//                         Image(systemName: "arrow.left")
//                             .resizable()
//                             .scaledToFit()
//                             .frame(width: 25, height: 25)
//                             .fs(style: 2)
//                             .fontWeight(.bold)
//                             .padding(.leading, 20)
//                             .padding(.trailing, 25)
//                     }
                    
//                     Spacer()
//                 }
//                 .padding()
                
//                 Text("App Settings")
//                     .font(.largeTitle)
//                     .padding()
//                     .fs(style: 0)
//                     .fontWeight(.bold)
//                     .multilineTextAlignment(.center)
//             }
            
//             HStack {
//                 VStack {
//                     Global.shared.selectedProfileIcon.toImage()
//                         .resizable()
//                         .aspectRatio(contentMode: .fill)
//                         .frame(width: 125, height: 125)
//                         .clipShape(Circle())
//                         .contentShape(Circle())
//                         .padding()
                    
//                     Button(action: {
//                         showProfilePhotoPicker.toggle()
//                     }) {
//                         Text("    Change")
//                             .font(.headline)
//                             .fs(style: 0)
//                             .cornerRadius(8)
//                     }
//                 }
                
                
// >>>>>>> main
                VStack {
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
// <<<<<<< maddie_working
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
// =======
//                             .fs(style: 0)
//                             .padding([.trailing], -50)
//                             .padding([.top, .bottom], 10)
// >>>>>>> main
                        
                        Spacer() 
                        Spacer().frame(width: 25)
                    }
                    .padding(.top, 30) 
                    
                    // Profile Section
                    VStack {
                        // Profile Image
                        Image(systemName: Global.shared.selectedProfileIcon)
                            .font(.system(size: 125))
                        
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
                                
                                if showUsernameEdit {
                                    TextField("Username", text: $username)
                                        .fontWeight(.bold)
                                        .font(.title)
                                        .foregroundColor(.white) 
                                        .padding(10)
                                        .background(Color.white.opacity(0.3)) 
                                        .cornerRadius(8)
                                        .frame(width: 200) 
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
                                    showUsernameEdit.toggle() 
                                }) {
                                    Text("Save")
                                        .fontWeight(.bold)
                                        .foregroundColor(.blue) 
                                        .padding(.horizontal)
                                        .padding(.vertical, 8)
                                }
                            } else {
                                Button(action: {
                                    showUsernameEdit.toggle() 
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
// <<<<<<< maddie_working
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
// =======
//                             .font(.callout)
//                             .fs(style: 0)
//                             .padding([.top], -10)
//                             .padding([.trailing], -50)
// >>>>>>> main
                        
                       
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
    var showArrow: Bool = false 
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.gray)
                .frame(width: 24, height: 24)
            
            Text(title)
                .font(.body)
                .foregroundColor(.white)
            
// <<<<<<< maddie_working
            Spacer()
            
            if let badgeCount = badgeCount {
                Text("\(badgeCount)")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(6)
                    .background(Circle().fill(Color.green))
// =======
//             Rectangle()
//                 .fill(Global.shared.textColor)
//                 .frame(height: 3)
//                 .padding(.vertical, 5)
            
//             HStack {
//                 Text("Choose Theme")
//                     .fontWeight(.bold)
//                     .font(.title)
//                     .fs(style: 0)
//                     .padding()
//                 Spacer()
// >>>>>>> main
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
    @Binding var isOn: Bool 
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.gray)
                .frame(width: 24, height: 24)
            
            Text(title)
                .font(.body)
                .foregroundColor(.white)
            
            Spacer()
            
// <<<<<<< maddie_working
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: .blue))
// =======
//             HStack {
//                 Button(action: {
//                     showProfilePhotoPicker.toggle()
//                 }) {
//                     Text("Logout")
//                         .fontWeight(.bold)
//                         .frame(maxWidth: .infinity, maxHeight: 50)
//                         .font(.headline)
//                         .fs(style: 0)
//                         .fs(style: 0)
//                         .cornerRadius(8)
//                         .padding()
                    
//                 }
//             }
//         }
        
       
//         .navigationBarTitle("Profile", displayMode: .inline)
//         .applyBackground()
//         .sheet(isPresented: $showProfilePhotoPicker) {
//             SettingsPhotoView()
// >>>>>>> main
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