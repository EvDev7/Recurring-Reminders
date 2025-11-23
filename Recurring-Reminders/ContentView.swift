//
//  ContentView.swift
//  Recurring-Reminders
//
//  Created by Evan Rinehart on 10/29/25.
//

// Group notes together or provide a tagging system. A task can have many tasks.
// Store lots of information about the task. Pictures, links, notes? Anything.

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var reminders: [Reminder]

    var body: some View {
        NavigationView {
            List {
                ForEach(reminders) { reminder in
                    NavigationLink {
                        // TODO: Define what information should show up here about a reminder (more detailed).
                        Text("Need to add stuff here")
                    } label: {
                        // TODO: Define what information should show up here about a reminder (at a glance).
                        // Probably good to display the name of the task and when it needs to be completed next.
                        Text(reminder.title)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton() // default SwiftUI behavior for List
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            // TODO: Create a view or something with input fields for new reminders. CURRENTLY HARCODED
            let newItem = Reminder(title: "TEST")
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(reminders[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Reminder.self, inMemory: true)
}
