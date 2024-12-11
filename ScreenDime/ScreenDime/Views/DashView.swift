import SwiftUI

struct DashView: View {
    var body: some View {
        VStack(spacing: 20) {
            
            WeeklyReportPreview()
                .shadow(color: Global.shared.iconColor2, radius: 10, x: 0, y: 0)
            
            // 'Activity' card
            VStack {
                HStack {
                    Text("Activity")
                        .fontWeight(.bold)
                        .fs(style: 1)
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
            .background(Global.shared.iconColor2)
            .cornerRadius(10)
            .padding(.horizontal)
            .shadow(color: Global.shared.iconColor2, radius: 10, x: 0, y: 0)
            
            Spacer()
        }
        .padding(.top, 40)
    }
}

// temp data for Activities ----
struct Activity: Identifiable {
    var id = UUID()  // Unique identifier for each activity (will be Bet Struct)
    var name: String
    var bet: String
    var date: String
}

let sampleActivityData: [Activity] = [
    Activity(name: "Bob", bet: "doing dishes", date: "Nov 13, 2024"),
    Activity(name: "Alice", bet: "$20", date: "Nov 12, 2024"),
    Activity(name: "John", bet: "buying coffee", date: "Nov 11, 2024"),
    Activity(name: "Sarah", bet: "getting lunch", date: "Nov 10, 2024"),
    Activity(name: "Alice", bet: "$10", date: "Nov 12, 2024"),
    Activity(name: "John", bet: "$3", date: "Nov 11, 2024"),
    Activity(name: "Sarah", bet: "getting lunch", date: "Nov 10, 2024")
]

struct ActivityRow: View {
    var activity: Activity
    
    var body: some View {
        HStack {
            Text("\(activity.name)")
                .fs(style: 1)
                .font(.body)
                .fontWeight(.bold)
            Text("owes")
                .fs(style: 1)
                .font(.body)
            Text(activity.bet)
                .fs(style: 4)
                .font(.body)
            Text(activity.date)
                .fs(style: 1)
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
                    .fs(style: 1)
                Spacer()
                Button(action: {
                    // Toggle the sheet to show the ReportView
                    showingReport.toggle()
                }) {
                    Image(systemName: "rectangle.expand.vertical")
                        .fs(style: 1)
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            HStack(spacing: 12) {
                ForEach(orderedDays, id: \.self) { day in
                    VStack {
                        Rectangle()
                            .fill(Global.shared.iconColor1)
                            .frame(width: 30, height: CGFloat(screenTimeData[day]!)/2)
                        
                        Text(day)
                            .fs(style: 1)
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
        .background(Global.shared.iconColor2)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct DashView_Previews: PreviewProvider {
    static var previews: some View {
        DashView()
    }
}

