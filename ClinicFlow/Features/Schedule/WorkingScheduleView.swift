//
//  WorkingScheduleView.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 30/03/2026.
//


import SwiftUI

struct WorkingScheduleView: View {
    @StateObject private var vm = WorkingScheduleViewModel()
    @Environment(\.dismiss) private var dismiss

    var onFinishTap: () -> Void = {}

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

                        scheduleSection

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
            Text("Working Schedule")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, AppColors.primaryLight],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )

            Text("Prepare the clinic working days and hours to complete the frontend clinic setup flow.")
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

                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(AppColors.primaryLight)
                }

                Text("Working Schedule Guidance")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 8) {
                guidanceRow("Enable the working days that the clinic will accept appointments.")
                guidanceRow("Choose a start time and end time for each enabled day.")
                guidanceRow("This screen prepares local schedule state for future backend integration.")
            }
        }
        .padding(16)
        .background(cardBackground)
    }

    private var scheduleSection: some View {
        VStack(spacing: 16) {
            ForEach($vm.days) { $day in
                scheduleCard(day: $day)
            }
        }
    }

    private func scheduleCard(day: Binding<WorkingDayDraft>) -> some View {
        let current = day.wrappedValue
        let hasError = vm.timeError(for: current) != nil

        return VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(current.dayName)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)

                    Text(current.isEnabled ? "Working day enabled" : "Day off")
                        .font(.system(size: 13, design: .rounded))
                        .foregroundColor(current.isEnabled ? AppColors.success : AppColors.textMuted)
                }

                Spacer()

                Toggle("", isOn: day.isEnabled)
                    .labelsHidden()
                    .tint(AppColors.primary)
            }

            if current.isEnabled {
                HStack(spacing: 12) {
                    timeMenu(
                        title: "Start",
                        value: day.startTime,
                        hasError: hasError
                    ) { selected in
                        day.startTime.wrappedValue = selected
                    }

                    timeMenu(
                        title: "End",
                        value: day.endTime,
                        hasError: hasError
                    ) { selected in
                        day.endTime.wrappedValue = selected
                    }
                }

                if let error = vm.timeError(for: current) {
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
        .padding(16)
        .background(cardBackground)
    }

    private func timeMenu(
        title: String,
        value: Binding<String>,
        hasError: Bool,
        onSelect: @escaping (String) -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(AppColors.textSecondary)

            Menu {
                ForEach(vm.timeOptions, id: \.self) { option in
                    Button(option) {
                        onSelect(option)
                    }
                }
            } label: {
                HStack {
                    Text(value.wrappedValue)
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
                                .stroke(
                                    hasError ? AppColors.error.opacity(0.6) : AppColors.primaryLight.opacity(0.12),
                                    lineWidth: 1
                                )
                        )
                )
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var bottomActionSection: some View {
        VStack(spacing: 14) {
            Button(action: {
                vm.continueToNextStep {
                    onFinishTap()
                }
            }) {
                HStack(spacing: 10) {
                    if vm.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    }

                    Text(vm.isLoading ? "Preparing..." : "Finish Setup")
                }
            }
            .buttonStyle(PrimaryButtonStyle())
            .disabled(vm.isLoading)

            Text("This screen currently completes the frontend-only clinic setup structure for future backend integration.")
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
        WorkingScheduleView()
    }
}