//
//  PatientProfileView.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 31/03/2026.
//


//
//  PatientProfileView.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 31/03/2026.
//

import SwiftUI

struct PatientProfileView: View {
    @StateObject private var vm = PatientProfileViewModel()
    @State private var showSignOutAlert = false

    var body: some View {
        ZStack {
            AppColors.backgroundDark.ignoresSafeArea()

            // Ambient background
            ZStack {
                Circle()
                    .fill(AppColors.primary.opacity(0.12))
                    .frame(width: 320, height: 320)
                    .blur(radius: 80)
                    .offset(x: 120, y: -180)

                Circle()
                    .fill(AppColors.accent.opacity(0.08))
                    .frame(width: 260, height: 260)
                    .blur(radius: 70)
                    .offset(x: -100, y: 320)
            }
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    headerSection
                        .padding(.horizontal, 24)
                        .padding(.top, 16)

                    profileHeaderCard
                        .padding(.horizontal, 24)
                        .padding(.top, 24)

                    personalInformationSection
                        .padding(.horizontal, 24)
                        .padding(.top, 24)

                    actionButtons
                        .padding(.horizontal, 24)
                        .padding(.top, 24)

                    Spacer().frame(height: 100)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $vm.isEditingProfile) {
            EditProfilePlaceholderView()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .alert("Sign Out", isPresented: $showSignOutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Sign Out", role: .destructive) {
                vm.signOut()
            }
        } message: {
            Text("Are you sure you want to sign out?")
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Account")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(AppColors.textMuted)

                Text("Patient Profile")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, AppColors.primaryLight],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }

            Spacer()

            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(AppColors.backgroundCard)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .stroke(AppColors.primaryLight.opacity(0.15), lineWidth: 1)
                    )

                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 18))
                    .foregroundColor(AppColors.primaryLight)
            }
            .frame(width: 46, height: 46)
        }
    }

    // MARK: - Profile Header Card
    private var profileHeaderCard: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(AppColors.primaryGlow)
                    .frame(width: 94, height: 94)

                Image(systemName: "person.fill")
                    .font(.system(size: 34))
                    .foregroundColor(AppColors.primaryLight)
            }

            VStack(spacing: 6) {
                Text(vm.fullName)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                Text(vm.email)
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(AppColors.textMuted)
                    .multilineTextAlignment(.center)
            }

            Button(action: {
                vm.isEditingProfile = true
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 14, weight: .semibold))

                    Text("Edit Profile")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryDark],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(AppColors.backgroundCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(AppColors.primaryLight.opacity(0.12), lineWidth: 1)
                )
        )
    }

    // MARK: - Personal Information Section
    private var personalInformationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Personal Information")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.white)

            VStack(spacing: 12) {
                ProfileInfoRow(
                    icon: "person.text.rectangle",
                    title: "Full Name",
                    value: vm.fullName
                )

                ProfileInfoRow(
                    icon: "phone.fill",
                    title: "Phone",
                    value: vm.phoneNumber
                )

                ProfileInfoRow(
                    icon: "calendar",
                    title: "Date of Birth",
                    value: vm.dateOfBirth
                )

                ProfileInfoRow(
                    icon: "figure.stand",
                    title: "Gender",
                    value: vm.gender
                )
            }
        }
    }

    // MARK: - Actions
    private var actionButtons: some View {
        VStack(spacing: 14) {
            Button(action: {
                vm.isEditingProfile = true
            }) {
                HStack {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 15, weight: .semibold))

                    Text("Edit Personal Information")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                }
                .foregroundColor(.white)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(AppColors.backgroundCard)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(AppColors.primaryLight.opacity(0.12), lineWidth: 1)
                        )
                )
            }

            Button(action: {
                showSignOutAlert = true
            }) {
                HStack {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.system(size: 15, weight: .semibold))

                    Text("Sign Out")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))

                    Spacer()
                }
                .foregroundColor(AppColors.error)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(AppColors.backgroundCard)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(AppColors.error.opacity(0.25), lineWidth: 1)
                        )
                )
            }

            if vm.didSignOut {
                Text("Signed out locally")
                    .font(.system(size: 13, design: .rounded))
                    .foregroundColor(AppColors.textMuted)
                    .padding(.top, 4)
            }
        }
    }
}

// MARK: - Info Row
struct ProfileInfoRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(AppColors.primaryGlow)

                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(AppColors.primaryLight)
            }
            .frame(width: 44, height: 44)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(AppColors.textMuted)

                Text(value)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
            }

            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(AppColors.backgroundCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(AppColors.primaryLight.opacity(0.12), lineWidth: 1)
                )
        )
    }
}

// MARK: - Edit Profile Placeholder
struct EditProfilePlaceholderView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            AppColors.backgroundDark.ignoresSafeArea()

            VStack(spacing: 18) {
                ZStack {
                    Circle()
                        .fill(AppColors.primaryGlow)
                        .frame(width: 84, height: 84)

                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 28))
                        .foregroundColor(AppColors.primaryLight)
                }

                Text("Edit Profile")
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                Text("This is the local entry point to the future edit profile flow.")
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(AppColors.textMuted)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)

                Button(action: {
                    dismiss()
                }) {
                    Text("Close")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(
                                colors: [AppColors.primary, AppColors.primaryDark],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
            }
            .padding(.vertical, 32)
        }
    }
}

#Preview {
    NavigationStack {
        PatientProfileView()
    }
}