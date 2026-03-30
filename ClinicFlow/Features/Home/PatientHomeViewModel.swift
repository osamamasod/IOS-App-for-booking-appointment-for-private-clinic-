//
//  PatientHomeViewModel.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 31/03/2026.
//


import SwiftUI
import Combine

final class PatientHomeViewModel: ObservableObject {

    // MARK: - State
    @Published var searchText: String = ""
    @Published var selectedSpecialty: String = "All"

    // MARK: - Data
    @Published private(set) var recommendedDoctors: [Doctor] = []
    @Published private(set) var nearbyDoctors: [Doctor] = []

    let specialties: [String] = [
        "All", "General", "Cardiologist", "Dermatologist",
        "Pediatrician", "Orthopedic", "Neurologist",
        "Ophthalmologist", "Gynecologist"
    ]

    private var allDoctors: [Doctor] = Doctor.placeholders
    private var cancellables = Set<AnyCancellable>()

    init() {
        setupPipeline()
    }

    private func setupPipeline() {
        Publishers.CombineLatest($searchText, $selectedSpecialty)
            .debounce(for: .milliseconds(150), scheduler: RunLoop.main)
            .map { [weak self] search, specialty -> [Doctor] in
                guard let self else { return [] }
                return self.allDoctors.filter { doctor in
                    let matchesSpecialty = specialty == "All" || doctor.specialty == specialty
                    let matchesSearch    = search.isEmpty
                        || doctor.name.localizedCaseInsensitiveContains(search)
                        || doctor.specialty.localizedCaseInsensitiveContains(search)
                        || doctor.clinic.localizedCaseInsensitiveContains(search)
                    return matchesSpecialty && matchesSearch
                }
            }
            .sink { [weak self] filtered in
                guard let self else { return }
                self.recommendedDoctors = filtered.filter { $0.rating >= 4.7 }
                self.nearbyDoctors      = filtered.sorted { $0.distanceKm < $1.distanceKm }
            }
            .store(in: &cancellables)
    }
}