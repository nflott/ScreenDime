//
//  CreateBetView.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//
import SwiftUI

struct CreateBetView: View {
    @ObservedObject var global = Global.shared
    @Environment(\.dismiss) var dismiss
    
    @State private var showNextScreen = false
    @State private var validDates = true
    @State var betName = ""
    @State var metric = "Select how to measure your usage"
    @State var appTracked = "Select what apps to track"
    let metrics = ["Daily Average", "Weekly Average", "Overall Usage"]
    let apps = ["All apps", "Snapchat", "Instagram", "Facebook", "TikTok", "Reddit", "iMessage"]
    
    @State var startDate = Date()
    @State var endDate = Date()
    @State var stakes = ""
    
    var body: some View {
        VStack {
            Text("Create a Bet")
                .font(.largeTitle)
                .padding()
                .foregroundColor(.white)
                .fontWeight(.bold)
            
            // Write in a name for the bet
            TextField("Name your bet", text: $betName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // Select the time format for measurement
            Menu {
                ForEach(metrics, id: \.self) { option in
                    Button(option, action: { metric = option })
                }
            } label: {
                Label(metric, systemImage: "arrowtriangle.down.circle")
                    .foregroundColor(.blue)
            }
            
            // Select the app to track
            Menu {
                ForEach(apps, id: \.self) {app in
                    Button(app, action: {appTracked = app})
                }
            }
            label: {
                Label(appTracked, systemImage: "arrowtriangle.down.circle")
            }
            .padding()
            
            // Select start date
            DatePicker(
                "Start Date",
                selection: $startDate,
                displayedComponents: [.date]
            )
            .foregroundColor(.blue)
            .onChange(of: startDate) {
                checkDates()
            }
            
            // Select end date
            DatePicker(
                "End Date",
                selection: $endDate,
                displayedComponents: [.date]
            )
            .foregroundColor(.blue)
            .onChange(of: endDate) {
                checkDates()
            }
            
            // Make sure dates are legitimate
            if !validDates {
                Text("Invalid dates!")
                    .foregroundColor(.red)
            }
            
            // Enter stakes
            TextField("Enter the stakes for this bet", text: $stakes)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // Create bet and save it to the current group
            Button(action: {
                let newBet = Bet(
                    name: betName,
                    metric: metric,
                    appTracking: appTracked,
                    participants: [],
                    stakes: stakes,
                    startDate: startDate,
                    endDate: endDate
                )
                
                if let index = Global.shared.groupPages.firstIndex(where: { $0.name == Global.shared.selectedGroup }) {
                    var group = Global.shared.groupPages[index]
                    group.addBet(bet: newBet.id)
                    Global.shared.groupPages[index] = group
                }
                
                dismiss()
            }) {
                Text("Create Bet")
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
        return (stakes != "") && (metric != "Select how to measure your usage") && (appTracked != "Select what apps to track") && validDates
    }
    
    func checkDates() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let normalizedStartDate = calendar.startOfDay(for: startDate)
        let normalizedEndDate = calendar.startOfDay(for: endDate)
        
        validDates = normalizedStartDate <= normalizedEndDate && normalizedEndDate >= today && normalizedStartDate >= today
    }
}
struct CreateBetView_Previews: PreviewProvider {
    static var previews: some View {
        CreateBetView()
    }
}

#Preview {
    
}
