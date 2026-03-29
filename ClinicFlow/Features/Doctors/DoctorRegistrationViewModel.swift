//
//  DoctorRegistrationViewModel.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 30/03/2026.
//


import SwiftUI
import Combine

final class DoctorRegistrationViewModel: ObservableObject {

    @Published var fullName: String = ""
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var specialty: String = ""
    @Published var licenseNumber: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""

    @Published var isPasswordVisible: Bool = false
    @Published var isConfirmPasswordVisible: Bool = false

    @Published var fullNameError: String?
    @Published var emailError: String?
    @Published var phoneError: String?
    @Published var specialtyError: String?
    @Published var licenseNumberError: String?
    @Published var passwordError: String?
    @Published var confirmPasswordError: String?
    @Published var generalError: String?

    @Published var isLoading: Bool = false

    func validateForm() -> Bool {
        fullNameError = nil
        emailError = nil
        phoneError = nil
        specialtyError = nil
        licenseNumberError = nil
        passwordError = nil
        confirmPasswordError = nil
        generalError = nil

        let trimmedFullName = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPhone = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedSpecialty = specialty.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedLicense = licenseNumber.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedFullName.isEmpty {
            fullNameError = "Full name is required"
        }

        if trimmedEmail.isEmpty {
            emailError = "Email is required"
        } else if !isValidEmail(trimmedEmail) {
            emailError = "Enter a valid email"
        }

        if trimmedPhone.isEmpty {
            phoneError = "Phone number is required"
        }

        if trimmedSpecialty.isEmpty {
            specialtyError = "Specialty is required"
        }

        if trimmedLicense.isEmpty {
            licenseNumberError = "License number is required"
        }

        if password.isEmpty {
            passwordError = "Password is required"
        } else if password.count < 6 {
            passwordError = "Password must be at least 6 characters"
        }

        if confirmPassword.isEmpty {
            confirmPasswordError = "Confirm your password"
        } else if confirmPassword != password {
            confirmPasswordError = "Passwords do not match"
        }

        let isValid =
            fullNameError == nil &&
            emailError == nil &&
            phoneError == nil &&
            specialtyError == nil &&
            licenseNumberError == nil &&
            passwordError == nil &&
            confirmPasswordError == nil

        if !isValid {
            generalError = "Please complete the required fields correctly."
        }

        return isValid
    }
    func continueToNextStep(onSuccess: @escaping () -> Void) {
        guard validateForm() else { return }

        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.isLoading = false
            onSuccess()
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
}
