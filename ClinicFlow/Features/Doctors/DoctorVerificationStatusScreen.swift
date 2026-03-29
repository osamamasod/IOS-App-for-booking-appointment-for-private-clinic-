//
//  DoctorVerificationStatusScreen.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 30/03/2026.
//


import SwiftUI

struct DoctorVerificationStatusScreen: View {
    @Environment(\.dismiss) private var dismiss

    let badgeText: String
    let title: String
    let message: String
    let iconName: String
    let statusColor: Color
    let guidanceTitle: String
    let guidanceItems: [String]
    let reasonTitle: String?
    let reasonText: String?
    let primaryActionTitle: String?
    let primaryAction: (() -> Void)?
    let secondaryActionTitle: String?
    let secondaryAction: (() -> Void)?

    var body: some View {
        ZStack {
            AppColors.backgroundDark.ignoresSafeArea()

            backgroundGlow

            VStack(spacing: 0) {
                header

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 18) {
                        heroCard

                        if let reasonTitle, let reasonText {
                            reasonCard(title: reasonTitle, text: reasonText)
                        }

                        guidanceCard

                        footerNote
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 28)
                    .padding(.bottom, 120)
                }

                actionSection
            }
        }
        .navigationBarHidden(true)
    }

    private var backgroundGlow: some View {
        ZStack {
            Circle()
                .fill(AppColors.primary.opacity(0.16))
                .frame(width: 320, height: 320)
                .blur(radius: 80)
                .offset(x: -90, y: -210)

            Circle()
                .fill(statusColor.opacity(0.14))
                .frame(width: 240, height: 240)
                .blur(radius: 70)
                .offset(x: 130, y: 280)
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

            Text("Verification Status")
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

    private var heroCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                statusBadge
                Spacer()
            }

            HStack(alignment: .center, spacing: 14) {
                ZStack {
                    Circle()
                        .fill(statusColor.opacity(0.18))
                        .frame(width: 64, height: 64)

                    Image(systemName: iconName)
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundColor(statusColor)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, AppColors.primaryLight],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )

                    Text(message)
                        .font(.system(size: 15, weight: .regular, design: .rounded))
                        .foregroundColor(AppColors.textSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
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

    private var statusBadge: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)

            Text(badgeText)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundColor(statusColor)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(statusColor.opacity(0.14))
        )
    }

    private func reasonCard(title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundColor(.white)

            Text(text)
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundColor(AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(AppColors.backgroundCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(AppColors.error.opacity(0.28), lineWidth: 1)
                )
        )
    }

    private var guidanceCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(guidanceTitle)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.white)

            VStack(alignment: .leading, spacing: 10) {
                ForEach(guidanceItems, id: \.self) { item in
                    HStack(alignment: .top, spacing: 8) {
                        Circle()
                            .fill(AppColors.primaryLight)
                            .frame(width: 6, height: 6)
                            .padding(.top, 6)

                        Text(item)
                            .font(.system(size: 13, weight: .regular, design: .rounded))
                            .foregroundColor(AppColors.textSecondary)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(AppColors.backgroundCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(AppColors.primaryLight.opacity(0.1), lineWidth: 1)
                )
        )
    }

    private var footerNote: some View {
        Text("This screen uses local frontend state for now and is ready to be connected to backend verification updates later.")
            .font(.system(size: 12, design: .rounded))
            .foregroundColor(AppColors.textMuted)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 8)
    }

    private var actionSection: some View {
        VStack(spacing: 12) {
            if let primaryActionTitle, let primaryAction {
                Button(action: primaryAction) {
                    Text(primaryActionTitle)
                }
                .buttonStyle(PrimaryButtonStyle())
            }

            if let secondaryActionTitle, let secondaryAction {
                Button(action: secondaryAction) {
                    Text(secondaryActionTitle)
                }
                .buttonStyle(OutlineButtonStyle())
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 12)
        .padding(.bottom, 36)
        .background(
            LinearGradient(
                colors: [AppColors.backgroundDark.opacity(0), AppColors.backgroundDark],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}