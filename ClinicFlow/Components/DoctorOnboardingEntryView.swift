//
//  DoctorOnboardingEntryView.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 29/03/2026.
//


import SwiftUI

struct DoctorOnboardingEntryView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            AppColors.backgroundDark.ignoresSafeArea()

            VStack(spacing: 24) {
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
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                Spacer()

                VStack(spacing: 12) {
                    Text("Doctor Onboarding")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, AppColors.primaryLight],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )

                    Text("This is the entry point for the doctor onboarding flow.")
                        .font(.system(size: 15, weight: .regular, design: .rounded))
                        .foregroundColor(AppColors.textMuted)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }

                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationStack {
        DoctorOnboardingEntryView()
    }
}