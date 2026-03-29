//
//  ClinicDetailsViewModel.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 30/03/2026.
//


import SwiftUI
import Combine

final class ClinicDetailsViewModel: ObservableObject {
    @Published var clinicName: String = ""
    @Published var clinicPhone: String = ""
    @Published var clinicEmail: String = ""
    @Published var city: String = ""
    @Published var district: String = ""
    @Published var addressLine: String = ""
    @Published var descriptionText: String = ""

    @Published var generalError: String? = nil
    @Published var isLoading: Bool = false

    var clinicNameError: String? {
        clinicName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        ? "Clinic name is required."
        : nil
    }

    var clinicPhoneError: String? {
        clinicPhone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        ? "Clinic phone is required."
        : nil
    }

    var cityError: String? {
        city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        ? "City is required."
        : nil
    }

    var addressError: String? {
        addressLine.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        ? "Clinic address is required."
        : nil
    }

    var isFormValid: Bool {
        clinicNameError == nil &&
        clinicPhoneError == nil &&
        cityError == nil &&
        addressError == nil
    }

    func continueToNextStep(onSuccess: @escaping () -> Void) {
        generalError = nil

        guard isFormValid else {
            generalError = "Please complete the required clinic information before continuing."
            return
        }

        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
            self?.isLoading = false
            onSuccess()
        }
    }
}
