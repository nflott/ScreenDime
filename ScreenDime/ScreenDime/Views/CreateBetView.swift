//
//  CreateBetView.swift
//  ScreenDime
//
//  Created by Luke Currier on 11/4/24.
//
import SwiftUI

struct CreateBetView: View {
    @State private var showNextScreen = false
    @State var betName = ""
    @State var metric = "Select how to measure your usage"
    @State var dailyAvg = "Daily Average"
    @State var weeklyAvg = "Weekly Average"
    @State var overall = "Overall Usage"
    @State var appTracked = "Select what apps to track"
    @State var allApps = "All apps"
    @State var snap = "Snapchat"
    @State var ig = "Instagram"
    @State var fb = "Facebook"
    @State var tikTok = "Tik Tok"
    @State var reddit = "Reddit"
    @State var msgs = "iMessage"
    @State var startDate = Date()
    @State var endDate = Date()
    @State var moneyBet = false
    @State var otherBet = false
    @State var stakes = ""
    
    var body: some View {
        VStack {
            Text("Create a Bet")
                .font(.title)
                .padding()
                .foregroundColor(.white)
                .fontWeight(.bold)
            
            TextField("Name your bet", text: $betName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Menu {
                Button(dailyAvg, action: {metric = dailyAvg})
                Button(weeklyAvg, action: { metric = weeklyAvg})
                Button(overall, action: { metric = overall })
            }
            label: {
                Label(metric, systemImage: "arrowtriangle.down.circle")
            }
            
            Menu {
                Button(allApps, action: { appTracked = allApps })
                Button(snap, action: { appTracked = snap })
                Button(ig, action: { appTracked = ig })
                Button(fb, action: { appTracked = fb })
                Button(tikTok, action: { appTracked = tikTok })
                Button(reddit, action: { appTracked = reddit })
                Button(msgs, action: { appTracked = msgs })
            }
            label: {
                Label(appTracked, systemImage: "arrowtriangle.down.circle")
            }
            .padding()
            
            DatePicker(
                    "Start Date",
                    selection: $startDate,
                    displayedComponents: [.date]
                )
            .foregroundColor(.blue)
            
            DatePicker(
                    "End Date",
                    selection: $endDate,
                    displayedComponents: [.date]
                )
            .foregroundColor(.blue)
            
//            HStack {
//                Text("Choose your wager type:")
//                    .foregroundColor(.blue)
//                    .fontWeight(.bold)
//                Button("Money", action: { moneyBet = true; otherBet = false })
//                Button("Other ", action: { otherBet = true; moneyBet = false })
//            }
//            
//            if moneyBet {
//                TextField("Enter the amount you want to bet", text: $stakes)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//            }
//            
//            if otherBet {
                TextField("Enter the stakes for this bet", text: $stakes)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
//            }
            
            Button(
                action: {
                    showNextScreen = true
                    //need to add bet init, somehow need to pass the group that the user pressed + for
                }){
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
        .fullScreenCover(isPresented: $showNextScreen) {
            HomeView()
        }
    }
    
    func fieldsCompleted() -> Bool {
        return (stakes != "") && (metric != "Select how to measure your usage") && (appTracked != "Select what apps to track")
    }
}

struct BetViewModel_Preview: PreviewProvider {
    static var previews: some View {
        CreateBetView()
    }
}
