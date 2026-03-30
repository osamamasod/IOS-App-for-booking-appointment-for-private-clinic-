//
//  PatientAppointmentItem.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 31/03/2026.
//


import Foundation

struct PatientAppointmentItem: Identifiable, Hashable {
    let id = UUID()
    let doctorName: String
    let specialty: String
    let clinicName: String
    let dateText: String
    let timeText: String
    let status: String
}