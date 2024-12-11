import SwiftUI

struct ReportView: View {
    @Environment(\.dismiss) var dismiss
    
    // temp data -----
    let appUsageData: [String: String] = [
        "Instagram": "2h 5m",
        "Facebook": "30m",
        "Twitter": "20m",
        "Messages": "3h 4m",
        "YouTube": "3h 1m"
    ]
    var totalWeeklyScreenTime = "17h 39m"
    var dailyAverage = "4h 24m"
    //------
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack {
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
                    }
                    .padding()
                    
                    Spacer()
                }
                
                ScrollView {
                    VStack(spacing: 30) {
                        DailyAverageView(dailyAverage: dailyAverage)
                        WeeklyTotalView(totalWeeklyScreenTime: totalWeeklyScreenTime)
                        AppUsageListView(appUsageData: appUsageData)
                        Spacer()
                    }
                    .navigationBarTitle("Screen Time Report", displayMode: .inline)
                    .padding()
                }
            }
            .applyBackground()
        }
    }
}

// Subview for Daily Average
struct DailyAverageView: View {
    let dailyAverage: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Daily Average")
                .font(.title2)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(dailyAverage)
                .font(.system(size: 40))
                .fs(style: 0)
                .padding(.top, 3)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// Subview for Total Weekly Screen Time
struct WeeklyTotalView: View {
    let totalWeeklyScreenTime: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Total Weekly Screen Time")
                .font(.title2)
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(totalWeeklyScreenTime)
                .font(.system(size: 40))
                .fs(style: 0)
                .padding(.top, 3)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// Subview for App Usage List
struct AppUsageListView: View {
    let appUsageData: [String: String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("App Usage")
                .font(.title2)
                .foregroundColor(.gray)
                .padding(.horizontal)
            
            ForEach(appUsageData.keys.sorted(), id: \.self) { app in
                HStack {
                    Image(systemName: "app.fill")
                        .fs(style: 0)
                        .frame(width: 50, height: 50)
                        .padding(.trailing, 5)
                        .font(.system(size: 35))
                    
                    Text(app)
                        .fs(style: 0)
                        .font(.body)
                    
                    Spacer()
                    
                    Text(appUsageData[app] ?? "0")
                        .fs(style: 3)
                        .font(.body)
                }
                .padding(.horizontal)
                .padding(.vertical, 1)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            }
        }
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
    }
}
