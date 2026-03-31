import SwiftUI

struct SlotSelectionView: View {
    @StateObject private var vm: SlotSelectionViewModel
    @Environment(\.dismiss) private var dismiss

    var onContinue: ((ScheduleSlot) -> Void)?

    init(
        doctor: Doctor,
        clinic: DoctorClinic,
        service: DoctorService,
        onContinue: ((ScheduleSlot) -> Void)? = nil
    ) {
        _vm = StateObject(wrappedValue: SlotSelectionViewModel(
            doctor: doctor,
            clinic: clinic,
            service: service
        ))
        self.onContinue = onContinue
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            AppColors.backgroundDark
                .ignoresSafeArea()

            ambientBlobs

            VStack(spacing: 0) {
                navBar

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        summaryCard
                            .padding(.horizontal, 20)
                            .padding(.top, 20)

                        monthHeader
                            .padding(.horizontal, 20)
                            .padding(.top, 28)

                        dateStrip
                            .padding(.top, 14)

                        slotSection
                            .padding(.top, 28)

                        Spacer().frame(height: 130)
                    }
                }
            }

            continueBar
        }
        .toolbar(.hidden, for: .navigationBar)
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: vm.selectedDateIndex)
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: vm.selectedSlot?.id)
    }

    // MARK: - Ambient blobs
    private var ambientBlobs: some View {
        ZStack {
            Circle()
                .fill(AppColors.primary.opacity(0.10))
                .frame(width: 320, height: 320)
                .blur(radius: 90)
                .offset(x: 140, y: -180)

            Circle()
                .fill(AppColors.accent.opacity(0.06))
                .frame(width: 260, height: 260)
                .blur(radius: 80)
                .offset(x: -100, y: 500)
        }
        .ignoresSafeArea()
    }

    // MARK: - Nav Bar
    private var navBar: some View {
        HStack {
            Button(action: { dismiss() }) {
                ZStack {
                    Circle()
                        .fill(AppColors.primary.opacity(0.12))
                        .frame(width: 42, height: 42)

                    Image(systemName: "chevron.left")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(AppColors.primaryLight)
                }
            }

            Spacer()

            VStack(spacing: 2) {
                Text("Select Time Slot")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                Text("Choose your appointment time")
                    .font(.system(size: 11, design: .rounded))
                    .foregroundColor(AppColors.textMuted)
            }

            Spacer()

            Circle()
                .fill(Color.clear)
                .frame(width: 42, height: 42)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }

    // MARK: - Summary Card
    private var summaryCard: some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(AppColors.primaryGlow)
                        .frame(width: 50, height: 50)

                    Image(systemName: vm.doctor.imageName)
                        .font(.system(size: 22))
                        .foregroundColor(AppColors.primaryLight)
                }
                .overlay(
                    Circle()
                        .stroke(AppColors.primaryLight.opacity(0.3), lineWidth: 1.5)
                )

                VStack(alignment: .leading, spacing: 3) {
                    Text(vm.doctor.name)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)

                    Text(vm.clinic.name)
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(AppColors.textMuted)
                        .lineLimit(1)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 3) {
                    Text("$\(vm.service.price)")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [AppColors.primaryLight, AppColors.accent],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )

                    Text(vm.service.name)
                        .font(.system(size: 11, design: .rounded))
                        .foregroundColor(AppColors.textMuted)
                        .lineLimit(1)
                }
            }
            .padding(14)

            Rectangle()
                .fill(AppColors.primaryLight.opacity(0.07))
                .frame(height: 1)

            HStack(spacing: 0) {
                summaryMeta(
                    icon: "location.fill",
                    label: "Location",
                    value: vm.clinic.address
                )

                Rectangle()
                    .fill(AppColors.primaryLight.opacity(0.07))
                    .frame(width: 1, height: 30)

                summaryMeta(
                    icon: "clock.fill",
                    label: "Duration",
                    value: "\(vm.service.durationMinutes) min"
                )

                Rectangle()
                    .fill(AppColors.primaryLight.opacity(0.07))
                    .frame(width: 1, height: 30)

                summaryMeta(
                    icon: "stethoscope",
                    label: "Specialty",
                    value: vm.doctor.specialty
                )
            }
            .padding(.vertical, 12)
        }
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(AppColors.backgroundCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(AppColors.primaryLight.opacity(0.1), lineWidth: 1)
                )
        )
    }

    private func summaryMeta(icon: String, label: String, value: String) -> some View {
        VStack(spacing: 3) {
            Image(systemName: icon)
                .font(.system(size: 11))
                .foregroundColor(AppColors.primaryLight)

            Text(value)
                .font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(1)

            Text(label)
                .font(.system(size: 10, design: .rounded))
                .foregroundColor(AppColors.textMuted)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Month Header
    private var monthHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(vm.selectedDate.monthYear)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                Text("\(vm.currentSlots.filter(\.isAvailable).count) slots available")
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(AppColors.textMuted)
            }

            Spacer()

            HStack(spacing: 12) {
                SelectionLegendDot(color: AppColors.primaryLight, label: "Free")
                SelectionLegendDot(color: AppColors.textMuted.opacity(0.3), label: "Taken")
            }
        }
    }

    // MARK: - Date Strip
    private var dateStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(vm.dates.indices, id: \.self) { i in
                    let date = vm.dates[i]
                    let isSelected = vm.selectedDateIndex == i

                    Button(action: {
                        vm.selectedDateIndex = i
                        vm.selectedSlot = nil
                    }) {
                        VStack(spacing: 4) {
                            Text(date.dayShort.uppercased())
                                .font(.system(size: 9, weight: .semibold, design: .rounded))
                                .foregroundColor(isSelected ? .white.opacity(0.8) : AppColors.textMuted)

                            Text(date.dayNumber)
                                .font(.system(size: 17, weight: .bold, design: .rounded))
                                .foregroundColor(isSelected ? .white : AppColors.textSecondary)

                            Circle()
                                .fill(
                                    date.availableCount > 0
                                    ? (isSelected ? Color.white.opacity(0.7) : AppColors.success.opacity(0.7))
                                    : Color.clear
                                )
                                .frame(width: 5, height: 5)
                        }
                        .frame(width: 48, height: 64)
                        .background(
                            Group {
                                if isSelected {
                                    LinearGradient(
                                        colors: [AppColors.primary, Color(hex: "#A855F7")],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                } else if date.isToday {
                                    AppColors.backgroundCard
                                } else {
                                    Color.clear
                                }
                            }
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(
                                    isSelected ? Color.clear
                                    : date.isToday ? AppColors.primaryLight.opacity(0.3)
                                    : AppColors.primaryLight.opacity(0.08),
                                    lineWidth: 1
                                )
                        )
                    }
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
                }
            }
            .padding(.horizontal, 20)
        }
    }

    // MARK: - Slot Section
    private var slotSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            let amSlots = vm.currentSlots.filter {
                let h = Int($0.time.prefix(2)) ?? 0
                return h < 12
            }

            let pmSlots = vm.currentSlots.filter {
                let h = Int($0.time.prefix(2)) ?? 0
                return h >= 12
            }

            if !amSlots.isEmpty {
                slotGroup(title: "Morning", icon: "sunrise.fill", slots: amSlots)
            }

            if !pmSlots.isEmpty {
                slotGroup(title: "Afternoon", icon: "sun.max.fill", slots: pmSlots)
            }

            if vm.currentSlots.isEmpty {
                emptyDayView
            }
        }
        .padding(.horizontal, 20)
    }

    private func slotGroup(title: String, icon: String, slots: [ScheduleSlot]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12))
                    .foregroundColor(AppColors.warning)

                Text(title)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(AppColors.textSecondary)

                Text("·")
                    .foregroundColor(AppColors.textMuted)

                Text("\(slots.filter(\.isAvailable).count) available")
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(AppColors.textMuted)
            }

            let columns = [GridItem(.adaptive(minimum: 74), spacing: 8)]

            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(slots) { slot in
                    SlotButton(
                        slot: slot,
                        isSelected: vm.selectedSlot?.id == slot.id,
                        onTap: {
                            guard slot.isAvailable else { return }
                            vm.selectedSlot = vm.selectedSlot?.id == slot.id ? nil : slot
                        }
                    )
                }
            }
        }
    }

    private var emptyDayView: some View {
        HStack(spacing: 12) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 20))
                .foregroundColor(AppColors.textMuted)

            VStack(alignment: .leading, spacing: 2) {
                Text("No slots on this day")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(AppColors.textSecondary)

                Text("Try selecting a different date")
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(AppColors.textMuted)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppColors.backgroundCard)
        )
    }

    // MARK: - Continue Bar
    private var continueBar: some View {
        VStack(spacing: 0) {
            if let slot = vm.selectedSlot {
                HStack(spacing: 16) {
                    HStack(spacing: 8) {
                        Image(systemName: "calendar")
                            .font(.system(size: 13))
                            .foregroundColor(AppColors.primaryLight)

                        VStack(alignment: .leading, spacing: 1) {
                            Text("\(vm.selectedDate.dayShort), \(vm.selectedDate.dayNumber) \(vm.selectedDate.monthYear)")
                                .font(.system(size: 11, design: .rounded))
                                .foregroundColor(AppColors.textMuted)

                            Text(slot.time)
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 1) {
                        Text("Total")
                            .font(.system(size: 10, design: .rounded))
                            .foregroundColor(AppColors.textMuted)

                        Text("$\(vm.service.price)")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [AppColors.primaryLight, AppColors.accent],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 14)
                .padding(.bottom, 6)
                .background(
                    AppColors.backgroundCard
                        .overlay(
                            Rectangle()
                                .fill(AppColors.primaryLight.opacity(0.08))
                                .frame(height: 1),
                            alignment: .top
                        )
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            Button(action: {
                if let slot = vm.selectedSlot {
                    onContinue?(slot)
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "creditcard.fill")
                        .font(.system(size: 15, weight: .semibold))

                    Text(vm.canContinue ? "Continue to Payment" : "Select a Time Slot")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                }
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(!vm.canContinue)
            .opacity(vm.canContinue ? 1 : 0.5)
            .padding(.horizontal, 20)
            .padding(.bottom, 36)
            .padding(.top, 12)
            .background(
                LinearGradient(
                    colors: [
                        AppColors.backgroundDark.opacity(0),
                        AppColors.backgroundDark,
                        AppColors.backgroundDark
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
        }
    }
}

// MARK: - Legend Dot
struct SelectionLegendDot: View {
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

// MARK: - Slot Button
struct SlotButton: View {
    let slot: ScheduleSlot
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 3) {
                Text(slot.time)
                    .font(.system(size: 13, weight: isSelected ? .bold : .regular, design: .rounded))
                    .foregroundColor(labelColor)

                if !slot.isAvailable {
                    Text("Taken")
                        .font(.system(size: 9, design: .rounded))
                        .foregroundColor(AppColors.textMuted.opacity(0.5))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(backgroundFill)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(borderColor, lineWidth: isSelected ? 0 : 1)
            )
            .shadow(
                color: isSelected ? AppColors.primary.opacity(0.35) : .clear,
                radius: 8,
                x: 0,
                y: 4
            )
        }
        .disabled(!slot.isAvailable)
        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isSelected)
    }

    private var labelColor: Color {
        if !slot.isAvailable { return AppColors.textMuted.opacity(0.3) }
        if isSelected { return .white }
        return AppColors.textSecondary
    }

    @ViewBuilder
    private var backgroundFill: some View {
        if isSelected {
            LinearGradient(
                colors: [AppColors.primary, Color(hex: "#A855F7")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else if !slot.isAvailable {
            AppColors.backgroundCard.opacity(0.35)
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
        SlotSelectionView(
            doctor: Doctor.placeholders[0],
            clinic: DoctorProfile.placeholder(for: Doctor.placeholders[0]).clinics[0],
            service: DoctorProfile.placeholder(for: Doctor.placeholders[0]).services[0]
        )
    }
}
