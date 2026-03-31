//
//  PaymentMethodView.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 31/03/2026.
//


import SwiftUI

struct PaymentMethodView: View {
    @StateObject private var vm: PaymentMethodViewModel
    @Environment(\.dismiss) private var dismiss

    var onContinue: ((BookingPaymentMethod) -> Void)?

    init(
        doctor: Doctor,
        clinic: DoctorClinic,
        service: DoctorService,
        slot: ScheduleSlot,
        appointmentDateText: String,
        onContinue: ((BookingPaymentMethod) -> Void)? = nil
    ) {
        _vm = StateObject(wrappedValue: PaymentMethodViewModel(
            doctor: doctor,
            clinic: clinic,
            service: service,
            slot: slot,
            appointmentDateText: appointmentDateText
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

                        paymentMethodsSection
                            .padding(.horizontal, 20)
                            .padding(.top, 28)

                        Spacer()
                            .frame(height: 140)
                    }
                }
            }

            continueBar
        }
        .toolbar(.hidden, for: .navigationBar)
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: vm.selectedPaymentMethod?.id)
    }

    // MARK: - Ambient Blobs
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
                Text("Payment Method")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                Text("Choose how you want to pay")
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

                    Text(vm.doctor.specialty)
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(AppColors.textMuted)
                        .lineLimit(1)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(vm.totalPriceText)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [AppColors.primaryLight, AppColors.accent],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )

                    Text("Appointment Total")
                        .font(.system(size: 11, design: .rounded))
                        .foregroundColor(AppColors.textMuted)
                }
            }
            .padding(16)

            Rectangle()
                .fill(AppColors.primaryLight.opacity(0.07))
                .frame(height: 1)

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ],
                spacing: 12
            ) {
                PaymentSummaryPill(
                    icon: "building.2.fill",
                    title: "Clinic",
                    value: vm.clinic.name
                )

                PaymentSummaryPill(
                    icon: "cross.case.fill",
                    title: "Service",
                    value: vm.service.name
                )

                PaymentSummaryPill(
                    icon: "calendar",
                    title: "Date",
                    value: vm.appointmentDateText
                )

                PaymentSummaryPill(
                    icon: "clock.fill",
                    title: "Slot",
                    value: vm.slotText
                )
            }
            .padding(16)
        }
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(AppColors.backgroundCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(AppColors.primaryLight.opacity(0.10), lineWidth: 1)
                )
        )
    }

    // MARK: - Payment Methods
    private var paymentMethodsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionHeader(title: "Select Payment Method", icon: "creditcard.fill")

            Text("Choose one payment option before confirming the booking.")
                .font(.system(size: 13, design: .rounded))
                .foregroundColor(AppColors.textMuted)
                .lineSpacing(4)

            ForEach(vm.methods) { method in
                PaymentMethodOptionCard(
                    method: method,
                    isSelected: vm.selectedPaymentMethod == method,
                    onTap: {
                        vm.select(method)
                    }
                )
            }
        }
    }

    // MARK: - Continue Bar
    private var continueBar: some View {
        VStack(spacing: 0) {
            if let selectedMethod = vm.selectedPaymentMethod {
                selectedMethodSummary(method: selectedMethod)
            }

            Button(action: {
                guard let method = vm.selectedPaymentMethod else { return }
                onContinue?(method)
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 15, weight: .semibold))

                    Text(vm.canContinue ? "Continue to Confirmation" : "Select Payment Method")
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
                ZStack(alignment: .top) {
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

                    Rectangle()
                        .fill(AppColors.primaryLight.opacity(0.08))
                        .frame(height: 1)
                }
            )
        }
    }

    private func selectedMethodSummary(method: BookingPaymentMethod) -> some View {
        HStack(spacing: 10) {
            Image(systemName: method.icon)
                .font(.system(size: 14))
                .foregroundColor(AppColors.primaryLight)

            VStack(alignment: .leading, spacing: 2) {
                Text("Selected Method")
                    .font(.system(size: 10, design: .rounded))
                    .foregroundColor(AppColors.textMuted)

                Text(method.title)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
            }

            Spacer()

            Text(vm.totalPriceText)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [AppColors.primaryLight, AppColors.accent],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
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
                .fill(AppColors.primaryLight.opacity(0.10))
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
}

// MARK: - Payment Method Option Card
struct PaymentMethodOptionCard: View {
    let method: BookingPaymentMethod
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(isSelected ? AppColors.primary.opacity(0.22) : AppColors.primaryGlow)

                    Image(systemName: method.icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(AppColors.primaryLight)
                }
                .frame(width: 52, height: 52)

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(method.title)
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                            .foregroundColor(.white)

                        Text(method.badgeText)
                            .font(.system(size: 10, weight: .semibold, design: .rounded))
                            .foregroundColor(AppColors.primaryLight)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(AppColors.primary.opacity(0.12))
                            )
                    }

                    Text(method.subtitle)
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(AppColors.textMuted)
                        .multilineTextAlignment(.leading)
                }

                Spacer()

                ZStack {
                    Circle()
                        .stroke(
                            isSelected ? AppColors.primaryLight : AppColors.textMuted.opacity(0.30),
                            lineWidth: 1.5
                        )
                        .frame(width: 22, height: 22)

                    if isSelected {
                        Circle()
                            .fill(AppColors.primaryLight)
                            .frame(width: 12, height: 12)
                    }
                }
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(AppColors.backgroundCard)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(
                                isSelected ? AppColors.primaryLight.opacity(0.45) : AppColors.primaryLight.opacity(0.08),
                                lineWidth: isSelected ? 1.5 : 1
                            )
                    )
            )
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.75), value: isSelected)
    }
}

// MARK: - Payment Summary Pill
struct PaymentSummaryPill: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(AppColors.primaryLight)

            Text(title)
                .font(.system(size: 10, design: .rounded))
                .foregroundColor(AppColors.textMuted)

            Text(value)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(AppColors.backgroundDark.opacity(0.45))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(AppColors.primaryLight.opacity(0.08), lineWidth: 1)
                )
        )
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        PaymentMethodView(
            doctor: Doctor.placeholders[0],
            clinic: DoctorProfile.placeholder(for: Doctor.placeholders[0]).clinics[0],
            service: DoctorProfile.placeholder(for: Doctor.placeholders[0]).services[0],
            slot: ScheduleSlot(id: UUID(), time: "10:30", isAvailable: true),
            appointmentDateText: "Tue, 31 March 2026"
        )
    }
}