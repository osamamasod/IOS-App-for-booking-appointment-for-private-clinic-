//
//  DoctorVerificationDocumentsViewModel.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 30/03/2026.
//


import SwiftUI
import Combine

final class DoctorVerificationDocumentsViewModel: ObservableObject {

    @Published var medicalLicenseFileName: String? = nil
    @Published var supportingDocumentFileName: String? = nil

    @Published var medicalLicenseError: String?
    @Published var generalError: String?

    @Published var isLoading: Bool = false

    var hasMedicalLicense: Bool {
        medicalLicenseFileName != nil
    }

    var hasSupportingDocument: Bool {
        supportingDocumentFileName != nil
    }

    var canContinue: Bool {
        hasMedicalLicense
    }

    func attachMedicalLicensePlaceholder() {
        medicalLicenseFileName = "medical_license.pdf"
        medicalLicenseError = nil
        generalError = nil
    }

    func removeMedicalLicense() {
        medicalLicenseFileName = nil
    }

    func attachSupportingDocumentPlaceholder() {
        supportingDocumentFileName = "supporting_document.pdf"
        generalError = nil
    }

    func removeSupportingDocument() {
        supportingDocumentFileName = nil
    }

    func validateBeforeContinue() -> Bool {
        medicalLicenseError = nil
        generalError = nil

        guard hasMedicalLicense else {
            medicalLicenseError = "Medical license is required"
            generalError = "Please attach your medical license before continuing."
            return false
        }

        return true
    }

    func continueToNextStep(onSuccess: @escaping () -> Void) {
        guard validateBeforeContinue() else { return }

        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isLoading = false
            onSuccess()
        }
    }
}
