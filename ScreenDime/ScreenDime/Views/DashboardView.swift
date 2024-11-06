import SwiftUI

struct DashboardView: View {
    @State private var showingSettings = false
    @State var backgroundOffset = 0
    @State private var rectangleCount = 2 // Initial count of rectangles for dashboard pages
    @State private var selectedPage = 0
    @State private var groupPages: [String] = ["Group 1", "Group 2", "Group 3", "Group 4"] // Dynamic group pages list
    
    let dashboardTitle = "Dashboard"
    let circleColors: [Color] = [.black, .red, .blue, .yellow, .green, .purple, .orange] // Add more colors if needed
    
    var totalPages: Int {
        return 2 + groupPages.count // Dashboard page + Add Group page + group pages
    }

    var body: some View {
        VStack {
            GeometryReader { g in
                ZStack {
                    // Center the Text within the screen width
                    Text(getPageTitle(for: selectedPage))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: g.size.width, height: 40, alignment: .center)
                    
                    // Align the Button to the left
                    HStack {
                        Button(action: {
                            showingSettings.toggle() // Toggle the modal display
                        }) {
                            Image(systemName: "gear")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                        }
                        .padding()
                        
                        Spacer() // Push the button to the left
                    }
                }
                .padding(.top) // Padding at the top of the entire ZStack
                
                TabView(selection: $selectedPage) {
                    // Dashboard page
                    ScrollView(.vertical, showsIndicators: true) {
                        VStack(spacing: 0) {
                            ForEach(0..<2, id: \.self) { _ in
                                Rectangle()
                                    .fill(Color.black.opacity(0.7))
                                    .frame(width: g.size.width - 10, height: 200)
                                    .cornerRadius(5)
                                    .padding(5)
                                    .frame(maxWidth: .infinity, maxHeight: 210)
                            }
                        }
                    }
                    .tag(0) // Set tag to identify as the first page
                    
                    // Group pages
                    ForEach(0..<groupPages.count, id: \.self) { pageIndex in
                        ScrollView(.vertical, showsIndicators: true) {
                            VStack(spacing: 0) {
                                ForEach(0..<rectangleCount, id: \.self) { _ in
                                    Rectangle()
                                        .fill(Color.black.opacity(0.7))
                                        .frame(width: g.size.width - 10, height: 200)
                                        .cornerRadius(5)
                                        .padding(5)
                                        .frame(maxWidth: .infinity, maxHeight: 210)
                                }
                                Button(action: {
                                    rectangleCount += 1
                                }) {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.blue)
                                        .cornerRadius(20)
                                }
                                .padding(.bottom, 20)
                                
                                Spacer()
                                    .frame(height: 100)
                                
                                // Delete Group button
                                Button(action: {
                                    deleteGroup(at: pageIndex)
                                }) {
                                    Text("Delete Group")
                                        .font(.footnote)
                                        .foregroundColor(.red)
                                }
                                .padding(.bottom, 20)
                                
                                           // Additional padding to allow scrolling past the delete button
                                           Spacer()
                                               .frame(height: 100) // Adjust height as needed for more or less padding
                                      
                            }
                        }
                        .tag(pageIndex + 1) // Offset tag by 1 for group pages
                    }
                    
                    // Add Group Page
                    VStack {
                        Spacer()
                        Button(action: {
                            addNewGroupPage()
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.blue)
                        }
                        Spacer()
                    }
                    .tag(groupPages.count + 1) // Tag the Add Group page to be at the end
                }
                .frame(height: g.size.height * 0.8)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .padding(.top, 90)
                .onChange(of: selectedPage) { newValue in
                    backgroundOffset = newValue // Update the backgroundOffset whenever the page changes
                }
                
                // Custom progress circles
                ZStack {
                    Rectangle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 400, height: 70)
                        .cornerRadius(10)
                    
                    HStack(spacing: 15) { // Adjust spacing for better alignment
                        ForEach(0..<totalPages, id: \.self) { index in
                            Circle()
                                .fill(circleColors[index % circleColors.count])
                                .frame(width: backgroundOffset == index ? 40 : 20, height: backgroundOffset == index ? 40 : 20)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 3)
                                )
                        }
                    }
                    .animation(.default)
                }
                .position(x: g.size.width / 2, y: g.size.height / 1.1)
            }
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width > 10 {
                            if self.backgroundOffset > 0 {
                                self.backgroundOffset -= 1
                            }
                        } else if value.translation.width < -10 {
                            if self.backgroundOffset < totalPages - 1 {
                                self.backgroundOffset += 1
                            }
                        }
                    }
            )
        }
        .applyBackground()
        .sheet(isPresented: $showingSettings) {
            SettingsView().applyBackground()
        }
    }
    
    // Adds a new group page at the end of the groupPages array
    private func addNewGroupPage() {
        let newPageTitle = "Group \(groupPages.count + 1)"
        groupPages.append(newPageTitle)
        selectedPage = groupPages.count // Move to the newly created page
    }
    
    // Deletes the specified group from groupPages
    private func deleteGroup(at index: Int) {
        groupPages.remove(at: index)
        
        // Adjust selected page if needed
        if selectedPage > groupPages.count {
            selectedPage = groupPages.count
        }
    }
    
    // Helper function to get page title based on selected page
    private func getPageTitle(for pageIndex: Int) -> String {
        if pageIndex == 0 {
            return dashboardTitle
        } else if pageIndex <= groupPages.count {
            return groupPages[pageIndex - 1]
        } else {
            return "Add Group"
        }
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
