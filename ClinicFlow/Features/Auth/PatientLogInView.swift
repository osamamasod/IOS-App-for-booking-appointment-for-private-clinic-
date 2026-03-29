//
//  PatientLogInView.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 29/03/2026.
//


import SwiftUI

struct PatientLogInView: View {

    @StateObject private var vm = PatientLogInViewModel()
    @Environment(\.dismiss) private var dismiss

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

                    Circle()
                        .fill(Color.clear)
                        .frame(width: 40, height: 40)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {

                        VStack(spacing: 8) {
                            Text("Welcome Back")
                                .font(.system(size: 30, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.white, AppColors.primaryLight],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )

                            Text("Log in to access your ClinicFlow account")
                                .font(.system(size: 15, weight: .regular, design: .rounded))
                                .foregroundColor(AppColors.textMuted)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.top, 40)
                        .padding(.bottom, 32)

                        VStack(spacing: 16) {

                            SignUpField(
                                icon: "envelope.fill",
                                placeholder: "Email address",
                                text: $vm.email,
                                error: vm.emailError,
                                keyboardType: .emailAddress
                            )

                            SecureSignUpField(
                                icon: "lock.fill",
                                placeholder: "Password",
                                text: $vm.password,
                                isVisible: $vm.isPasswordVisible,
                                error: vm.passwordError
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
                        vm.submitLogIn()
                    }) {
                        HStack(spacing: 10) {
                            if vm.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                            Text(vm.isLoading ? "Logging In..." : "Log In")
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(vm.isLoading)

                    HStack(spacing: 4) {
                        Text("Don’t have an account?")
                            .font(.system(size: 14, design: .rounded))
                            .foregroundColor(AppColors.textMuted)

                        NavigationLink(destination: PatientSignUpView()) {
                            Text("Sign Up")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(AppColors.primaryLight)
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
    }
}

#Preview {
    NavigationStack {
        PatientLogInView()
    }
}