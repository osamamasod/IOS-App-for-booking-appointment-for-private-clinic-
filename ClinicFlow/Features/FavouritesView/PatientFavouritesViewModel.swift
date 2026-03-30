//
//  PatientFavouritesViewModel.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 31/03/2026.
//

import SwiftUI
import Combine

final class PatientFavouritesViewModel: ObservableObject {
    @Published var favouriteDoctors: [Doctor] = [
        Doctor(
            id: UUID(),
            name: "Dr. Sarah Ahmed",
            specialty: "Dermatologist",
            clinic: "City Care Clinic",
            rating: 4.9,
            reviewCount: 124,
            distanceKm: 1.4,
            imageName: "person.fill",
            isAvailableToday: true,
            consultationFee: 35
        ),
        Doctor(
            id: UUID(),
            name: "Dr. Omar Khaled",
            specialty: "Cardiologist",
            clinic: "Heart Center Clinic",
            rating: 4.8,
            reviewCount: 98,
            distanceKm: 2.1,
            imageName: "person.fill",
            isAvailableToday: false,
            consultationFee: 50
        ),
        Doctor(
            id: UUID(),
            name: "Dr. Lina Mostafa",
            specialty: "Pediatrician",
            clinic: "Kids Health Clinic",
            rating: 4.7,
            reviewCount: 87,
            distanceKm: 3.0,
            imageName: "person.fill",
            isAvailableToday: true,
            consultationFee: 40
        )
    ]

    func removeFromFavourites(_ doctor: Doctor) {
        favouriteDoctors.removeAll { $0.id == doctor.id }
    }
}
