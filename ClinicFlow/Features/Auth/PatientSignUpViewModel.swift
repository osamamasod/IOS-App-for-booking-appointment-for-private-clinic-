import SwiftUI
import Combine

final class PatientSignUpViewModel: ObservableObject {

    // MARK: - Form Fields
    @Published var fullName: String        = ""
    @Published var email: String           = ""
    @Published var phone: String           = ""
    @Published var password: String        = ""
    @Published var confirmPassword: String = ""
    @Published var dateOfBirth: Date       = Calendar.current.date(byAdding: .year, value: -25, to: Date()) ?? Date()
    @Published var gender: Gender          = .notSelected
    @Published var nationality: String     = ""

    // MARK: - UI State
    @Published var currentStep: Int            = 1
    @Published var isPasswordVisible: Bool     = false
    @Published var isConfirmPasswordVisible: Bool = false
    @Published var showDatePicker: Bool        = false

    // MARK: - Validation Errors
    @Published var fullNameError: String?      = nil
    @Published var emailError: String?         = nil
    @Published var phoneError: String?         = nil
    @Published var passwordError: String?      = nil
    @Published var confirmPasswordError: String? = nil
    @Published var nationalityError: String?   = nil

    // MARK: - Navigation Callback
    var onSignUpSuccess: (() -> Void)?

    let totalSteps = 2

    // MARK: - Gender Enum
    enum Gender: String, CaseIterable {
        case notSelected = "Select gender"
        case male        = "Male"
        case female      = "Female"
        case other       = "Other"
    }

    // MARK: - Computed: formatted date
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: dateOfBirth)
    }

    // MARK: - Computed: password strength
    var passwordStrength: PasswordStrength {
        let p = password
        if p.count < 6 { return .weak }
        let hasUpper   = p.range(of: "[A-Z]",       options: .regularExpression) != nil
        let hasNumber  = p.range(of: "[0-9]",       options: .regularExpression) != nil
        let hasSpecial = p.range(of: "[^a-zA-Z0-9]", options: .regularExpression) != nil
        if p.count >= 10 && hasUpper && hasNumber && hasSpecial { return .strong }
        if p.count >= 8  && (hasUpper || hasNumber)             { return .medium }
        return .weak
    }

    enum PasswordStrength {
        case weak, medium, strong
        var label: String {
            switch self {
            case .weak:   return "Weak"
            case .medium: return "Medium"
            case .strong: return "Strong"
            }
        }
        var color: Color {
            switch self {
            case .weak:   return AppColors.error
            case .medium: return AppColors.warning
            case .strong: return AppColors.success
            }
        }
        var progress: CGFloat {
            switch self {
            case .weak:   return 0.33
            case .medium: return 0.66
            case .strong: return 1.0
            }
        }
    }

    // MARK: - Step 1 Validation
    func validateStep1() -> Bool {
        var valid = true

        fullNameError = nil
        emailError    = nil
        phoneError    = nil

        if fullName.trimmingCharacters(in: .whitespaces).count < 3 {
            fullNameError = "Please enter your full name"
            valid = false
        }

        if email.isEmpty {
            emailError = "Email is required"
            valid = false
        } else {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            if NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email) == false {
                emailError = "Please enter a valid email address"
                valid = false
            }
        }

        let phoneClean = phone.filter { $0.isNumber }
        if phoneClean.count < 7 {
            phoneError = "Please enter a valid phone number"
            valid = false
        }

        return valid
    }

    // MARK: - Step 2 Validation
    func validateStep2() -> Bool {
        var valid = true

        passwordError        = nil
        confirmPasswordError = nil
        nationalityError     = nil

        if password.count < 6 {
            passwordError = "Password must be at least 6 characters"
            valid = false
        }

        if confirmPassword != password {
            confirmPasswordError = "Passwords do not match"
            valid = false
        }

        if nationality.trimmingCharacters(in: .whitespaces).isEmpty {
            nationalityError = "Please enter your nationality"
            valid = false
        }

        return valid
    }

    // MARK: - Navigation
    func nextStep() {
        if currentStep == 1 && validateStep1() {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                currentStep = 2
            }
        }
    }

    func previousStep() {
        if currentStep > 1 {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                currentStep -= 1
            }
        }
    }

    func submitForm() {
        guard validateStep2() else { return }
        // TODO: replace with real API call
        onSignUpSuccess?()
    }
}
