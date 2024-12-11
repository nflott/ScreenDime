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
                    ZStack {
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
                                                .padding(.leading, 20)
                                                .padding(.trailing, 25)
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding()
                                    
                                    Text("App Settings")
                                        .font(.largeTitle)
                                        .padding()
                                        .fs(style: 0)
                                        .fontWeight(.bold)
                                        .multilineTextAlignment(.center)
                                }
                    
                    // Profile Section
                    VStack {
                        VStack {
                                            Global.shared.selectedProfileIcon.toImage()
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 125, height: 125)
                                                .clipShape(Circle())
                                                .contentShape(Circle())
                                            
                                            Button(action: {
                                                showProfilePhotoPicker.toggle()
                                            }) {
                                                Text("Change")
                                                    .font(.headline)
                                                    .fs(style: 0)
                                            }
                                        }
                        Spacer()
                        // Username Section with Pencil Icon
                        HStack(spacing: 10) {
                            VStack {
                                
                                if showUsernameEdit {
                                    TextField("Username", text: $username)
                                        .fontWeight(.bold)
                                        .font(.title)
                                        .padding(10)
                                        .background(Color.white.opacity(0.3))
                                        .cornerRadius(8)
                                        .frame(width: 200)
                                } else {
                                    Text(username)
                                        .fontWeight(.bold)
                                        .font(.title)
                                        .padding(.bottom, 5)
                                }
                            }
                            
                            
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
                                        .font(.system(size: 20))
                                }
                            }
                        }
                        .padding(.bottom, 5)
                        
                        // Full Name Section
                        Text("lcurrier@gmailcom")
                        // Full Name Section
                        Text("Luke Currier")
                            .padding(.bottom, 10)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 30)
                    
                    // Resources Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Resources")
                            .fontWeight(.bold)
                        
                        
                        HStack {
                            Image(systemName: "paintpalette")
                                .frame(width: 24, height: 24)
                            
                            Text("Change theme")
                                .font(.body)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                        .onTapGesture {
                            showComingSoonPopup.toggle()
                        }
                        
                        // Push Notifications with Toggle
                        ToggleOption(iconName: "bell", title: "Push notifications", isOn: $pushNotificationsEnabled)
                            .onChange(of: pushNotificationsEnabled) { _ in
                                showComingSoonPopup.toggle()
                            }
                        
                        HStack {
                            Image(systemName: "shield")
                                .frame(width: 24, height: 24)
                            
                            Text("Privacy")
                                .font(.body)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                        .onTapGesture {
                            showComingSoonPopup.toggle()
                        }
                        
                        HStack {
                            Image(systemName: "questionmark.circle")
                                .frame(width: 24, height: 24)
                            Text("Support")
                                .font(.body)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(8)
                        .onTapGesture {
                            showComingSoonPopup.toggle()
                        }
                
                    }
                    .padding()
                    
                    Spacer()
                    
                    NavigationLink(destination: SplashScreen(), isActive: $showSplashScreen) {
                        Button(action: {
                            showSplashScreen.toggle()
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
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.gray)
                .frame(width: 24, height: 24)
            
            Text(title)
                .font(.body)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: .blue))
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
