//
//  ServicesAndPricingViewModel.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 30/03/2026.
//


import SwiftUI
import Combine

final class ServicesAndPricingViewModel: ObservableObject {
    @Published var services: [ClinicServiceDraft] = [
        ClinicServiceDraft()
    ]

    @Published var generalError: String? = nil
    @Published var isLoading: Bool = false

    let durationOptions: [Int] = [15, 20, 30, 45, 60, 90, 120]

    func addService() {
        services.append(ClinicServiceDraft())
    }

    func removeService(id: UUID) {
        services.removeAll { $0.id == id }

        if services.isEmpty {
            services = [ClinicServiceDraft()]
        }
    }

    func serviceNameError(for service: ClinicServiceDraft) -> String? {
        service.serviceName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        ? "Service name is required."
        : nil
    }

    func priceError(for service: ClinicServiceDraft) -> String? {
        let trimmed = service.priceText.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmed.isEmpty {
            return "Price is required."
        }

        guard let value = Double(trimmed), value > 0 else {
            return "Enter a valid price."
        }

        return nil
    }

    func isServiceValid(_ service: ClinicServiceDraft) -> Bool {
        serviceNameError(for: service) == nil &&
        priceError(for: service) == nil
    }

    var isFormValid: Bool {
        !services.isEmpty && services.allSatisfy(isServiceValid)
    }

    func continueToNextStep(onSuccess: @escaping () -> Void) {
        generalError = nil

        guard isFormValid else {
            generalError = "Please complete all required service information before continuing."
            return
        }

        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) { [weak self] in
            self?.isLoading = false
            onSuccess()
        }
    }
}
