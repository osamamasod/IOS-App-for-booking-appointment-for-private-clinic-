import SwiftUI

struct PatientSignUpView: View {

    // MARK: - Navigation callback (injected by RootView)
    var onSignUpSuccess: (() -> Void)?

    @StateObject private var vm = PatientSignUpViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            AppColors.backgroundDark.ignoresSafeArea()

            // Ambient blobs
            ZStack {
                Circle()
                    .fill(AppColors.primary.opacity(0.15))
                    .frame(width: 300, height: 300)
                    .blur(radius: 70)
                    .offset(x: -80, y: -180)
                Circle()
                    .fill(AppColors.accent.opacity(0.1))
                    .frame(width: 240, height: 240)
                    .blur(radius: 60)
                    .offset(x: 120, y: 300)
            }
            .ignoresSafeArea()

            VStack(spacing: 0) {

                // MARK: Header row
                HStack {
                    Button(action: {
                        if vm.currentStep == 1 { dismiss() }
                        else { vm.previousStep() }
                    }) {
                        ZStack {
                            Circle()
                                .fill(AppColors.primary.opacity(0.12))
                                .frame(width: 40, height: 40)
                            Image(systemName: "chevron.left")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(AppColors.primaryLight)
                        }
                    }

                    Spacer()

                    Text("Step \(vm.currentStep) of \(vm.totalSteps)")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(AppColors.textSecondary)

                    Spacer()

                    Circle()
                        .fill(Color.clear)
                        .frame(width: 40, height: 40)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                // MARK: Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(AppColors.primary.opacity(0.15))
                            .frame(height: 4)
                        RoundedRectangle(cornerRadius: 2)
                            .fill(LinearGradient(
                                colors: [AppColors.primary, AppColors.accent],
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                            .frame(
                                width: geo.size.width * (CGFloat(vm.currentStep) / CGFloat(vm.totalSteps)),
                                height: 4
                            )
                            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: vm.currentStep)
                    }
                }
                .frame(height: 4)
                .padding(.horizontal, 24)
                .padding(.top, 14)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {

                        // MARK: Title
                        VStack(spacing: 8) {
                            Text(vm.currentStep == 1 ? "Create Account" : "Security & Details")
                                .font(.system(size: 30, weight: .bold, design: .rounded))
                                .foregroundStyle(LinearGradient(
                                    colors: [.white, AppColors.primaryLight],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ))

                            Text(vm.currentStep == 1
                                 ? "Tell us a bit about yourself"
                                 : "Set up your password and details")
                                .font(.system(size: 15, weight: .regular, design: .rounded))
                                .foregroundColor(AppColors.textMuted)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.top, 28)
                        .padding(.bottom, 32)

                        // MARK: Step 1 fields
                        if vm.currentStep == 1 {
                            VStack(spacing: 16) {
                                SignUpField(
                                    icon: "person.fill",
                                    placeholder: "Full name",
                                    text: $vm.fullName,
                                    error: vm.fullNameError
                                )
                                SignUpField(
                                    icon: "envelope.fill",
                                    placeholder: "Email address",
                                    text: $vm.email,
                                    error: vm.emailError,
                                    keyboardType: .emailAddress
                                )
                                SignUpField(
                                    icon: "phone.fill",
                                    placeholder: "Phone number",
                                    text: $vm.phone,
                                    error: vm.phoneError,
                                    keyboardType: .phonePad
                                )

                                // Date of birth picker
                                VStack(alignment: .leading, spacing: 6) {
                                    Button(action: { vm.showDatePicker.toggle() }) {
                                        HStack(spacing: 14) {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                    .fill(AppColors.primary.opacity(0.15))
                                                    .frame(width: 36, height: 36)
                                                Image(systemName: "calendar")
                                                    .font(.system(size: 15, weight: .medium))
                                                    .foregroundColor(AppColors.primaryLight)
                                            }
                                            Text(vm.formattedDate)
                                                .font(.system(size: 15, weight: .regular, design: .rounded))
                                                .foregroundColor(.white)
                                            Spacer()
                                            Image(systemName: "chevron.down")
                                                .font(.system(size: 12, weight: .medium))
                                                .foregroundColor(AppColors.textMuted)
                                                .rotationEffect(.degrees(vm.showDatePicker ? 180 : 0))
                                                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: vm.showDatePicker)
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 14)
                                        .background(
                                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                                .fill(AppColors.backgroundCard)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                                        .stroke(AppColors.primaryLight.opacity(0.15), lineWidth: 1)
                                                )
                                        )
                                    }

                                    if vm.showDatePicker {
                                        DatePicker(
                                            "",
                                            selection: $vm.dateOfBirth,
                                            in: ...Date(),
                                            displayedComponents: .date
                                        )
                                        .datePickerStyle(.wheel)
                                        .colorScheme(.dark)
                                        .frame(maxWidth: .infinity)
                                        .transition(.opacity.combined(with: .move(edge: .top)))
                                    }
                                }

                                // Gender picker
                                Menu {
                                    ForEach(PatientSignUpViewModel.Gender.allCases, id: \.self) { g in
                                        Button(g.rawValue) { vm.gender = g }
                                    }
                                } label: {
                                    HStack(spacing: 14) {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                .fill(AppColors.primary.opacity(0.15))
                                                .frame(width: 36, height: 36)
                                            Image(systemName: "person.2.fill")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(AppColors.primaryLight)
                                        }
                                        Text(vm.gender.rawValue)
                                            .font(.system(size: 15, weight: .regular, design: .rounded))
                                            .foregroundColor(vm.gender == .notSelected ? AppColors.textMuted : .white)
                                        Spacer()
                                        Image(systemName: "chevron.up.chevron.down")
                                            .font(.system(size: 11, weight: .medium))
                                            .foregroundColor(AppColors.textMuted)
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 14)
                                    .background(
                                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                                            .fill(AppColors.backgroundCard)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                                    .stroke(AppColors.primaryLight.opacity(0.15), lineWidth: 1)
                                            )
                                    )
                                }
                            }
                            .padding(.horizontal, 24)
                            .transition(.asymmetric(
                                insertion: .move(edge: .leading).combined(with: .opacity),
                                removal:   .move(edge: .leading).combined(with: .opacity)
                            ))
                        }

                        // MARK: Step 2 fields
                        if vm.currentStep == 2 {
                            VStack(spacing: 16) {

                                VStack(alignment: .leading, spacing: 6) {
                                    SecureSignUpField(
                                        icon: "lock.fill",
                                        placeholder: "Password",
                                        text: $vm.password,
                                        isVisible: $vm.isPasswordVisible,
                                        error: vm.passwordError
                                    )
                                    if !vm.password.isEmpty {
                                        VStack(alignment: .leading, spacing: 4) {
                                            GeometryReader { geo in
                                                ZStack(alignment: .leading) {
                                                    RoundedRectangle(cornerRadius: 2)
                                                        .fill(AppColors.primary.opacity(0.15))
                                                        .frame(height: 4)
                                                    RoundedRectangle(cornerRadius: 2)
                                                        .fill(vm.passwordStrength.color)
                                                        .frame(width: geo.size.width * vm.passwordStrength.progress, height: 4)
                                                        .animation(.spring(response: 0.4), value: vm.passwordStrength.progress)
                                                }
                                            }
                                            .frame(height: 4)
                                            Text("Password strength: \(vm.passwordStrength.label)")
                                                .font(.system(size: 12, weight: .regular, design: .rounded))
                                                .foregroundColor(vm.passwordStrength.color)
                                        }
                                        .transition(.opacity)
                                    }
                                }

                                SecureSignUpField(
                                    icon: "lock.shield.fill",
                                    placeholder: "Confirm password",
                                    text: $vm.confirmPassword,
                                    isVisible: $vm.isConfirmPasswordVisible,
                                    error: vm.confirmPasswordError
                                )

                                SignUpField(
                                    icon: "globe",
                                    placeholder: "Nationality",
                                    text: $vm.nationality,
                                    error: vm.nationalityError
                                )

                                // Account summary
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Account summary")
                                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                                        .foregroundColor(AppColors.textSecondary)

                                    SummaryRow(icon: "person.fill",   label: "Name",   value: vm.fullName)
                                    SummaryRow(icon: "envelope.fill", label: "Email",  value: vm.email)
                                    SummaryRow(icon: "phone.fill",    label: "Phone",  value: vm.phone)
                                    SummaryRow(icon: "calendar",      label: "DOB",    value: vm.formattedDate)
                                    SummaryRow(icon: "person.2.fill", label: "Gender", value: vm.gender.rawValue)
                                }
                                .padding(16)
                                .background(
                                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                                        .fill(AppColors.backgroundCard)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                                .stroke(AppColors.primaryLight.opacity(0.1), lineWidth: 1)
                                        )
                                )
                            }
                            .padding(.horizontal, 24)
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal:   .move(edge: .trailing).combined(with: .opacity)
                            ))
                        }

                        Spacer().frame(height: 120)
                    }
                }

                // MARK: Bottom CTA
                VStack(spacing: 14) {
                    Button(action: {
                        if vm.currentStep == 1 { vm.nextStep() }
                        else { vm.submitForm() }
                    }) {
                        Text(vm.currentStep == 1 ? "Continue" : "Create Account")
                    }
                    .buttonStyle(PrimaryButtonStyle())

                    if vm.currentStep == 1 {
                        HStack(spacing: 4) {
                            Text("Already have an account?")
                                .font(.system(size: 14, design: .rounded))
                                .foregroundColor(AppColors.textMuted)

                            NavigationLink(destination: PatientLogInView()) {
                                Text("Sign In")
                                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    .foregroundColor(AppColors.primaryLight)
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 36)
                .padding(.top, 12)
                .background(
                    LinearGradient(
                        colors: [AppColors.backgroundDark.opacity(0), AppColors.backgroundDark],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                )
            }
        }
        .navigationBarHidden(true)
        .animation(.spring(response: 0.45, dampingFraction: 0.8), value: vm.currentStep)
        .onAppear {
            vm.onSignUpSuccess = onSignUpSuccess
        }
    }
}

// MARK: - Reusable Field Components

struct SignUpField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var error: String?
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(AppColors.primary.opacity(0.15))
                        .frame(width: 36, height: 36)
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.primaryLight)
                }
                TextField("", text: $text, prompt: Text(placeholder).foregroundColor(AppColors.textMuted))
                    .font(.system(size: 15, design: .rounded))
                    .foregroundColor(.white)
                    .keyboardType(keyboardType)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(AppColors.backgroundCard)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(
                                error != nil ? AppColors.error.opacity(0.6) : AppColors.primaryLight.opacity(0.15),
                                lineWidth: 1
                            )
                    )
            )

            if let error = error {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 11))
                    Text(error)
                        .font(.system(size: 12, design: .rounded))
                }
                .foregroundColor(AppColors.error)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: error)
    }
}

struct SecureSignUpField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    @Binding var isVisible: Bool
    var error: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(AppColors.primary.opacity(0.15))
                        .frame(width: 36, height: 36)
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.primaryLight)
                }

                if isVisible {
                    TextField("", text: $text, prompt: Text(placeholder).foregroundColor(AppColors.textMuted))
                        .font(.system(size: 15, design: .rounded))
                        .foregroundColor(.white)
                } else {
                    SecureField("", text: $text, prompt: Text(placeholder).foregroundColor(AppColors.textMuted))
                        .font(.system(size: 15, design: .rounded))
                        .foregroundColor(.white)
                }

                Button(action: { isVisible.toggle() }) {
                    Image(systemName: isVisible ? "eye.slash.fill" : "eye.fill")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.textMuted)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(AppColors.backgroundCard)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(
                                error != nil ? AppColors.error.opacity(0.6) : AppColors.primaryLight.opacity(0.15),
                                lineWidth: 1
                            )
                    )
            )

            if let error = error {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 11))
                    Text(error)
                        .font(.system(size: 12, design: .rounded))
                }
                .foregroundColor(AppColors.error)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: error)
    }
}

struct SummaryRow: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(AppColors.primaryLight)
                .frame(width: 16)
            Text(label)
                .font(.system(size: 13, design: .rounded))
                .foregroundColor(AppColors.textSecondary)
            Spacer()
            Text(value.isEmpty ? "—" : value)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(1)
        }
    }
}

// MARK: - Preview
#Preview {
    PatientSignUpView(onSignUpSuccess: nil)
}
