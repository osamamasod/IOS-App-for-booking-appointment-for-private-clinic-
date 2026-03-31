//
//  BookingConfirmationView.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 31/03/2026.
//


import SwiftUI

struct BookingConfirmationView: View {
    @StateObject private var vm: BookingConfirmationViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var navigateToSuccess = false

    init(
        doctor: Doctor,
        clinic: DoctorClinic,
        service: DoctorService,
        slot: ScheduleSlot,
        appointmentDateText: String,
        paymentMethod: BookingPaymentMethod
    ) {
        _vm = StateObject(wrappedValue: BookingConfirmationViewModel(
            doctor: doctor,
            clinic: clinic,
            service: service,
            slot: slot,
            appointmentDateText: appointmentDateText,
            paymentMethod: paymentMethod
        ))
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
                        heroSummaryCard
                            .padding(.horizontal, 20)
                            .padding(.top, 20)

                        bookingDetailsSection
                            .padding(.horizontal, 20)
                            .padding(.top, 28)

                        paymentSection
                            .padding(.horizontal, 20)
                            .padding(.top, 24)

                        priceSection
                            .padding(.horizontal, 20)
                            .padding(.top, 24)

                        Spacer()
                            .frame(height: 150)
                    }
                }
            }

            bottomActionBar
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationDestination(isPresented: $navigateToSuccess) {
            BookingSuccessPlaceholderView()
        }
    }

    // MARK: - Ambient Blobs
    private var ambientBlobs: some View {
        ZStack {
            Circle()
                .fill(AppColors.primary.opacity(0.10))
                .frame(width: 330, height: 330)
                .blur(radius: 95)
                .offset(x: 140, y: -180)

            Circle()
                .fill(AppColors.accent.opacity(0.06))
                .frame(width: 270, height: 270)
                .blur(radius: 85)
                .offset(x: -110, y: 480)
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
                Text("Booking Confirmation")
                    .font(.system(size: 17, weight: .bold, design: .rounded))
                    .foregroundColor(.white)

                Text("Review before confirming")
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

    // MARK: - Hero Summary
    private var heroSummaryCard: some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(AppColors.primaryGlow)
                        .frame(width: 56, height: 56)

                    Image(systemName: vm.doctor.imageName)
                        .font(.system(size: 24))
                        .foregroundColor(AppColors.primaryLight)
                }
                .overlay(
                    Circle()
                        .stroke(AppColors.primaryLight.opacity(0.28), lineWidth: 1.5)
                )

                VStack(alignment: .leading, spacing: 4) {
                    Text(vm.doctor.name)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .lineLimit(1)

                    Text(vm.doctor.specialty)
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(AppColors.textMuted)
                        .lineLimit(1)

                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 11))
                            .foregroundColor(AppColors.success)

                        Text("Ready to confirm appointment")
                            .font(.system(size: 11, design: .rounded))
                            .foregroundColor(AppColors.textSecondary)
                    }
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

                    Text("Final Total")
                        .font(.system(size: 11, design: .rounded))
                        .foregroundColor(AppColors.textMuted)
                }
            }
            .padding(16)

            Rectangle()
                .fill(AppColors.primaryLight.opacity(0.07))
                .frame(height: 1)

            HStack(spacing: 0) {
                confirmationMeta(
                    icon: "building.2.fill",
                    label: "Clinic",
                    value: vm.clinic.name
                )

                Rectangle()
                    .fill(AppColors.primaryLight.opacity(0.07))
                    .frame(width: 1, height: 30)

                confirmationMeta(
                    icon: "calendar",
                    label: "Date & Time",
                    value: vm.slot.time
                )

                Rectangle()
                    .fill(AppColors.primaryLight.opacity(0.07))
                    .frame(width: 1, height: 30)

                confirmationMeta(
                    icon: "creditcard.fill",
                    label: "Payment",
                    value: vm.paymentMethod.badgeText
                )
            }
            .padding(.vertical, 12)
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

    private func confirmationMeta(icon: String, label: String, value: String) -> some View {
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

    // MARK: - Booking Details
    private var bookingDetailsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionHeader(title: "Booking Summary", icon: "doc.text.fill")

            VStack(spacing: 12) {
                ConfirmationDetailRow(
                    icon: "person.text.rectangle.fill",
                    title: "Doctor",
                    value: "\(vm.doctor.name) • \(vm.doctor.specialty)"
                )

                ConfirmationDetailRow(
                    icon: "building.2.fill",
                    title: "Clinic",
                    value: vm.clinic.name
                )

                ConfirmationDetailRow(
                    icon: "location.fill",
                    title: "Location",
                    value: vm.clinicLocationText
                )

                ConfirmationDetailRow(
                    icon: "calendar.badge.clock",
                    title: "Appointment",
                    value: vm.appointmentDateTimeText
                )

                ConfirmationDetailRow(
                    icon: "cross.case.fill",
                    title: "Service",
                    value: vm.service.name
                )
            }
        }
    }

    // MARK: - Payment Section
    private var paymentSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionHeader(title: "Payment Method", icon: "creditcard.fill")

            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(AppColors.primary.opacity(0.18))

                    Image(systemName: vm.paymentMethod.icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(AppColors.primaryLight)
                }
                .frame(width: 52, height: 52)

                VStack(alignment: .leading, spacing: 4) {
                    Text(vm.paymentMethodTitle)
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)

                    Text(vm.paymentMethodSubtitle)
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(AppColors.textMuted)
                        .multilineTextAlignment(.leading)
                }

                Spacer()
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(AppColors.backgroundCard)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(AppColors.primaryLight.opacity(0.08), lineWidth: 1)
                    )
            )
        }
    }

    // MARK: - Price Section
    private var priceSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionHeader(title: "Price Details", icon: "dollarsign.circle.fill")

            VStack(spacing: 12) {
                PriceLine(title: "Consultation", value: vm.totalPriceText)
                PriceLine(title: "Payment Method", value: vm.paymentMethod.title)
                PriceLine(title: "Selected Slot", value: vm.slot.time)

                Rectangle()
                    .fill(AppColors.primaryLight.opacity(0.07))
                    .frame(height: 1)

                HStack {
                    Text("Total")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)

                    Spacer()

                    Text(vm.totalPriceText)
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
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(AppColors.backgroundCard)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(AppColors.primaryLight.opacity(0.08), lineWidth: 1)
                    )
            )
        }
    }

    // MARK: - Bottom Bar
    private var bottomActionBar: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                Button(action: { dismiss() }) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 14, weight: .semibold))

                        Text("Back")
                            .font(.system(size: 15, weight: .semibold, design: .rounded))
                    }
                    .foregroundColor(.white)
                    .frame(width: 110, height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(AppColors.backgroundCard)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(AppColors.primaryLight.opacity(0.10), lineWidth: 1)
                            )
                    )
                }

                Button(action: {
                    navigateToSuccess = true
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 15, weight: .semibold))

                        Text("Confirm Booking")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(PrimaryButtonStyle())
            }
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

// MARK: - Detail Row
struct ConfirmationDetailRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(AppColors.primaryGlow)

                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.primaryLight)
            }
            .frame(width: 42, height: 42)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 11, design: .rounded))
                    .foregroundColor(AppColors.textMuted)

                Text(value)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
            }

            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(AppColors.backgroundCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(AppColors.primaryLight.opacity(0.08), lineWidth: 1)
                )
        )
    }
}

// MARK: - Price Line
struct PriceLine: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 13, design: .rounded))
                .foregroundColor(AppColors.textMuted)

            Spacer()

            Text(value)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundColor(.white)
        }
    }
}

// MARK: - Success Placeholder
struct BookingSuccessPlaceholderView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            AppColors.backgroundDark
                .ignoresSafeArea()

            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(AppColors.success.opacity(0.16))
                        .frame(width: 90, height: 90)

                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 42))
                        .foregroundColor(AppColors.success)
                }

                VStack(spacing: 8) {
                    Text("Booking Confirmed")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundColor(.white)

                    Text("Your appointment has been confirmed successfully.")
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(AppColors.textMuted)
                        .multilineTextAlignment(.center)
                }

                Button(action: { dismiss() }) {
                    Text("Done")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding(.horizontal, 24)
            }
            .padding(.horizontal, 24)
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        BookingConfirmationView(
            doctor: Doctor.placeholders[0],
            clinic: DoctorProfile.placeholder(for: Doctor.placeholders[0]).clinics[0],
            service: DoctorProfile.placeholder(for: Doctor.placeholders[0]).services[0],
            slot: ScheduleSlot(id: UUID(), time: "10:30", isAvailable: true),
            appointmentDateText: "Tue, 31 March 2026",
            paymentMethod: .cashOnArrival
        )
    }
}