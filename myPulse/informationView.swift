//
//  informationView.swift
//  myPulse
//
//  Created by Steven Ongkowidjojo on 29/04/24.
//

import SwiftUI

struct informationView: View {
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.init(red: 0.72, green: 0.93, blue: 0.27, alpha: 1)]
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Main Features")
                    .font(Font.custom("SF Pro", size: 24).weight(.bold))
                    .lineSpacing(22)
                    .foregroundColor(Color(red: 0.72, green: 0.93, blue: 0.27))
                    .offset(x: -101, y: -40)
                
                VStack(alignment: .leading, spacing: 10) {
                    BulletListItem(text: "Monitoring your latest heart rate: Your heart rate will be monitored using the Apple Watch and the latest heart rate will be displayed on the main menu")
                    BulletListItem(text: "Connects with the Health app on iOS: This app connects with the Health app on your iPhone to get data about your latest heart rate")
                    BulletListItem(text: "Measuring your normal heart rate range based on age: Your age will be used to measure what is the normal range of your heart rate based on your age")
                    BulletListItem(text: "Determining the maximum heart rate by age: Your maximum heart rate will be measured based on your age using the formula = 220 - age")
                    BulletListItem(text: "Box Breathing Guide: When your heart rate exceeds the maximum limit, the app will display box breathing guidance to help you calm down and lower your heart rate")
                }
                .padding(.top, 20)
                .padding(.horizontal, 16)
            }
            .frame(width: 393, height: 852, alignment: .leading)
            .background(Color.black)
            .navigationTitle("Information Page")
        }
    }
}

struct BulletListItem: View {
    var text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 5) {
            Image(systemName: "circle.fill")
                .resizable()
                .frame(width: 8, height: 8)
                .foregroundColor(.white)
                .offset(x: -5, y: 6)
            Text(text)
                .foregroundColor(.white)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
        }
        .offset(x:8, y: -60)
    }
}

#Preview {
    informationView()
}
