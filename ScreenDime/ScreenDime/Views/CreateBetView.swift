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
    @Binding var groupPages: [Group]
    
   
    
    var body: some View {
        VStack {
            Text("Create a bet")
                .font(.title)
                .padding()
                .foregroundColor(.white)
                .fontWeight(.bold)
            
            TextField("Name of your bet", text: $betName)
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
            
            HStack {
                Text("Choose your wager type:")
                    .foregroundColor(.blue)
                    .fontWeight(.bold)
                Button("Money", action: { moneyBet = true; otherBet = false })
                Button("Other ", action: { otherBet = true; moneyBet = false })
            }
            
            if moneyBet {
                TextField("Enter the amount you want to bet", text: $stakes)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            if otherBet {
                TextField("Enter the stakes for this bet", text: $stakes)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            Button(
                action: {
                    addBetToGroup()
//                    showNextScreen = true
                }){
                    Text("Create this bet")
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
    
    func addBetToGroup() {
        if var selectedGroup = groupPages.first(where: {$0.name == Global.shared.selectedGroup}) {
            selectedGroup.addBet(bet: Bet(name: betName,
                                          metric: metric,
                                          appTracking: appTracked,
                                          participants: selectedGroup.members,
                                          stakes: stakes,
                                          startDate: startDate,
                                          endDate: endDate))
        }
    }
}

//Container so that the preview works with the binding var groupPages
struct CreateBetViewPreviewContainer : View {
     @State
    private var groupPages: [Group] = [Group(name: "Group 1",
                                             members: [],
                                             bets: [Bet(name: "Friendlier Wager",
                                                        metric: "Weekly",
                                                        appTracking: "Instagram",
                                                        participants: [User(name: "Alice", age:18, phoneNumber:"1788766756", screenTime: "2h 15m",                 email: "alice@gmail.com", invites:[], groups:[], bets:[]),
                                                                       User(name: "Bob", age:19, phoneNumber:"8972347283", screenTime: "1h 56m", email: "bob@gmail.com", invites:[], groups:[], bets:[]),
                                                                       User(name: "Steve", age:20, phoneNumber:"2987473292", screenTime: "4h 10m", email: "steve@gmail.com", invites:[], groups:[], bets:[])],
                                                        stakes: "Loser cleans the bathroom",
                                                        startDate: Date().addingTimeInterval(-2),
                                                        endDate: Date().addingTimeInterval(3)),
                                                    Bet(name: "Friendly Wager",
                                                        metric: "Weekly",
                                                        appTracking: "All Apps",
                                                        participants: [User(name: "Alice", age:18, phoneNumber:"1788766756", screenTime: "2h 15m",                 email: "alice@gmail.com", invites:[], groups:[], bets:[]),
                                                                       User(name: "Bob", age:19, phoneNumber:"8972347283", screenTime: "1h 56m", email: "bob@gmail.com", invites:[], groups:[], bets:[]),
                                                                       User(name: "Steve", age:20, phoneNumber:"2987473292", screenTime: "4h 10m", email: "steve@gmail.com", invites:[], groups:[], bets:[])],
                                                        stakes: "Loser does the dishes",
                                                        startDate: Date().addingTimeInterval(-5),
                                                        endDate: Date().addingTimeInterval(-1))])]

     var body: some View {
         CreateBetView(groupPages: $groupPages)
     }
}

struct BetViewModel_Preview: PreviewProvider {
    static var previews: some View {
        CreateBetViewPreviewContainer()
    }
}
