//
//  DoctorClinic.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 31/03/2026.
//


import Foundation

struct DoctorClinic: Identifiable, Hashable {
    let id: UUID
    let name: String
    let address: String
    let distanceKm: Double
    let phone: String
}

struct DoctorService: Identifiable, Hashable {
    let id: UUID
    let name: String
    let durationMinutes: Int
    let price: Int
    let description: String
}

struct ScheduleSlot: Identifiable, Hashable {
    let id: UUID
    let time: String
    let isAvailable: Bool
}

struct DoctorProfile: Identifiable {
    let id: UUID
    let doctor: Doctor
    let age: Int
    let gender: String
    let bio: String
    let experience: Int
    let patientsCount: Int
    let clinics: [DoctorClinic]
    let services: [DoctorService]
    let slots: [String: [ScheduleSlot]]   // keyed by clinic id string

    // MARK: - Placeholder
    static func placeholder(for doctor: Doctor) -> DoctorProfile {
        let clinic1 = DoctorClinic(
            id: UUID(),
            name: doctor.clinic,
            address: "12 Medical Ave, Downtown",
            distanceKm: doctor.distanceKm,
            phone: "+1 (555) 010-2030"
        )
        let clinic2 = DoctorClinic(
            id: UUID(),
            name: "City Health Annex",
            address: "88 Wellness Blvd, Midtown",
            distanceKm: doctor.distanceKm + 1.4,
            phone: "+1 (555) 040-5060"
        )

        let services: [DoctorService] = [
            DoctorService(id: UUID(), name: "Initial Consultation",  durationMinutes: 30, price: doctor.consultationFee,       description: "Full assessment and diagnosis plan."),
            DoctorService(id: UUID(), name: "Follow-up Visit",       durationMinutes: 20, price: Int(Double(doctor.consultationFee) * 0.6), description: "Progress review and treatment update."),
            DoctorService(id: UUID(), name: "Specialist Report",     durationMinutes: 45, price: Int(Double(doctor.consultationFee) * 1.4), description: "Detailed specialist report for referrals."),
            DoctorService(id: UUID(), name: "Online Consultation",   durationMinutes: 20, price: Int(Double(doctor.consultationFee) * 0.5), description: "Video call consultation from anywhere."),
        ]

        func makeSlots(_ times: [String]) -> [ScheduleSlot] {
            times.map { ScheduleSlot(id: UUID(), time: $0, isAvailable: Bool.random()) }
        }

        let slots: [String: [ScheduleSlot]] = [
            clinic1.id.uuidString: makeSlots(["09:00", "09:30", "10:00", "10:30", "11:00", "14:00", "14:30", "15:00", "16:00", "16:30"]),
            clinic2.id.uuidString: makeSlots(["08:30", "09:00", "11:30", "12:00", "13:00", "15:30", "17:00", "17:30"]),
        ]

        return DoctorProfile(
            id: UUID(),
            doctor: doctor,
            age: Int.random(in: 32...58),
            gender: ["Male", "Female"].randomElement()!,
            bio: "Dr. \(doctor.name.components(separatedBy: " ").last ?? "") is a board-certified \(doctor.specialty.lowercased()) with \(Int.random(in: 8...22)) years of experience. Known for a patient-centred approach and evidence-based treatments, they have helped thousands of patients achieve better health outcomes.",
            experience: Int.random(in: 8...22),
            patientsCount: doctor.reviewCount * Int.random(in: 3...6),
            clinics: [clinic1, clinic2],
            services: services,
            slots: slots
        )
    }
}