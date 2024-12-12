import SwiftUI

struct DashView: View {
    @ObservedObject private var global = Global.shared
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                
                WeeklyReportPreview()
                    .shadow(color: Global.shared.altTextColor, radius: 10, x: 0, y: 0)
                
                // 'Activity' card
                VStack {
                    HStack {
                        Text("Activity")
                            .fontWeight(.bold)
                            .fs(style: 5)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Feed of recent bets/activity
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(sampleActivityData) { activity in
                                ActivityRow(activity: activity)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 20)
                    .frame(maxHeight: .infinity)
                }
                .frame(height: 400)
                .background(Global.shared.altTextColor)
                .cornerRadius(10)
                .padding(.horizontal)
                .shadow(color: Global.shared.altTextColor, radius: 10, x: 0, y: 0)
                
                Spacer()
            }
            .padding(.top, 40)
            
            if global.showGroupLeftPopup {
                VStack(spacing: 20) {
                    Text("You have successfully left the group.")
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Button("OK") {
                        global.showGroupLeftPopup = false
                    }
                    .padding()
                    .fs(style: 0)
                    .background(Global.shared.iconColor1)
                    .cornerRadius(8)
                }
                .frame(width: 200, height: 150)
                .background(Global.shared.backgroundColor[0])
                .cornerRadius(10)
                .shadow(radius: 10)
                .padding()
            }
        }
    }
}

// temp data for Activities ----
struct Activity: Identifiable {
    var id = UUID()  // Unique identifier for each activity (will be Bet Struct)
    var name: String
    var transition: String
    var bet: String
    var date: String
    var tag: Int
}

let sampleActivityData: [Activity] = [
    Activity(name: "Bob", transition: "owes", bet: "doing dishes", date: "Nov 13, 2024", tag: 4),
    Activity(name: "You", transition: "won", bet: "$20", date: "Nov 12, 2024", tag: 3),
    Activity(name: "John", transition: "owes", bet: "buying coffee", date: "Nov 11, 2024", tag: 4),
    Activity(name: "You", transition: "owe", bet: "getting lunch", date: "Nov 10, 2024", tag: 4),
    Activity(name: "Alice", transition: "won", bet: "$10", date: "Nov 12, 2024", tag: 3),
    Activity(name: "John", transition: "won", bet: "$3", date: "Nov 11, 2024", tag: 3),
    Activity(name: "Sarah", transition: "owes", bet: "getting lunch", date: "Nov 10, 2024", tag: 4)
]

struct ActivityRow: View {
    var activity: Activity
    
    var body: some View {
        HStack {
            Text("\(activity.name)")
                .fs(style: 5)
                .font(.body)
                .fontWeight(.bold)
            Text(activity.transition)
                .fs(style: 5)
                .font(.body)
            Text(activity.bet)
                .fs(style: activity.tag)
                .bold()
                .font(.body)
            Text(activity.date)
                .fs(style: 5)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.bottom, 4)
    }
}

let screenTimeData: [String: Int] = [
    "Sun": 120, "Mon": 150, "Tue": 200, "Wed": 180, "Thu": 140, "Fri": 160, "Sat": 190,
]

let orderedDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]


// preview card for the Weekly Report
struct WeeklyReportPreview: View {
    @State private var showingReport = false

    var body: some View {
        VStack {
            HStack {
                Text("Weekly Report")
                    .font(.headline)
                    .fontWeight(.bold)
                    .fs(style: 5)
                Spacer()
                Button(action: {
                    // Toggle the sheet to show the ReportView
                    showingReport.toggle()
                }) {
                    Image(systemName: "rectangle.expand.vertical")
                        .fs(style: 5)
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            HStack(spacing: 12) {
                ForEach(orderedDays, id: \.self) { day in
                    VStack {
                        Rectangle()
                            .fill(Global.shared.iconColor2)
                            .frame(width: 30, height: CGFloat(screenTimeData[day]!)/2)
                        
                        Text(day)
                            .fs(style: 5)
                            .font(.caption)
                            .frame(width: 35)
                    }
                }
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .sheet(isPresented: $showingReport) {
            // Show the ReportView when the sheet is triggered
            ReportView()
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .background(Global.shared.altTextColor)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct DashView_Previews: PreviewProvider {
    static var previews: some View {
        DashView()
    }
}

