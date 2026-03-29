//
//  ClinicDetailsView.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 30/03/2026.
//


import SwiftUI

struct ClinicDetailsView: View {
    @StateObject private var vm = ClinicDetailsViewModel()
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: Field?

    var onContinueTap: () -> Void = {}

    enum Field: Hashable {
        case clinicName
        case clinicPhone
        case clinicEmail
        case city
        case district
        case addressLine
        case description
    }

    var body: some View {
        ZStack {
            AppColors.backgroundDark.ignoresSafeArea()

            backgroundGlow

            VStack(spacing: 0) {
                header

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        introSection
                            .padding(.top, 28)

                        guidanceCard

                        basicInformationCard

                        locationCard

                        descriptionCard

                        if let generalError = vm.generalError {
                            HStack(spacing: 6) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 12))

                                Text(generalError)
                                    .font(.system(size: 13, design: .rounded))
                            }
                            .foregroundColor(AppColors.error)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        Spacer().frame(height: 120)
                    }
                    .padding(.horizontal, 24)
                }

                bottomActionSection
            }
        }
        .navigationBarHidden(true)
    }

    private var backgroundGlow: some View {
        ZStack {
            Circle()
                .fill(AppColors.primary.opacity(0.15))
                .frame(width: 300, height: 300)
                .blur(radius: 70)
                .offset(x: -80, y: -180)

            Circle()
                .fill(AppColors.accent.opacity(0.10))
                .frame(width: 240, height: 240)
                .blur(radius: 60)
                .offset(x: 120, y: 300)
        }
        .ignoresSafeArea()
    }

    private var header: some View {
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

            Text("Clinic Setup")
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(AppColors.textSecondary)

            Spacer()

            Circle()
                .fill(Color.clear)
                .frame(width: 40, height: 40)
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
    }

    private var introSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Clinic Details")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, AppColors.primaryLight],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )

            Text("Enter the main clinic information to prepare the first step of the clinic setup flow.")
                .font(.system(size: 15, weight: .regular, design: .rounded))
                .foregroundColor(AppColors.textMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var guidanceCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(AppColors.primary.opacity(0.15))
                        .frame(width: 36, height: 36)

                    Image(systemName: "building.2.crop.circle")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(AppColors.primaryLight)
                }

                Text("Clinic Information Guidance")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 8) {
                guidanceRow("Add the main clinic details clearly so the next setup steps can use them.")
                guidanceRow("Required fields are prepared with local validation for future backend integration.")
                guidanceRow("This screen is the first clinic setup step after doctor verification.")
            }
        }
        .padding(16)
        .background(cardBackground)
    }

    private var basicInformationCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("Basic Information")

            ClinicInputField(
                title: "Clinic Name",
                placeholder: "Enter clinic name",
                text: $vm.clinicName,
                error: vm.clinicNameError,
                keyboardType: .default
            )
            .focused($focusedField, equals: .clinicName)

            ClinicInputField(
                title: "Clinic Phone",
                placeholder: "Enter clinic phone number",
                text: $vm.clinicPhone,
                error: vm.clinicPhoneError,
                keyboardType: .phonePad
            )
            .focused($focusedField, equals: .clinicPhone)

            ClinicInputField(
                title: "Clinic Email (Optional)",
                placeholder: "Enter clinic email address",
                text: $vm.clinicEmail,
                error: nil,
                keyboardType: .emailAddress
            )
            .focused($focusedField, equals: .clinicEmail)
        }
        .padding(16)
        .background(cardBackground)
    }

    private var locationCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("Location")

            ClinicInputField(
                title: "City",
                placeholder: "Enter city",
                text: $vm.city,
                error: vm.cityError,
                keyboardType: .default
            )
            .focused($focusedField, equals: .city)

            ClinicInputField(
                title: "District / Area",
                placeholder: "Enter district or area",
                text: $vm.district,
                error: nil,
                keyboardType: .default
            )
            .focused($focusedField, equals: .district)

            ClinicInputField(
                title: "Address",
                placeholder: "Enter clinic address",
                text: $vm.addressLine,
                error: vm.addressError,
                keyboardType: .default
            )
            .focused($focusedField, equals: .addressLine)
        }
        .padding(16)
        .background(cardBackground)
    }

    private var descriptionCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionTitle("Clinic Description")

            VStack(alignment: .leading, spacing: 8) {
                Text("Description (Optional)")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(AppColors.textSecondary)

                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(AppColors.backgroundDark.opacity(0.35))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(AppColors.primaryLight.opacity(0.12), lineWidth: 1)
                        )

                    TextEditor(text: $vm.descriptionText)
                        .focused($focusedField, equals: .description)
                        .scrollContentBackground(.hidden)
                        .foregroundColor(.white)
                        .font(.system(size: 14, design: .rounded))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 10)
                        .frame(minHeight: 120)

                    if vm.descriptionText.isEmpty {
                        Text("Add a short description about the clinic")
                            .font(.system(size: 14, design: .rounded))
                            .foregroundColor(AppColors.textMuted)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 18)
                            .allowsHitTesting(false)
                    }
                }
            }
        }
        .padding(16)
        .background(cardBackground)
    }

    private var bottomActionSection: some View {
        VStack(spacing: 14) {
            Button(action: {
                hideKeyboard()
                vm.continueToNextStep {
                    onContinueTap()
                }
            }) {
                HStack(spacing: 10) {
                    if vm.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    }

                    Text(vm.isLoading ? "Preparing..." : "Continue")
                }
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(vm.isLoading)

            Text("This screen currently prepares the frontend structure for future backend submission and validation.")
                .font(.system(size: 12, design: .rounded))
                .foregroundColor(AppColors.textMuted)
                .multilineTextAlignment(.center)
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

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 16, weight: .semibold, design: .rounded))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func guidanceRow(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Circle()
                .fill(AppColors.primaryLight)
                .frame(width: 6, height: 6)
                .padding(.top, 6)

            Text(text)
                .font(.system(size: 13, weight: .regular, design: .rounded))
                .foregroundColor(AppColors.textSecondary)
        }
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 18, style: .continuous)
            .fill(AppColors.backgroundCard)
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(AppColors.primaryLight.opacity(0.12), lineWidth: 1)
            )
    }

    private func hideKeyboard() {
        focusedField = nil
    }
}

private struct ClinicInputField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let error: String?
    let keyboardType: UIKeyboardType

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(AppColors.textSecondary)

            TextField("", text: $text, prompt: Text(placeholder).foregroundColor(AppColors.textMuted))
                .keyboardType(keyboardType)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled(true)
                .foregroundColor(.white)
                .font(.system(size: 14, design: .rounded))
                .padding(.horizontal, 14)
                .frame(height: 52)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(AppColors.backgroundDark.opacity(0.35))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(
                                    error != nil ? AppColors.error.opacity(0.6) : AppColors.primaryLight.opacity(0.12),
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
            }
        }
    }
}

#Preview {
    NavigationStack {
        ClinicDetailsView()
    }
}