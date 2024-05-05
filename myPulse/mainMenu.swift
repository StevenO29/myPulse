//
//  mainMenu.swift
//  myPulse
//
//  Created by Steven Ongkowidjojo on 26/04/24.
//

import SwiftUI
import BackgroundTasks
import HealthKit

struct mainMenu: View {
    @EnvironmentObject var manager: healthData
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State private var currentHeartRate: Int = 0
    @State private var userAge: Int?
    @State private var showInformation = false
    @State private var minimumRangeHeartRate: Int = 60
    @State private var maximumRangeHeartRate: Int = 100
    @State private var maximumHeartRate: Int = 220
    @State private var showAlert = false
    @State private var showTimerView = false
    
    private let healthStore = HKHealthStore()
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.init(red: 0.72, green: 0.93, blue: 0.27, alpha: 1)]
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 12) {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color(red: 145/255, green: 43/255, blue: 34/255))
                        .frame(width: 74, height: 72)
                        .shadow(color: Color.red.opacity(0.3), radius: 15, x: 0, y: 0)
                        .offset(x: 8)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Current")
                            .foregroundColor(.white)
                            .font(.system(size: 17, weight: .medium))
                            .offset(x: 60, y: 24)
                        
                        HStack(alignment: .lastTextBaseline, spacing: 2) {
                            Text("\(currentHeartRate)")
                                .foregroundColor(.white)
                                .font(.system(size: 39, weight: .light))
                            
                            Text("BPM")
                                .foregroundColor(Color(red: 235/255, green: 76/255, blue: 52/255))
                                .font(.system(size: 18, weight: .medium))
                        }
                        .offset(x: 48,y: 24)
                        
                        if currentHeartRate > maximumHeartRate {
                            Button("\(Image(systemName: "exclamationmark.triangle")) Warning!") {
                                showAlert = true
                            }
                            .font(Font.custom("SF Pro", size: 16).weight(.semibold))
                            .lineSpacing(22)
                            .foregroundColor(Color.red)
                            .offset(x: 45, y: 30)
                            .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("Maximum Heart Rate Exceeded"),
                                    message: Text("Please continue to Box Breathing"),
                                    primaryButton: .default(Text("OK"), action: {
                                        self.showTimerView = true
                                    }),
                                    secondaryButton: .cancel()
                                )
                            }
                            .fullScreenCover(isPresented: $showTimerView, content: {
                                ContentView()
                            })
                        } else {
                            Text("\(Image(systemName: "checkmark.circle")) Normal Heart Rate")
                                .font(Font.custom("SF Pro", size: 16).weight(.semibold))
                                .lineSpacing(22)
                                .foregroundColor(Color(red: 0.72, green: 0.93, blue: 0.27))
                                .offset(x: 12, y: 30)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    ZStack {
                        Rectangle()
                            .fill(Color(.gray))
                            .frame(width: 376, height: 100)
                            .cornerRadius(10)
                            .opacity(0.2)
                        
                        VStack(alignment:.leading) {
                            Text("\(Image(systemName: "heart.fill")) Normal Range")
                                .font(Font.custom("SF Pro Display", size: 20).weight(.bold))
                                .foregroundColor(Color(red: 0.72, green: 0.93, blue: 0.27))
                                .offset(x: -5,y: -10)
                            
                            Text("\(minimumRangeHeartRate) - \(maximumRangeHeartRate) BPM")
                                .font(Font.custom("SF Pro Rounded", size: 20).weight(.semibold))
                                .foregroundColor(Color.white)
                                .offset(x: -5,y: 10)
                        }
                        .offset(x: -88)
                    }
                    .offset(x: 9, y: 110)
                    
                    ZStack {
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 376, height: 100)
                            .cornerRadius(10)
                            .offset(x: 9, y: 88)
                            .opacity(0.2)
                        
                        VStack(alignment:.leading) {
                            Text("\(Image(systemName: "heart.fill")) Maximum Heart Rate")
                                .font(Font.custom("SF Pro Display", size: 20).weight(.bold))
                                .foregroundColor(Color(red: 0.72, green: 0.93, blue: 0.27))
                                .offset(x: 25,y: -10)
                            
                            Text("\(maximumHeartRate) BPM")
                                .font(Font.custom("SF Pro Rounded", size: 20).weight(.semibold))
                                .foregroundColor(Color.white)
                                .offset(x: 25,y: 10)
                        }
                        .offset(x: -79, y: 88)
                    }
                    .offset(y: 20)
                }
                .padding()
                .frame(width: 198, height: 242)
                .background(Color.black)
                .offset(x: -8, y: -48)
            }
            .frame(width: 393, height: 852)
            .navigationTitle("Latest Heart Rate")
            .navigationBarItems(trailing: Button(action : {
                showInformation.toggle()
                
            }){
                Label("Information", systemImage: "info.circle")
                    .foregroundColor(Color(red: 0.72, green: 0.93, blue: 0.27))
            })
            .background(.black)
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                // Re-fetch heart rate data when the app enters foreground
                self.fetchHeartRateData()
            }
            .onAppear {
                manager.authorizeHealthKit()
                manager.requestAuthorization()
                manager.getUserAge { age in
                    // Update user age state
                    self.userAge = age
                    self.minimumRangeHeartRate = age ?? 60 >= 5 && age ?? 60 <= 12 ? 75 : 60
                    self.maximumRangeHeartRate = age ?? 60 >= 5 && age ?? 60 <= 12 ? 118 : 100
                    self.maximumHeartRate = age != nil ? 220 - age! : 220
                }
                manager.latestHeartRate { heartRate in
                    self.currentHeartRate = heartRate
                }
                self.fetchHeartRateData()
                self.scheduleAppRefreshTask()
            }
            .sheet(isPresented: $showInformation, content: {
                informationView()
            })
        }
    }
    
    // Function to fetch heart rate data
    private func fetchHeartRateData() {
        self.manager.latestHeartRate { heartRate in
            self.currentHeartRate = heartRate
        }
    }
    
    // Function to schedule background app refresh task
    private func scheduleAppRefreshTask() {
        let request = BGAppRefreshTaskRequest(identifier: "com.example.myPulse.refresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 5) // Schedule after 30 seconds
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Unable to schedule app refresh task: \(error.localizedDescription)")
        }
    }
    
    // Function to handle background task
    func handleAppRefreshTask(task: BGAppRefreshTask) {
        // Fetch latest heart rate data
        self.fetchHeartRateData()
        task.setTaskCompleted(success: true)
    }
}

#Preview {
    mainMenu()
}
