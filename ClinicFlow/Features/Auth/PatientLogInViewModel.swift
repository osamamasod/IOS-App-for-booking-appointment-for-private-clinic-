//
//  PatientLogInViewModel.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 29/03/2026.
//


import SwiftUI
import Combine

final class PatientLogInViewModel: ObservableObject {

    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isPasswordVisible: Bool = false

    @Published var emailError: String?
    @Published var passwordError: String?
    @Published var generalError: String?

    @Published var isLoading: Bool = false

    func validateForm() -> Bool {
        emailError = nil
        passwordError = nil
        generalError = nil

        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedEmail.isEmpty {
            emailError = "Email is required"
        } else if !isValidEmail(trimmedEmail) {
            emailError = "Enter a valid email"
        }

        if password.isEmpty {
            passwordError = "Password is required"
        } else if password.count < 6 {
            passwordError = "Password must be at least 6 characters"
        }

        return emailError == nil && passwordError == nil
    }

    func submitLogIn() {
        guard validateForm() else { return }

        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.isLoading = false
            // Future backend login request goes here
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }
}
