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
                                    .fs(style: 1)
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
                                        .fs(style: 0)
                                        .background(Global.shared.iconColor1.opacity(0.3))
                                        .cornerRadius(8)
                                        .frame(width: 200)
                                } else {
                                    Text(username)
                                        .fontWeight(.bold)
                                        .font(.title)
                                        .fs(style: 0)
                                        .padding(.bottom, 5)
                                }
                            }
                            
                            
                            if showUsernameEdit {
                                Button(action: {
                                    showUsernameEdit.toggle()
                                }) {
                                    Text("Save")
                                        .fontWeight(.bold)
                                        .fs(style: 1)
                                        .padding(.horizontal)
                                        .padding(.vertical, 8)
                                }
                            } else {
                                Button(action: {
                                    showUsernameEdit.toggle()
                                }) {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 20))
                                        .fs(style: 1)
                                }
                            }
                        }
                        .padding(.bottom, 5)
                        
                        // Full Name Section
                        Text("lukecurrier@gmail.com")
                            .fs(style: 0)
                        // Full Name Section
                        Text("Luke Currier")
                            .fs(style: 0)
                            .padding(.bottom, 10)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 30)
                    
                    // Resources Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Resources")
                            .fontWeight(.bold)
                            .fs(style: 0)
                        
                        HStack {
                            Image(systemName: "paintpalette")
                                .fs(style: 0)
                                .frame(width: 24, height: 24)
                            
                            Text("Change theme")
                                .font(.body)
                                .fs(style: 0)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .fs(style: 1)
                        }
                        .padding()
                        .background(Global.shared.iconColor1.opacity(0.2))
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
                                .fs(style: 0)
                                .frame(width: 24, height: 24)
                            
                            Text("Privacy")
                                .fs(style: 0)
                                .font(.body)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .fs(style: 1)
                        }
                        .padding()
                        .background(Global.shared.iconColor1.opacity(0.2))
                        .cornerRadius(8)
                        .onTapGesture {
                            showComingSoonPopup.toggle()
                        }
                        
                        HStack {
                            Image(systemName: "questionmark.circle")
                                .fs(style: 0)
                                .frame(width: 24, height: 24)
                            Text("Support")
                                .fs(style: 0)
                                .font(.body)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .fs(style: 1)
                        }
                        .padding()
                        .background(Global.shared.iconColor1.opacity(0.2))
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
                                .fs(style: 0)
                                .background(Global.shared.iconColor3)
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
                .fs(style: 0)
                .frame(width: 24, height: 24)
            
            Text(title)
                .font(.body)
                .fs(style: 0)
            
            Spacer()
            
            if let badgeCount = badgeCount {
                Text("\(badgeCount)")
                    .font(.caption)
                    .fs(style: 0)
                    .padding(6)
                    .background(Circle().fill(Global.shared.iconColor1))
            }
            
            if showArrow {
                Image(systemName: "chevron.right")
                    .fs(style: 1)
                
            }
        }
        .padding()
        .background(Global.shared.iconColor1.opacity(0.2))
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
                .fs(style: 0)
                .frame(width: 24, height: 24)
            
            Text(title)
                .fs(style: 0)
                .font(.body)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: Global.shared.iconColor1))
        }
        .padding()
        .background(Global.shared.iconColor1.opacity(0.2))
        .cornerRadius(8)
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
