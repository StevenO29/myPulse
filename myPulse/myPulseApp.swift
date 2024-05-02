//
//  myPulseApp.swift
//  myPulse
//
//  Created by Steven Ongkowidjojo on 25/04/24.
//

import SwiftUI
import SwiftData
import BackgroundTasks

@main
struct myPulseApp: App {
    @StateObject var manager = healthData()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            mainMenu()
        }
        .modelContainer(sharedModelContainer)
        .environmentObject(manager)
    }
}
