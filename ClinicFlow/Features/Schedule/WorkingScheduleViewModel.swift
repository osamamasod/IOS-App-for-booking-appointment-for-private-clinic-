//
//  WorkingScheduleViewModel.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 30/03/2026.
//


import SwiftUI
import Combine

final class WorkingScheduleViewModel: ObservableObject {
    @Published var days: [WorkingDayDraft] = [
        WorkingDayDraft(dayName: "Monday", isEnabled: true),
        WorkingDayDraft(dayName: "Tuesday", isEnabled: true),
        WorkingDayDraft(dayName: "Wednesday", isEnabled: true),
        WorkingDayDraft(dayName: "Thursday", isEnabled: true),
        WorkingDayDraft(dayName: "Friday", isEnabled: true),
        WorkingDayDraft(dayName: "Saturday", isEnabled: false),
        WorkingDayDraft(dayName: "Sunday", isEnabled: false)
    ]

    @Published var generalError: String? = nil
    @Published var isLoading: Bool = false

    let timeOptions: [String] = [
        "08:00 AM", "09:00 AM", "10:00 AM", "11:00 AM",
        "12:00 PM", "01:00 PM", "02:00 PM", "03:00 PM",
        "04:00 PM", "05:00 PM", "06:00 PM", "07:00 PM",
        "08:00 PM", "09:00 PM"
    ]

    func timeError(for day: WorkingDayDraft) -> String? {
        guard day.isEnabled else { return nil }

        guard
            let startIndex = timeOptions.firstIndex(of: day.startTime),
            let endIndex = timeOptions.firstIndex(of: day.endTime)
        else {
            return "Select valid working hours."
        }

        return startIndex < endIndex ? nil : "End time must be after start time."
    }

    var hasAtLeastOneWorkingDay: Bool {
        days.contains(where: { $0.isEnabled })
    }

    var isFormValid: Bool {
        hasAtLeastOneWorkingDay && days.allSatisfy { timeError(for: $0) == nil }
    }

    func continueToNextStep(onSuccess: @escaping () -> Void) {
        generalError = nil

        guard hasAtLeastOneWorkingDay else {
            generalError = "Please enable at least one working day before continuing."
            return
        }

        guard isFormValid else {
            generalError = "Please review the working schedule and correct the highlighted time selections."
            return
        }

        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
            self?.isLoading = false
            onSuccess()
        }
    }
}
