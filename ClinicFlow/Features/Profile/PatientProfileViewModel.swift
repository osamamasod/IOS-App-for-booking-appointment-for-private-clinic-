//
//  PatientProfileViewModel.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 31/03/2026.
//

import SwiftUI
import Combine

final class PatientProfileViewModel: ObservableObject {
    // Saved profile data
    @Published var fullName: String = "Osama Masoud"
    @Published var email: String = "osama@gmail.com"
    @Published var phoneNumber: String = "+20 100 123 4567"
    @Published var dateOfBirth: Date = PatientProfileViewModel.defaultDateOfBirth
    @Published var gender: String = "Male"

    // Edit flow state
    @Published var isEditingProfile: Bool = false
    @Published var didSignOut: Bool = false

    // Editable draft values
    @Published var editName: String = ""
    @Published var editPhoneNumber: String = ""
    @Published var editDateOfBirth: Date = PatientProfileViewModel.defaultDateOfBirth
    @Published var editGender: String = "Male"

    let genderOptions: [String] = ["Male", "Female", "Prefer not to say"]

    static var defaultDateOfBirth: Date {
        Calendar.current.date(from: DateComponents(year: 2004, month: 3, day: 12)) ?? Date()
    }

    var formattedDateOfBirth: String {
        PatientProfileViewModel.dateFormatter.string(from: dateOfBirth)
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter
    }()

    func beginEditing() {
        editName = fullName
        editPhoneNumber = phoneNumber
        editDateOfBirth = dateOfBirth
        editGender = gender
        isEditingProfile = true
    }

    func cancelEditing() {
        editName = fullName
        editPhoneNumber = phoneNumber
        editDateOfBirth = dateOfBirth
        editGender = gender
        isEditingProfile = false
    }

    func saveChanges() {
        fullName = editName.trimmingCharacters(in: .whitespacesAndNewlines)
        phoneNumber = editPhoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        dateOfBirth = editDateOfBirth
        gender = editGender
        isEditingProfile = false
    }

    func signOut() {
        didSignOut = true
    }
}
