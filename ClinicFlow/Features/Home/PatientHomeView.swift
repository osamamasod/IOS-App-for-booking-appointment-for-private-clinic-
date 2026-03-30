//
//  PatientHomeView.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 31/03/2026.
//


import SwiftUI

struct PatientHomeView: View {
    @StateObject private var vm = PatientHomeViewModel()

    var body: some View {
        ZStack {
            AppColors.backgroundDark.ignoresSafeArea()

            // Ambient blobs
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

                    // MARK: Header
                    headerSection

                    // MARK: Search bar
                    searchBar
                        .padding(.horizontal, 24)
                        .padding(.top, 20)

                    // MARK: Specialty chips
                    specialtyChips
                        .padding(.top, 20)

                    // MARK: Recommended
                    if !vm.recommendedDoctors.isEmpty {
                        sectionHeader(title: "Recommended", subtitle: "Top rated doctors")
                            .padding(.top, 28)

                        recommendedScroll
                            .padding(.top, 14)
                    }

                    // MARK: Nearby
                    if !vm.nearbyDoctors.isEmpty {
                        sectionHeader(title: "Nearby Doctors", subtitle: "Close to your location")
                            .padding(.top, 28)

                        nearbyList
                            .padding(.top, 14)
                            .padding(.horizontal, 24)
                    }

                    // Empty state
                    if vm.recommendedDoctors.isEmpty && vm.nearbyDoctors.isEmpty {
                        emptyState
                            .padding(.top, 60)
                    }

                    Spacer().frame(height: 100)
                }
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Header
    private var headerSection: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Good morning 👋")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(AppColors.textMuted)
                Text("Find Your Doctor")
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

            // Notification bell
            Button(action: {}) {
                ZStack(alignment: .topTrailing) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(AppColors.backgroundCard)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(AppColors.primaryLight.opacity(0.15), lineWidth: 1)
                            )
                        Image(systemName: "bell.fill")
                            .font(.system(size: 16))
                            .foregroundColor(AppColors.primaryLight)
                    }
                    .frame(width: 46, height: 46)

                    Circle()
                        .fill(AppColors.error)
                        .frame(width: 10, height: 10)
                        .offset(x: 2, y: -2)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
    }

    // MARK: - Search Bar
    // Replace the searchBar var in PatientHomeView with this:
    private var searchBar: some View {
        NavigationLink(destination: DoctorSearchView()) {
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.textMuted)
                Text("Search doctors, specialties...")
                    .font(.system(size: 15, design: .rounded))
                    .foregroundColor(AppColors.textMuted)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(AppColors.backgroundCard)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(AppColors.primaryLight.opacity(0.15), lineWidth: 1)
                    )
            )
        }
    }
    // MARK: - Specialty Chips
    private var specialtyChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(vm.specialties, id: \.self) { specialty in
                    SpecialtyChip(
                        title: specialty,
                        isSelected: vm.selectedSpecialty == specialty,
                        onTap: { vm.selectedSpecialty = specialty }
                    )
                }
            }
            .padding(.horizontal, 24)
        }
    }

    // MARK: - Section Header
    private func sectionHeader(title: String, subtitle: String) -> some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundColor(AppColors.textMuted)
            }
            Spacer()
            Button(action: {}) {
                Text("See all")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(AppColors.primaryLight)
            }
        }
        .padding(.horizontal, 24)
    }

    // MARK: - Recommended Horizontal Scroll
    private var recommendedScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(vm.recommendedDoctors) { doctor in
                    RecommendedDoctorCard(doctor: doctor)
                }
            }
            .padding(.horizontal, 24)
        }
    }

    // MARK: - Nearby Vertical List
    private var nearbyList: some View {
        VStack(spacing: 12) {
            ForEach(vm.nearbyDoctors) { doctor in
                NearbyDoctorCard(doctor: doctor)
            }
        }
    }

    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 44))
                .foregroundColor(AppColors.primaryLight.opacity(0.4))
            Text("No doctors found")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(AppColors.textSecondary)
            Text("Try a different search or specialty filter")
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(AppColors.textMuted)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 40)
    }
}

// MARK: - Specialty Chip
struct SpecialtyChip: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(.system(size: 13, weight: isSelected ? .semibold : .regular, design: .rounded))
                .foregroundColor(isSelected ? .white : AppColors.textSecondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    ZStack {
                        if isSelected {
                            LinearGradient(
                                colors: [AppColors.primary, Color(hex: "#A855F7")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        } else {
                            AppColors.backgroundCard
                        }
                    }
                )
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(
                            isSelected ? Color.clear : AppColors.primaryLight.opacity(0.2),
                            lineWidth: 1
                        )
                )
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Recommended Doctor Card (horizontal)
struct RecommendedDoctorCard: View {
    let doctor: Doctor

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Avatar + availability badge
            ZStack(alignment: .topTrailing) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(AppColors.primaryGlow)
                    Image(systemName: doctor.imageName)
                        .font(.system(size: 48))
                        .foregroundColor(AppColors.primaryLight)
                }
                .frame(height: 110)

                if doctor.isAvailableToday {
                    Text("Available")
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(AppColors.success)
                        .clipShape(Capsule())
                        .padding(8)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(doctor.name)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(1)

                Text(doctor.specialty)
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(AppColors.primaryLight)

                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 10))
                        .foregroundColor(AppColors.warning)
                    Text("\(doctor.rating, specifier: "%.1f")")
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                    Text("(\(doctor.reviewCount))")
                        .font(.system(size: 11, design: .rounded))
                        .foregroundColor(AppColors.textMuted)
                }
                .padding(.top, 2)

                Text("$\(doctor.consultationFee)")
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundColor(AppColors.primaryLight)
                    .padding(.top, 4)
            }
            .padding(12)
        }
        .frame(width: 160)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(AppColors.backgroundCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(AppColors.primaryLight.opacity(0.12), lineWidth: 1)
                )
        )
    }
}

// MARK: - Nearby Doctor Card (vertical)
struct NearbyDoctorCard: View {
    let doctor: Doctor

    var body: some View {
        HStack(spacing: 14) {

            // Avatar
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(AppColors.primaryGlow)
                Image(systemName: doctor.imageName)
                    .font(.system(size: 28))
                    .foregroundColor(AppColors.primaryLight)
            }
            .frame(width: 64, height: 64)

            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(doctor.name)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(1)

                Text(doctor.specialty)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundColor(AppColors.primaryLight)

                HStack(spacing: 10) {
                    HStack(spacing: 3) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundColor(AppColors.warning)
                        Text("\(doctor.rating, specifier: "%.1f")")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(.white)
                    }

                    HStack(spacing: 3) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 10))
                            .foregroundColor(AppColors.textMuted)
                        Text("\(doctor.distanceKm, specifier: "%.1f") km")
                            .font(.system(size: 12, design: .rounded))
                            .foregroundColor(AppColors.textMuted)
                    }
                }
            }

            Spacer()

            // Right side
            VStack(alignment: .trailing, spacing: 8) {
                if doctor.isAvailableToday {
                    Text("Today")
                        .font(.system(size: 10, weight: .semibold, design: .rounded))
                        .foregroundColor(AppColors.success)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(AppColors.success.opacity(0.15))
                        .clipShape(Capsule())
                }

                Text("$\(doctor.consultationFee)")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
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

// MARK: - Preview
#Preview {
    PatientHomeView()
}
