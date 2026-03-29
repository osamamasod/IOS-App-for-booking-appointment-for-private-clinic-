//
//  DoctorVerificationPendingReviewView.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 30/03/2026.
//


import SwiftUI

struct DoctorVerificationPendingReviewView: View {
    var onDoneTap: () -> Void = {}

    var body: some View {
        DoctorVerificationStatusScreen(
            badgeText: "Pending Review",
            title: "Your documents are under review",
            message: "Your verification request was submitted successfully. The ClinicFlow team will review your documents soon.",
            iconName: "clock.badge.checkmark.fill",
            statusColor: AppColors.warning,
            guidanceTitle: "What happens next",
            guidanceItems: [
                "Your account stays in review until the verification process is completed.",
                "You can return later to check your status when backend integration is added.",
                "No extra action is needed from you right now unless the review team asks for updates."
            ],
            reasonTitle: nil,
            reasonText: nil,
            primaryActionTitle: "Done",
            primaryAction: onDoneTap,
            secondaryActionTitle: nil,
            secondaryAction: nil
        )
    }
}

#Preview {
    NavigationStack {
        DoctorVerificationPendingReviewView()
    }
}