//
//  DoctorSearchViewModel.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 31/03/2026.
//


import SwiftUI
import Combine

final class DoctorSearchViewModel: ObservableObject {

    // MARK: - Filter State
    @Published var searchText: String       = ""
    @Published var selectedSpecialty: String = "All"
    @Published var maxDistanceKm: Double    = 10.0
    @Published var priceRange: ClosedRange<Double> = 0...200
    @Published var selectedAvailability: AvailabilityFilter = .any
    @Published var minPrice: Double         = 0
    @Published var maxPrice: Double         = 200

    // MARK: - Results
    @Published private(set) var results: [Doctor] = []
    @Published var isFiltersExpanded: Bool  = false

    private var allDoctors: [Doctor]        = Doctor.placeholders
    private var cancellables                = Set<AnyCancellable>()

    let specialties: [String] = [
        "All", "General", "Cardiologist", "Dermatologist",
        "Pediatrician", "Orthopedic", "Neurologist",
        "Ophthalmologist", "Gynecologist"
    ]

    enum AvailabilityFilter: String, CaseIterable {
        case any         = "Any"
        case todayOnly   = "Today"
    }

    // MARK: - Active filter count (for badge)
    var activeFilterCount: Int {
        var count = 0
        if selectedSpecialty != "All"       { count += 1 }
        if maxDistanceKm < 10.0             { count += 1 }
        if minPrice > 0 || maxPrice < 200   { count += 1 }
        if selectedAvailability != .any     { count += 1 }
        return count
    }

    init() {
        setupPipeline()
    }

    private func setupPipeline() {
        Publishers.CombineLatest4(
            $searchText.debounce(for: .milliseconds(200), scheduler: RunLoop.main),
            $selectedSpecialty,
            $maxDistanceKm,
            $selectedAvailability
        )
        .combineLatest($minPrice, $maxPrice)
        .map { [weak self] combined, minP, maxP -> [Doctor] in
            guard let self else { return [] }
            let (search, specialty, maxDist, availability) = combined
            return self.allDoctors.filter { doctor in
                let matchesSearch    = search.isEmpty
                    || doctor.name.localizedCaseInsensitiveContains(search)
                    || doctor.specialty.localizedCaseInsensitiveContains(search)
                    || doctor.clinic.localizedCaseInsensitiveContains(search)
                let matchesSpecialty = specialty == "All" || doctor.specialty == specialty
                let matchesDist      = doctor.distanceKm <= maxDist
                let matchesPrice     = Double(doctor.consultationFee) >= minP
                    && Double(doctor.consultationFee) <= maxP
                let matchesAvail     = availability == .any
                    || (availability == .todayOnly && doctor.isAvailableToday)
                return matchesSearch && matchesSpecialty && matchesDist && matchesPrice && matchesAvail
            }
            .sorted { $0.rating > $1.rating }
        }
        .receive(on: RunLoop.main)
        .assign(to: \.results, on: self)
        .store(in: &cancellables)
    }

    func resetFilters() {
        selectedSpecialty    = "All"
        maxDistanceKm        = 10.0
        minPrice             = 0
        maxPrice             = 200
        selectedAvailability = .any
    }
}