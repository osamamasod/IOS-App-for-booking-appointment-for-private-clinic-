//
//  DoctorSearchView.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 31/03/2026.
//


import SwiftUI

struct DoctorSearchView: View {
    @StateObject private var vm = DoctorSearchViewModel()
    @Environment(\.dismiss) private var dismiss
    @FocusState private var searchFocused: Bool

    var body: some View {
        ZStack {
            AppColors.backgroundDark.ignoresSafeArea()

            // Ambient blobs
            ZStack {
                Circle()
                    .fill(AppColors.primary.opacity(0.1))
                    .frame(width: 300, height: 300)
                    .blur(radius: 80)
                    .offset(x: 130, y: -160)
                Circle()
                    .fill(AppColors.accent.opacity(0.07))
                    .frame(width: 240, height: 240)
                    .blur(radius: 70)
                    .offset(x: -90, y: 400)
            }
            .ignoresSafeArea()

            VStack(spacing: 0) {

                // MARK: Nav bar
                navBar

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {

                        // MARK: Search input
                        searchBar
                            .padding(.horizontal, 24)
                            .padding(.top, 16)

                        // MARK: Filter toggle row
                        filterToggleRow
                            .padding(.horizontal, 24)
                            .padding(.top, 14)

                        // MARK: Expanded filters
                        if vm.isFiltersExpanded {
                            filterPanel
                                .padding(.horizontal, 24)
                                .padding(.top, 14)
                                .transition(.asymmetric(
                                    insertion: .move(edge: .top).combined(with: .opacity),
                                    removal:   .move(edge: .top).combined(with: .opacity)
                                ))
                        }

                        // MARK: Results header
                        resultsHeader
                            .padding(.horizontal, 24)
                            .padding(.top, 24)

                        // MARK: Results list
                        if vm.results.isEmpty {
                            emptyState
                                .padding(.top, 60)
                        } else {
                            VStack(spacing: 12) {
                                ForEach(vm.results) { doctor in
                                    SearchResultCard(doctor: doctor)
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.top, 14)
                        }

                        Spacer().frame(height: 100)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: vm.isFiltersExpanded)
    }

    // MARK: - Nav Bar
    private var navBar: some View {
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

            Text("Find a Doctor")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.white)

            Spacer()

            // Reset button — visible only when filters are active
            Button(action: { vm.resetFilters() }) {
                Text("Reset")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(AppColors.primaryLight)
                    .opacity(vm.activeFilterCount > 0 ? 1 : 0)
            }
            .frame(width: 48)
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }

    // MARK: - Search Bar
    private var searchBar: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(AppColors.textMuted)

            TextField(
                "",
                text: $vm.searchText,
                prompt: Text("Search name, specialty, clinic...")
                    .foregroundColor(AppColors.textMuted)
            )
            .font(.system(size: 15, design: .rounded))
            .foregroundColor(.white)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .focused($searchFocused)

            if !vm.searchText.isEmpty {
                Button(action: { vm.searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 15))
                        .foregroundColor(AppColors.textMuted)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppColors.backgroundCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(
                            searchFocused
                                ? AppColors.primaryLight.opacity(0.5)
                                : AppColors.primaryLight.opacity(0.15),
                            lineWidth: 1
                        )
                )
        )
        .animation(.easeInOut(duration: 0.2), value: searchFocused)
    }

    // MARK: - Filter Toggle Row
    private var filterToggleRow: some View {
        HStack(spacing: 10) {
            // Filter toggle button
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    vm.isFiltersExpanded.toggle()
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 14, weight: .medium))
                    Text("Filters")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))

                    if vm.activeFilterCount > 0 {
                        ZStack {
                            Circle()
                                .fill(.white.opacity(0.25))
                                .frame(width: 18, height: 18)
                            Text("\(vm.activeFilterCount)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                }
                .foregroundColor(vm.isFiltersExpanded ? .white : AppColors.primaryLight)
                .padding(.horizontal, 16)
                .padding(.vertical, 9)
                .background(
                    Group {
                        if vm.isFiltersExpanded {
                            LinearGradient(
                                colors: [AppColors.primary, Color(hex: "#A855F7")],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        } else {
                            LinearGradient(
                                colors: [AppColors.backgroundCard, AppColors.backgroundCard],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        }
                    }
                )
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(
                            vm.isFiltersExpanded
                                ? Color.clear
                                : AppColors.primaryLight.opacity(0.25),
                            lineWidth: 1
                        )
                )
            }

            // Availability quick chips
            ForEach(DoctorSearchViewModel.AvailabilityFilter.allCases, id: \.self) { filter in
                Button(action: {
                    vm.selectedAvailability = filter
                }) {
                    Text(filter.rawValue)
                        .font(.system(size: 13, weight: vm.selectedAvailability == filter ? .semibold : .regular, design: .rounded))
                        .foregroundColor(vm.selectedAvailability == filter ? .white : AppColors.textSecondary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 9)
                        .background(
                            Group {
                                if vm.selectedAvailability == filter {
                                    LinearGradient(
                                        colors: [AppColors.primary, Color(hex: "#A855F7")],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                } else {
                                    LinearGradient(
                                        colors: [AppColors.backgroundCard, AppColors.backgroundCard],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                }
                            }
                        )
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(
                                    vm.selectedAvailability == filter
                                        ? Color.clear
                                        : AppColors.primaryLight.opacity(0.2),
                                    lineWidth: 1
                                )
                        )
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: vm.selectedAvailability)
            }

            Spacer()
        }
    }

    // MARK: - Filter Panel
    private var filterPanel: some View {
        VStack(spacing: 20) {

            // Specialty
            FilterSection(title: "Specialty", icon: "stethoscope") {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(vm.specialties, id: \.self) { s in
                            SpecialtyChip(
                                title: s,
                                isSelected: vm.selectedSpecialty == s,
                                onTap: { vm.selectedSpecialty = s }
                            )
                        }
                    }
                }
            }

            Divider()
                .background(AppColors.primaryLight.opacity(0.1))

            // Distance
            FilterSection(title: "Max Distance: \(vm.maxDistanceKm, default: "%.0f") km", icon: "location.fill") {
                VStack(spacing: 6) {
                    Slider(value: $vm.maxDistanceKm, in: 1...50, step: 1)
                        .tint(AppColors.primaryLight)
                    HStack {
                        Text("1 km")
                        Spacer()
                        Text("50 km")
                    }
                    .font(.system(size: 11, design: .rounded))
                    .foregroundColor(AppColors.textMuted)
                }
            }

            Divider()
                .background(AppColors.primaryLight.opacity(0.1))

            // Price range
            FilterSection(title: "Price: $\(Int(vm.minPrice)) – $\(Int(vm.maxPrice))", icon: "dollarsign.circle.fill") {
                VStack(spacing: 10) {
                    VStack(spacing: 6) {
                        HStack {
                            Text("Min")
                                .font(.system(size: 12, design: .rounded))
                                .foregroundColor(AppColors.textMuted)
                            Spacer()
                            Text("$\(Int(vm.minPrice))")
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                .foregroundColor(AppColors.primaryLight)
                        }
                        Slider(value: $vm.minPrice, in: 0...vm.maxPrice, step: 5)
                            .tint(AppColors.primaryLight)
                    }
                    VStack(spacing: 6) {
                        HStack {
                            Text("Max")
                                .font(.system(size: 12, design: .rounded))
                                .foregroundColor(AppColors.textMuted)
                            Spacer()
                            Text("$\(Int(vm.maxPrice))")
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                .foregroundColor(AppColors.primaryLight)
                        }
                        Slider(value: $vm.maxPrice, in: vm.minPrice...500, step: 5)
                            .tint(AppColors.primaryLight)
                    }
                }
            }

            Divider()
                .background(AppColors.primaryLight.opacity(0.1))

            // Schedule placeholder
            FilterSection(title: "Schedule", icon: "calendar") {
                HStack(spacing: 10) {
                    ForEach(["Any day", "This week", "This month"], id: \.self) { label in
                        Text(label)
                            .font(.system(size: 13, design: .rounded))
                            .foregroundColor(AppColors.textSecondary)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(AppColors.backgroundDark)
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(AppColors.primaryLight.opacity(0.2), lineWidth: 1)
                            )
                    }
                    Spacer()
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(AppColors.backgroundCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(AppColors.primaryLight.opacity(0.1), lineWidth: 1)
                )
        )
    }

    // MARK: - Results Header
    private var resultsHeader: some View {
        HStack {
            Text("\(vm.results.count) doctor\(vm.results.count == 1 ? "" : "s") found")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            Spacer()
            Text("Sorted by rating")
                .font(.system(size: 12, design: .rounded))
                .foregroundColor(AppColors.textMuted)
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
            Text("Try adjusting your filters or search term")
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(AppColors.textMuted)
                .multilineTextAlignment(.center)
            Button(action: {
                vm.searchText = ""
                vm.resetFilters()
            }) {
                Text("Clear all filters")
            }
            .buttonStyle(OutlineButtonStyle(isFullWidth: false))
            .padding(.top, 4)
        }
        .padding(.horizontal, 40)
    }
}

// MARK: - Filter Section Wrapper
struct FilterSection<Content: View>: View {
    let title: String
    let icon: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 13))
                    .foregroundColor(AppColors.primaryLight)
                Text(title)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(AppColors.textSecondary)
            }
            content()
        }
    }
}

// MARK: - Search Result Card
struct SearchResultCard: View {
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
            .frame(width: 66, height: 66)

            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(doctor.name)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(1)

                Text(doctor.specialty)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundColor(AppColors.primaryLight)

                Text(doctor.clinic)
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(AppColors.textMuted)
                    .lineLimit(1)

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
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.textMuted)
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
    NavigationStack {
        DoctorSearchView()
    }
}
