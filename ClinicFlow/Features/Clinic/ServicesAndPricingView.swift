//
//  ServicesAndPricingView.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 30/03/2026.
//


import SwiftUI

struct ServicesAndPricingView: View {
    @StateObject private var vm = ServicesAndPricingViewModel()
    @Environment(\.dismiss) private var dismiss

    var onContinueTap: () -> Void = {}

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

                        servicesSection

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
            Text("Services and Pricing")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, AppColors.primaryLight],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )

            Text("Define the clinic services, consultation prices, and appointment duration for each service.")
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

                    Image(systemName: "stethoscope.circle.fill")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(AppColors.primaryLight)
                }

                Text("Services Setup Guidance")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 8) {
                guidanceRow("Add each clinic service with a clear title, price, and duration.")
                guidanceRow("You can display multiple services on this screen and expand this structure later.")
                guidanceRow("This step is prepared for future backend submission and dynamic service management.")
            }
        }
        .padding(16)
        .background(cardBackground)
    }

    private var servicesSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Service Items")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)

                Spacer()

                Button(action: vm.addService) {
                    HStack(spacing: 8) {
                        Image(systemName: "plus")
                        Text("Add Service")
                    }
                }
                .buttonStyle(OutlineButtonStyle(isFullWidth: false))
            }

            ForEach($vm.services) { $service in
                serviceCard(service: $service)
            }
        }
    }

    private func serviceCard(service: Binding<ClinicServiceDraft>) -> some View {
        let current = service.wrappedValue

        return VStack(alignment: .leading, spacing: 16) {
            HStack {
                HStack(spacing: 10) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(AppColors.primary.opacity(0.15))
                            .frame(width: 36, height: 36)

                        Image(systemName: "cross.case.fill")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(AppColors.primaryLight)
                    }

                    Text("Service")
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                }

                Spacer()

                if vm.services.count > 1 {
                    Button(action: {
                        vm.removeService(id: current.id)
                    }) {
                        Text("Remove")
                    }
                    .buttonStyle(OutlineButtonStyle(isFullWidth: false))
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Service Name")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(AppColors.textSecondary)

                TextField(
                    "",
                    text: service.serviceName,
                    prompt: Text("Enter service name").foregroundColor(AppColors.textMuted)
                )
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled(true)
                .foregroundColor(.white)
                .font(.system(size: 14, design: .rounded))
                .padding(.horizontal, 14)
                .frame(height: 52)
                .background(inputBackground(error: vm.serviceNameError(for: current) != nil))

                if let error = vm.serviceNameError(for: current) {
                    fieldError(error)
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Price")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(AppColors.textSecondary)

                TextField(
                    "",
                    text: service.priceText,
                    prompt: Text("Enter consultation price").foregroundColor(AppColors.textMuted)
                )
                .keyboardType(.decimalPad)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .foregroundColor(.white)
                .font(.system(size: 14, design: .rounded))
                .padding(.horizontal, 14)
                .frame(height: 52)
                .background(inputBackground(error: vm.priceError(for: current) != nil))

                if let error = vm.priceError(for: current) {
                    fieldError(error)
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Consultation Duration")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(AppColors.textSecondary)

                Menu {
                    ForEach(vm.durationOptions, id: \.self) { duration in
                        Button(action: {
                            service.durationMinutes.wrappedValue = duration
                        }) {
                            Text("\(duration) min")
                        }
                    }
                } label: {
                    HStack {
                        Text("\(service.durationMinutes.wrappedValue) min")
                            .font(.system(size: 14, design: .rounded))
                            .foregroundColor(.white)

                        Spacer()

                        Image(systemName: "chevron.down")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(AppColors.primaryLight)
                    }
                    .padding(.horizontal, 14)
                    .frame(height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(AppColors.backgroundDark.opacity(0.35))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(AppColors.primaryLight.opacity(0.12), lineWidth: 1)
                            )
                    )
                }
            }
        }
        .padding(16)
        .background(cardBackground)
    }

    private var bottomActionSection: some View {
        VStack(spacing: 14) {
            Button(action: {
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

            Text("This screen currently prepares the frontend structure for future backend submission and dynamic service management.")
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

    private func fieldError(_ text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: "exclamationmark.circle.fill")
                .font(.system(size: 11))

            Text(text)
                .font(.system(size: 12, design: .rounded))
        }
        .foregroundColor(AppColors.error)
    }

    private func inputBackground(error: Bool) -> some View {
        RoundedRectangle(cornerRadius: 14, style: .continuous)
            .fill(AppColors.backgroundDark.opacity(0.35))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(
                        error ? AppColors.error.opacity(0.6) : AppColors.primaryLight.opacity(0.12),
                        lineWidth: 1
                    )
            )
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 18, style: .continuous)
            .fill(AppColors.backgroundCard)
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(AppColors.primaryLight.opacity(0.12), lineWidth: 1)
            )
    }
}

#Preview {
    NavigationStack {
        ServicesAndPricingView()
    }
}