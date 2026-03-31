//
//  SlotSelectionViewModel.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 31/03/2026.
//


import SwiftUI
import Combine

final class SlotSelectionViewModel: ObservableObject {

    // MARK: - Input (passed from DoctorProfileView)
    let doctor: Doctor
    let clinic: DoctorClinic
    let service: DoctorService

    // MARK: - State
    @Published var selectedDateIndex: Int = 0
    @Published var selectedSlot: ScheduleSlot? = nil

    // MARK: - Data
    let dates: [SlotDate]

    var canContinue: Bool { selectedSlot != nil }

    // MARK: - Init
    init(doctor: Doctor, clinic: DoctorClinic, service: DoctorService) {
        self.doctor  = doctor
        self.clinic  = clinic
        self.service = service
        self.dates   = Self.buildDates()
    }

    var currentSlots: [ScheduleSlot] {
        dates[selectedDateIndex].slots
    }

    var selectedDate: SlotDate {
        dates[selectedDateIndex]
    }

    // MARK: - Builders
    private static func buildDates() -> [SlotDate] {
        let calendar  = Calendar.current
        let dayFmt    = DateFormatter()
        let dateFmt   = DateFormatter()
        let monthFmt  = DateFormatter()
        dayFmt.dateFormat   = "EEE"
        dateFmt.dateFormat  = "d"
        monthFmt.dateFormat = "MMM yyyy"

        return (0..<14).compactMap { offset -> SlotDate? in
            guard let date = calendar.date(byAdding: .day, value: offset, to: Date()) else { return nil }
            let isWeekend = calendar.isDateInWeekend(date)
            let slotTimes: [String] = isWeekend
                ? ["10:00", "10:30", "11:00", "11:30", "12:00"]
                : ["09:00", "09:30", "10:00", "10:30", "11:00", "11:30",
                   "14:00", "14:30", "15:00", "15:30", "16:00", "16:30", "17:00"]
            let slots = slotTimes.map {
                ScheduleSlot(id: UUID(), time: $0, isAvailable: Bool.random())
            }
            return SlotDate(
                id: UUID(),
                dayShort:  dayFmt.string(from: date),
                dayNumber: dateFmt.string(from: date),
                monthYear: monthFmt.string(from: date),
                isToday:   calendar.isDateInToday(date),
                isWeekend: isWeekend,
                slots:     slots
            )
        }
    }
}

// MARK: - SlotDate model
struct SlotDate: Identifiable {
    let id: UUID
    let dayShort:  String
    let dayNumber: String
    let monthYear: String
    let isToday:   Bool
    let isWeekend: Bool
    let slots:     [ScheduleSlot]

    var availableCount: Int { slots.filter(\.isAvailable).count }
}
