//
//  FavouritesView.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 31/03/2026.
//

import SwiftUI

struct FavouritesView: View {
    @StateObject private var vm = PatientFavouritesViewModel()

    var body: some View {
        ZStack {
            AppColors.backgroundDark.ignoresSafeArea()

            // Background glow
            ZStack {
                Circle()
                    .fill(AppColors.primary.opacity(0.12))
                    .frame(width: 320, height: 320)
                    .blur(radius: 80)
                    .offset(x: 130, y: -190)

                Circle()
                    .fill(AppColors.accent.opacity(0.08))
                    .frame(width: 260, height: 260)
                    .blur(radius: 70)
                    .offset(x: -100, y: 340)
            }
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    headerSection
                        .padding(.horizontal, 24)
                        .padding(.top, 16)

                    if vm.favouriteDoctors.isEmpty {
                        emptyState
                            .padding(.top, 80)
                            .padding(.horizontal, 32)
                    } else {
                        favouritesInfoCard
                            .padding(.horizontal, 24)
                            .padding(.top, 24)

                        favouritesList
                            .padding(.horizontal, 24)
                            .padding(.top, 20)
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
                Text("Saved doctors")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(AppColors.textMuted)

                Text("Your Favourites")
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

                Image(systemName: "heart.fill")
                    .font(.system(size: 16))
                    .foregroundColor(AppColors.error)
            }
            .frame(width: 46, height: 46)
        }
    }

    // MARK: - Info Card
    private var favouritesInfoCard: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(AppColors.primaryGlow)

                Image(systemName: "stethoscope")
                    .font(.system(size: 22))
                    .foregroundColor(AppColors.primaryLight)
            }
            .frame(width: 52, height: 52)

            VStack(alignment: .leading, spacing: 4) {
                Text("\(vm.favouriteDoctors.count) saved doctor\(vm.favouriteDoctors.count == 1 ? "" : "s")")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)

                Text("Manage your favourite doctors locally")
                    .font(.system(size: 13, design: .rounded))
                    .foregroundColor(AppColors.textMuted)
            }

            Spacer()
        }
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

    // MARK: - Favourites List
    private var favouritesList: some View {
        VStack(spacing: 14) {
            ForEach(vm.favouriteDoctors) { doctor in
                FavouriteDoctorCard(
                    doctor: doctor,
                    onRemoveTap: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            vm.removeFromFavourites(doctor)
                        }
                    }
                )
            }
        }
    }

    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(AppColors.backgroundCard)
                    .frame(width: 90, height: 90)

                Image(systemName: "heart.slash")
                    .font(.system(size: 34))
                    .foregroundColor(AppColors.primaryLight.opacity(0.8))
            }

            VStack(spacing: 8) {
                Text("No favourites yet")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundColor(AppColors.textSecondary)

                Text("Saved doctors will appear here once the patient adds them to favourites.")
                    .font(.system(size: 14, design: .rounded))
                    .foregroundColor(AppColors.textMuted)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

// MARK: - Favourite Doctor Card
struct FavouriteDoctorCard: View {
    let doctor: Doctor
    let onRemoveTap: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(AppColors.primaryGlow)

                Image(systemName: doctor.imageName)
                    .font(.system(size: 28))
                    .foregroundColor(AppColors.primaryLight)
            }
            .frame(width: 68, height: 68)

            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 6) {
                    Text(doctor.name)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)

                    if doctor.isAvailableToday {
                        Text("Today")
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
                            .foregroundColor(AppColors.success)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(AppColors.success.opacity(0.15))
                            .clipShape(Capsule())
                    }
                }

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

            VStack(alignment: .trailing, spacing: 10) {
                Button(action: onRemoveTap) {
                    ZStack {
                        Circle()
                            .fill(AppColors.error.opacity(0.15))
                            .frame(width: 34, height: 34)

                        Image(systemName: "heart.slash.fill")
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.error)
                    }
                }
                .buttonStyle(.plain)

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

#Preview {
    NavigationStack {
        FavouritesView()
    }
}
