//
//  DoctorProfileViewModel.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 31/03/2026.
//


import SwiftUI
import Combine

final class DoctorProfileViewModel: ObservableObject {

    let profile: DoctorProfile

    @Published var selectedClinic: DoctorClinic
    @Published var selectedService: DoctorService?
    @Published var selectedSlot: ScheduleSlot?
    @Published var selectedDateIndex: Int = 0

    let upcomingDates: [String]

    init(doctor: Doctor) {
        let profile = DoctorProfile.placeholder(for: doctor)
        self.profile         = profile
        self.selectedClinic  = profile.clinics[0]
        self.upcomingDates   = Self.buildDates()
    }

    var currentSlots: [ScheduleSlot] {
        profile.slots[selectedClinic.id.uuidString] ?? []
    }

    var canBook: Bool {
        selectedService != nil && selectedSlot != nil
    }

    private static func buildDates() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE\nd MMM"
        return (0..<7).compactMap { offset in
            Calendar.current.date(byAdding: .day, value: offset, to: Date())
                .map { formatter.string(from: $0) }
        }
    }
}
