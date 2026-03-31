import SwiftUI

struct DoctorProfileView: View {
    let doctor: Doctor
    @StateObject private var vm: DoctorProfileViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var headerOpacity: Double = 0
    @State private var contentOffset: CGFloat = 0

    init(doctor: Doctor) {
        self.doctor = doctor
        _vm = StateObject(wrappedValue: DoctorProfileViewModel(doctor: doctor))
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            AppColors.backgroundDark.ignoresSafeArea()

            ambientBlobs

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    heroSection
                    contentStack
                    Spacer().frame(height: 130)
                }
            }

            bookingBar
        }
        .navigationBarHidden(true)
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: vm.selectedClinic.id)
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: vm.selectedService?.id)
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: vm.selectedSlot?.id)
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: vm.selectedDateIndex)
    }

    // MARK: - Ambient Blobs
    private var ambientBlobs: some View {
        ZStack {
            Circle()
                .fill(AppColors.primary.opacity(0.10))
                .frame(width: 340, height: 340)
                .blur(radius: 90)
                .offset(x: 140, y: -220)
            Circle()
                .fill(AppColors.accent.opacity(0.06))
                .frame(width: 280, height: 280)
                .blur(radius: 80)
                .offset(x: -110, y: 480)
        }
        .ignoresSafeArea()
    }

    // MARK: - Content Stack
    private var contentStack: some View {
        VStack(spacing: 0) {
            statsRow
                .padding(.top, 16)
                .padding(.horizontal, 20)

            infoCards
                .padding(.top, 16)
                .padding(.horizontal, 20)

            bioSection
                .padding(.top, 24)
                .padding(.horizontal, 20)

            sectionDivider.padding(.top, 24)

            clinicsSection
                .padding(.top, 24)
                .padding(.horizontal, 20)

            sectionDivider.padding(.top, 24)

            servicesSection
                .padding(.top, 24)
                .padding(.horizontal, 20)

            sectionDivider.padding(.top, 24)

            scheduleSection
                .padding(.top, 24)
        }
    }

    // MARK: - Hero
    private var heroSection: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(
                colors: [AppColors.primaryDark, AppColors.primaryDark.opacity(0.6), AppColors.backgroundDark],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 260)
            .ignoresSafeArea(edges: .top)

            VStack(spacing: 0) {
                // Nav
                HStack {
                    Button(action: { dismiss() }) {
                        ZStack {
                            Circle()
                                .fill(.white.opacity(0.12))
                                .frame(width: 42, height: 42)
                            Image(systemName: "chevron.left")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    Spacer()
                    Text("Doctor Profile")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))
                    Spacer()
                    Button(action: {}) {
                        ZStack {
                            Circle()
                                .fill(.white.opacity(0.12))
                                .frame(width: 42, height: 42)
                            Image(systemName: "heart")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)

                // Avatar + identity
                VStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [AppColors.primary.opacity(0.5), AppColors.accent.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 88, height: 88)
                        Image(systemName: doctor.imageName)
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                    }
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [AppColors.primaryLight, AppColors.accent],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                    .shadow(color: AppColors.primary.opacity(0.4), radius: 16, x: 0, y: 8)

                    VStack(spacing: 3) {
                        Text(doctor.name)
                            .font(.system(size: 21, weight: .bold, design: .rounded))
                            .foregroundColor(.white)

                        HStack(spacing: 6) {
                            Text(doctor.specialty)
                                .font(.system(size: 13, weight: .medium, design: .rounded))
                                .foregroundColor(AppColors.primaryLight)
                            Circle()
                                .fill(AppColors.textMuted)
                                .frame(width: 3, height: 3)
                            Text(doctor.clinic)
                                .font(.system(size: 13, design: .rounded))
                                .foregroundColor(AppColors.textMuted)
                                .lineLimit(1)
                        }

                        HStack(spacing: 5) {
                            ForEach(0..<5) { i in
                                Image(systemName: i < Int(doctor.rating.rounded()) ? "star.fill" : "star")
                                    .font(.system(size: 10))
                                    .foregroundColor(AppColors.warning)
                            }
                            Text("\(doctor.rating, specifier: "%.1f")")
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                            Text("· \(doctor.reviewCount) reviews")
                                .font(.system(size: 12, design: .rounded))
                                .foregroundColor(AppColors.textMuted)
                        }
                        .padding(.top, 2)
                    }
                }
                .padding(.top, 12)
                .padding(.bottom, 20)
            }
        }
    }

    // MARK: - Stats Row
    private var statsRow: some View {
        HStack(spacing: 1) {
            ProfileStatCell(
                value: "\(vm.profile.experience)+",
                label: "Yrs Experience",
                icon: "briefcase.fill",
                color: AppColors.primaryLight
            )
            Rectangle()
                .fill(AppColors.primaryLight.opacity(0.08))
                .frame(width: 1, height: 44)
            ProfileStatCell(
                value: "\(vm.profile.patientsCount)+",
                label: "Patients",
                icon: "person.2.fill",
                color: AppColors.accent
            )
            Rectangle()
                .fill(AppColors.primaryLight.opacity(0.08))
                .frame(width: 1, height: 44)
            ProfileStatCell(
                value: "\(doctor.reviewCount)",
                label: "Reviews",
                icon: "star.fill",
                color: AppColors.warning
            )
            Rectangle()
                .fill(AppColors.primaryLight.opacity(0.08))
                .frame(width: 1, height: 44)
            ProfileStatCell(
                value: doctor.isAvailableToday ? "Today" : "Soon",
                label: "Available",
                icon: "clock.fill",
                color: doctor.isAvailableToday ? AppColors.success : AppColors.warning
            )
        }
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(AppColors.backgroundCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(AppColors.primaryLight.opacity(0.08), lineWidth: 1)
                )
        )
    }

    // MARK: - Info Cards (gender + age + fee)
    private var infoCards: some View {
        HStack(spacing: 10) {
            InfoPill(icon: "person.fill", label: "Gender", value: vm.profile.gender)
            InfoPill(icon: "calendar.badge.clock", label: "Age", value: "\(vm.profile.age) yrs")
            InfoPill(icon: "dollarsign.circle.fill", label: "From", value: "$\(doctor.consultationFee)")
        }
    }

    // MARK: - Bio
    private var bioSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionHeader(title: "About", icon: "info.circle.fill")
            Text(vm.profile.bio)
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(AppColors.textSecondary)
                .lineSpacing(6)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - Clinics
    private var clinicsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "Select Clinic", icon: "building.2.fill")

            ForEach(vm.profile.clinics) { clinic in
                ClinicRow(
                    clinic: clinic,
                    isSelected: vm.selectedClinic.id == clinic.id,
                    onTap: {
                        vm.selectedClinic = clinic
                        vm.selectedSlot   = nil
                    }
                )
            }
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Services
    private var servicesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "Services & Pricing", icon: "cross.case.fill")

            ForEach(vm.profile.services) { service in
                ServiceRow(
                    service: service,
                    isSelected: vm.selectedService?.id == service.id,
                    onTap: {
                        vm.selectedService = vm.selectedService?.id == service.id ? nil : service
                    }
                )
            }
        }
        .padding(.horizontal, 20)
    }

    // MARK: - Schedule
    private var scheduleSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionHeader(title: "Available Slots", icon: "calendar")
                .padding(.horizontal, 20)

            // Date strip
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(vm.upcomingDates.indices, id: \.self) { i in
                        DateChip(
                            label: vm.upcomingDates[i],
                            isSelected: vm.selectedDateIndex == i,
                            onTap: {
                                vm.selectedDateIndex = i
                                vm.selectedSlot = nil
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
            }

            // Slots grid
            if vm.currentSlots.isEmpty {
                emptySlots
                    .padding(.horizontal, 20)
            } else {
                let columns = [GridItem(.adaptive(minimum: 76), spacing: 8)]
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(vm.currentSlots) { slot in
                        SlotChip(
                            slot: slot,
                            isSelected: vm.selectedSlot?.id == slot.id,
                            onTap: {
                                guard slot.isAvailable else { return }
                                vm.selectedSlot = vm.selectedSlot?.id == slot.id ? nil : slot
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)

                // Legend
                HStack(spacing: 16) {
                    LegendDot(color: AppColors.primaryLight, label: "Available")
                    LegendDot(color: AppColors.textMuted.opacity(0.3), label: "Booked")
                }
                .padding(.horizontal, 20)
                .padding(.top, 4)
            }
        }
    }

    private var emptySlots: some View {
        HStack(spacing: 10) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 18))
                .foregroundColor(AppColors.textMuted)
            Text("No slots available. Try another clinic or date.")
                .font(.system(size: 13, design: .rounded))
                .foregroundColor(AppColors.textMuted)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(AppColors.backgroundCard)
        )
    }

    // MARK: - Booking Bar
    private var bookingBar: some View {
        VStack(spacing: 0) {
            if vm.selectedService != nil || vm.selectedSlot != nil {
                selectionSummary
            }

            Button(action: {}) {
                HStack(spacing: 8) {
                    Image(systemName: "calendar.badge.plus")
                        .font(.system(size: 15, weight: .semibold))
                    Text(vm.canBook ? "Confirm Booking" : "Select Service & Time Slot")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                }
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(!vm.canBook)
            .opacity(vm.canBook ? 1 : 0.5)
            .padding(.horizontal, 20)
            .padding(.bottom, 36)
            .padding(.top, 12)
            .background(
                LinearGradient(
                    colors: [AppColors.backgroundDark.opacity(0), AppColors.backgroundDark, AppColors.backgroundDark],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
        }
    }

    private var selectionSummary: some View {
        HStack(spacing: 0) {
            if let service = vm.selectedService {
                summaryPill(
                    icon: "cross.case.fill",
                    top: "Service",
                    bottom: service.name,
                    color: AppColors.primaryLight
                )
                Spacer()
            }
            if let slot = vm.selectedSlot {
                summaryPill(
                    icon: "clock.fill",
                    top: "Time",
                    bottom: slot.time,
                    color: AppColors.accent
                )
                Spacer()
            }
            if let service = vm.selectedService {
                VStack(alignment: .trailing, spacing: 1) {
                    Text("Total")
                        .font(.system(size: 10, design: .rounded))
                        .foregroundColor(AppColors.textMuted)
                    Text("$\(service.price)")
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [AppColors.primaryLight, AppColors.accent],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            AppColors.backgroundCard
                .overlay(
                    Rectangle()
                        .fill(AppColors.primaryLight.opacity(0.06))
                )
        )
        .overlay(
            Rectangle()
                .fill(AppColors.primaryLight.opacity(0.1))
                .frame(height: 1),
            alignment: .top
        )
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    // MARK: - Helpers
    private func sectionHeader(title: String, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(AppColors.primaryLight)
            Text(title)
                .font(.system(size: 17, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }
    }

    private var sectionDivider: some View {
        Rectangle()
            .fill(AppColors.primaryLight.opacity(0.07))
            .frame(height: 1)
            .padding(.horizontal, 20)
    }

    private func summaryPill(icon: String, top: String, bottom: String, color: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(color)
            VStack(alignment: .leading, spacing: 1) {
                Text(top)
                    .font(.system(size: 10, design: .rounded))
                    .foregroundColor(AppColors.textMuted)
                Text(bottom)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
        }
    }
}

// MARK: - Profile Stat Cell
struct ProfileStatCell: View {
    let value: String
    let label: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundColor(color)
            Text(value)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 10, design: .rounded))
                .foregroundColor(AppColors.textMuted)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Info Pill
struct InfoPill: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(AppColors.primaryLight)
            Text(value)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 10, design: .rounded))
                .foregroundColor(AppColors.textMuted)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppColors.backgroundCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(AppColors.primaryLight.opacity(0.08), lineWidth: 1)
                )
        )
    }
}

// MARK: - Legend Dot
struct LegendDot: View {
    let color: Color
    let label: String

    var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(color)
                .frame(width: 7, height: 7)
            Text(label)
                .font(.system(size: 11, design: .rounded))
                .foregroundColor(AppColors.textMuted)
        }
    }
}

// MARK: - Clinic Row (unchanged logic, tightened layout)
struct ClinicRow: View {
    let clinic: DoctorClinic
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(isSelected ? AppColors.primary.opacity(0.2) : AppColors.primaryGlow)
                    Image(systemName: "building.2.fill")
                        .font(.system(size: 15))
                        .foregroundColor(AppColors.primaryLight)
                }
                .frame(width: 44, height: 44)

                VStack(alignment: .leading, spacing: 2) {
                    Text(clinic.name)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    Text(clinic.address)
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(AppColors.textMuted)
                        .lineLimit(1)
                    HStack(spacing: 3) {
                        Image(systemName: "location.fill")
                            .font(.system(size: 9))
                            .foregroundColor(AppColors.textMuted)
                        Text("\(clinic.distanceKm, specifier: "%.1f") km")
                            .font(.system(size: 11, design: .rounded))
                            .foregroundColor(AppColors.textMuted)
                        Text("·")
                            .foregroundColor(AppColors.textMuted)
                        Text(clinic.phone)
                            .font(.system(size: 11, design: .rounded))
                            .foregroundColor(AppColors.textMuted)
                    }
                }

                Spacer()

                ZStack {
                    Circle()
                        .stroke(
                            isSelected ? AppColors.primaryLight : AppColors.textMuted.opacity(0.3),
                            lineWidth: 1.5
                        )
                        .frame(width: 20, height: 20)
                    if isSelected {
                        Circle()
                            .fill(AppColors.primaryLight)
                            .frame(width: 11, height: 11)
                    }
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(AppColors.backgroundCard)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(
                                isSelected ? AppColors.primaryLight.opacity(0.45) : AppColors.primaryLight.opacity(0.08),
                                lineWidth: isSelected ? 1.5 : 1
                            )
                    )
            )
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Service Row
struct ServiceRow: View {
    let service: DoctorService
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(isSelected ? AppColors.primary.opacity(0.2) : AppColors.primaryGlow)
                    Image(systemName: "cross.case.fill")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.primaryLight)
                }
                .frame(width: 44, height: 44)

                VStack(alignment: .leading, spacing: 2) {
                    Text(service.name)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    Text(service.description)
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(AppColors.textMuted)
                        .lineLimit(1)
                    Text("\(service.durationMinutes) min session")
                        .font(.system(size: 11, design: .rounded))
                        .foregroundColor(AppColors.textMuted)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("$\(service.price)")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .foregroundColor(isSelected ? AppColors.primaryLight : .white)
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 14))
                            .foregroundColor(AppColors.success)
                    }
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(AppColors.backgroundCard)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(
                                isSelected ? AppColors.primaryLight.opacity(0.45) : AppColors.primaryLight.opacity(0.08),
                                lineWidth: isSelected ? 1.5 : 1
                            )
                    )
            )
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Date Chip
struct DateChip: View {
    let label: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(label)
                .font(.system(size: 11, weight: isSelected ? .semibold : .regular, design: .rounded))
                .multilineTextAlignment(.center)
                .foregroundColor(isSelected ? .white : AppColors.textSecondary)
                .frame(width: 52, height: 52)
                .background(
                    Group {
                        if isSelected {
                            LinearGradient(
                                colors: [AppColors.primary, Color(hex: "#A855F7")],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        } else {
                            Color.clear
                        }
                    }
                )
                .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 13, style: .continuous)
                        .stroke(
                            isSelected ? Color.clear : AppColors.primaryLight.opacity(0.15),
                            lineWidth: 1
                        )
                )
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Slot Chip
struct SlotChip: View {
    let slot: ScheduleSlot
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(slot.time)
                .font(.system(size: 12, weight: isSelected ? .semibold : .regular, design: .rounded))
                .foregroundColor(foregroundColor)
                .frame(maxWidth: .infinity)
                .frame(height: 38)
                .background(backgroundView)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(borderColor, lineWidth: isSelected ? 0 : 1)
                )
        }
        .disabled(!slot.isAvailable)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }

    private var foregroundColor: Color {
        if !slot.isAvailable { return AppColors.textMuted.opacity(0.3) }
        if isSelected        { return .white }
        return AppColors.textSecondary
    }

    @ViewBuilder private var backgroundView: some View {
        if isSelected {
            LinearGradient(
                colors: [AppColors.primary, Color(hex: "#A855F7")],
                startPoint: .leading,
                endPoint: .trailing
            )
        } else if !slot.isAvailable {
            AppColors.backgroundCard.opacity(0.4)
        } else {
            AppColors.backgroundCard
        }
    }

    private var borderColor: Color {
        if !slot.isAvailable { return AppColors.primaryLight.opacity(0.04) }
        return AppColors.primaryLight.opacity(0.15)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        DoctorProfileView(doctor: Doctor.placeholders[0])
    }
}
