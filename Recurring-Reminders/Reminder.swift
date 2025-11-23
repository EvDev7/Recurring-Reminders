//
//  Item.swift
//  Recurring-Reminders
//
//  Created by Evan Rinehart on 10/29/25.
//

import Foundation
import SwiftData

@Model
final class Reminder { // final means no subclasses can be made from this.
    var title: String
    var rules: [Rule] = []
    var notes: String = ""
    
    init(title: String) {
        self.title = title
    }
}

// Must have @Model to allow swiftdata to use unsupported types for data, list enums or custom types
// TODO: Store times (associated data) that each rule was completed.
@Model
final class Rule {
    var type: String
    
    var startDate: Date?
    var dateInterval: Int?
    
    var startQuantity: Int?
    var intervalQuantity: Int?
    
    init(type: String) {
        guard type == "time" || type == "quantity" else {
            fatalError("Invalid rule type. Must be 'time' or 'quantity'")
        }
        self.type = type
    }
    
    convenience init(startDate: Date, interval: Int) {
        self.init(type: "time")
        self.startDate = startDate
        self.dateInterval = interval
    }
        
    convenience init(startQuantity: Int, intervalQuantity: Int) {
        self.init(type: "quantity")
        self.startQuantity = startQuantity
        self.intervalQuantity = intervalQuantity
    }
    
    // Computed properties
    var nextDueDate: Date? {
        guard type == "time",
              let start = startDate,
              let interval = dateInterval else { return nil }
        return Calendar.current.date(byAdding: .day, value: interval, to: start)
    }
    
    var nextTargetQuantity: Int? {
        guard type == "quantity",
              let start = startQuantity,
              let interval = intervalQuantity else { return nil }
        return start + interval
    }
}
