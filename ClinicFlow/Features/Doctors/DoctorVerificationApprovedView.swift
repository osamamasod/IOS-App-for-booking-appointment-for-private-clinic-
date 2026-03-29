//
//  DoctorVerificationApprovedView.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 30/03/2026.
//


import SwiftUI

struct DoctorVerificationApprovedView: View {
    var onContinueTap: () -> Void = {}
    var onBackHomeTap: () -> Void = {}

    var body: some View {
        DoctorVerificationStatusScreen(
            badgeText: "Approved",
            title: "Your account is verified",
            message: "Great news. Your doctor verification has been approved and your account is ready for the next onboarding step.",
            iconName: "checkmark.seal.fill",
            statusColor: AppColors.success,
            guidanceTitle: "Next steps",
            guidanceItems: [
                "You can continue to the next doctor onboarding section.",
                "Clinic setup, availability, and future doctor tools can be connected after this step.",
                "This screen is already structured for backend-driven approved status updates."
            ],
            reasonTitle: nil,
            reasonText: nil,
            primaryActionTitle: "Continue",
            primaryAction: onContinueTap,
            secondaryActionTitle: "Back to Home",
            secondaryAction: onBackHomeTap
        )
    }
}

#Preview {
    NavigationStack {
        DoctorVerificationApprovedView()
    }
}