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
    @State private var showingAddReminder = false

    var body: some View {
        NavigationView {
            List {
                ForEach(reminders) { reminder in
                    NavigationLink {
                        // TODO: Define what information should show up here about a reminder (more detailed).
                        // Should be able to edit when you open it, but not exact format as modal form.
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
                    Button {
                        showingAddReminder = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddReminder) {
                AddReminderView()
            }
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


struct AddReminderView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    // Shared fields
    @State private var title = ""
    @State private var reminderType = "time"
    @State private var notes = ""
    
    // Time fields
    @State private var startDate = Date()
    @State private var dateInterval = 30
    @State private var timeUnit = "days"
    
    // Quantity fields
    @State private var startQuantity = 0
    @State private var intervalQuantity = 10
    @State private var quantityUnit = "uses"
    
    var body: some View {
        NavigationStack {
            // TODO: Rework form so that instead of one time and one quantity reminder, user can click "add" and add as many of each type.
            Form {
                Section("Basic Info") {
                    TextField("Title", text: $title)
                    
                    Picker("Type", selection: $reminderType) {
                        Text("Time-based").tag("time")
                        Text("Quantity-based").tag("quantity")
                        Text("Both").tag("both")
                    }
                    
                    TextField("Notes (optional)", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                if reminderType == "time" || reminderType == "both" {
                    Section("Time-based Rule") {
                        DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                        
                        HStack {
                            Text("Every")
                            TextField("Interval", value: $dateInterval, format: .number)
                                .keyboardType(.numberPad)
                                .frame(width: 60)
                            
                            Picker("Unit", selection: $timeUnit) {
                                Text("days").tag("days")
                                Text("weeks").tag("weeks")
                                Text("months").tag("months")
                                Text("years").tag("years")
                            }
                            .pickerStyle(.menu)
                        }
                    }
                }
                
                if reminderType == "quantity" || reminderType == "both" {
                    Section("Quantity-based Rule") {
                        HStack {
                            Text("Starting at")
                            TextField("Start", value: $startQuantity, format: .number)
                                .keyboardType(.numberPad)
                        }
                        
                        HStack {
                            Text("Every")
                            TextField("Interval", value: $intervalQuantity, format: .number)
                                .keyboardType(.numberPad)
                        }
                        
                        TextField("Unit (e.g., miles, pages)", text: $quantityUnit)
                    }
                }
            }
            .navigationTitle("New Reminder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveReminder()
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func saveReminder() {
        let reminder = Reminder(
            title: title
        )
        reminder.notes = notes
        
        // Add time rule if needed
        if reminderType == "time" || reminderType == "both" {
            let timeRule = Rule(startDate: startDate, interval: dateInterval)
            // You'll need to add the relationship
            reminder.rules.append(timeRule)
        }
        
        // Add quantity rule if needed
        if reminderType == "quantity" || reminderType == "both" {
            let quantityRule = Rule(startQuantity: startQuantity, intervalQuantity: intervalQuantity)
            // Store the unit somewhere in the rule
            reminder.rules.append(quantityRule)
        }
        
        modelContext.insert(reminder)
    }
}



#Preview {
    ContentView()
        .modelContainer(for: Reminder.self, inMemory: true)
}
