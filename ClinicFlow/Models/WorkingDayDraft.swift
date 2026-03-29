//
//  WorkingDayDraft.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 30/03/2026.
//


import Foundation

struct WorkingDayDraft: Identifiable, Hashable {
    let id: UUID
    let dayName: String
    var isEnabled: Bool
    var startTime: String
    var endTime: String

    init(
        id: UUID = UUID(),
        dayName: String,
        isEnabled: Bool = false,
        startTime: String = "09:00 AM",
        endTime: String = "05:00 PM"
    ) {
        self.id = id
        self.dayName = dayName
        self.isEnabled = isEnabled
        self.startTime = startTime
        self.endTime = endTime
    }
}