//
//  DoctorRegistrationView.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 30/03/2026.
//


import SwiftUI

struct DoctorRegistrationView: View {

    @StateObject private var vm = DoctorRegistrationViewModel()
    @Environment(\.dismiss) private var dismiss

    var onContinueTap: () -> Void = {}

    var body: some View {
        ZStack {
            AppColors.backgroundDark.ignoresSafeArea()

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

                HStack {
                    Button(action: { dismiss() }) {
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

                    Text("Doctor Registration")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(AppColors.textSecondary)

                    Spacer()

                    Circle()
                        .fill(Color.clear)
                        .frame(width: 40, height: 40)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {

                        VStack(spacing: 8) {
                            Text("Create Doctor Account")
                                .font(.system(size: 30, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.white, AppColors.primaryLight],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )

                            Text("Set up your doctor account to continue the onboarding flow.")
                                .font(.system(size: 15, weight: .regular, design: .rounded))
                                .foregroundColor(AppColors.textMuted)
                                .multilineTextAlignment(.leading)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.top, 28)
                        .padding(.bottom, 32)

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

                            SignUpField(
                                icon: "stethoscope",
                                placeholder: "Specialty",
                                text: $vm.specialty,
                                error: vm.specialtyError
                            )

                            SignUpField(
                                icon: "doc.text.fill",
                                placeholder: "Medical license number",
                                text: $vm.licenseNumber,
                                error: vm.licenseNumberError
                            )

                            SecureSignUpField(
                                icon: "lock.fill",
                                placeholder: "Password",
                                text: $vm.password,
                                isVisible: $vm.isPasswordVisible,
                                error: vm.passwordError
                            )

                            SecureSignUpField(
                                icon: "lock.shield.fill",
                                placeholder: "Confirm password",
                                text: $vm.confirmPassword,
                                isVisible: $vm.isConfirmPasswordVisible,
                                error: vm.confirmPasswordError
                            )

                            if let error = vm.generalError {
                                HStack(spacing: 6) {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .font(.system(size: 12))
                                    Text(error)
                                        .font(.system(size: 13, design: .rounded))
                                }
                                .foregroundColor(AppColors.error)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.horizontal, 24)

                        Spacer().frame(height: 120)
                    }
                }

                VStack(spacing: 14) {
                    Button(action: {
                        vm.continueToNextStep {
                            onContinueTap()
                        }
                    }) {
                        HStack(spacing: 10) {
                            if vm.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }

                            Text(vm.isLoading ? "Continuing..." : "Continue")
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(vm.isLoading)
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
    }
}

#Preview {
    NavigationStack {
        DoctorRegistrationView()
    }
}