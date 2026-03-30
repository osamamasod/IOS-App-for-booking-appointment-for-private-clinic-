//
//  PatientAppointmentsViewModel.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 31/03/2026.
//


import Foundation
import Combine

final class PatientAppointmentsViewModel: ObservableObject {
    @Published var upcomingAppointments: [PatientAppointmentItem] = []
    @Published var completedAppointments: [PatientAppointmentItem] = []

    init() {
        loadPlaceholderData()
    }

    private func loadPlaceholderData() {
        upcomingAppointments = [
            PatientAppointmentItem(
                doctorName: "Dr. Sarah Ahmed",
                specialty: "Cardiologist",
                clinicName: "Heart Care Clinic",
                dateText: "12 Apr 2026",
                timeText: "10:30 AM",
                status: "Upcoming"
            )
        ]

        completedAppointments = [
            PatientAppointmentItem(
                doctorName: "Dr. Omar Khaled",
                specialty: "Dermatologist",
                clinicName: "Skin Health Center",
                dateText: "04 Apr 2026",
                timeText: "02:00 PM",
                status: "Completed"
            ),
            PatientAppointmentItem(
                doctorName: "Dr. Lina Mostafa",
                specialty: "Dentist",
                clinicName: "Bright Smile Clinic",
                dateText: "28 Mar 2026",
                timeText: "11:00 AM",
                status: "Completed"
            )
        ]
    }
}
