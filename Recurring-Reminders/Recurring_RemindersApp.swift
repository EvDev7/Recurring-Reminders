//
//  Recurring_RemindersApp.swift
//  Recurring-Reminders
//
//  Created by Evan Rinehart on 10/29/25.
//

import SwiftUI
import SwiftData

@main
struct Recurring_RemindersApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Reminder.self,
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
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
