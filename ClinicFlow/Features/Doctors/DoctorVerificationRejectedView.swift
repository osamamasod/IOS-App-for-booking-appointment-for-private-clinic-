//
//  DoctorVerificationRejectedView.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 30/03/2026.
//


import SwiftUI

struct DoctorVerificationRejectedView: View {
    let rejectionReason: String?
    var onResubmitTap: () -> Void = {}
    var onCloseTap: () -> Void = {}

    var body: some View {
        DoctorVerificationStatusScreen(
            badgeText: "Rejected",
            title: "Your verification needs updates",
            message: "Your submitted documents could not be approved yet. Please review the reason below and update your verification files.",
            iconName: "xmark.seal.fill",
            statusColor: AppColors.error,
            guidanceTitle: "What you should do",
            guidanceItems: [
                "Review the rejection reason carefully before uploading new documents.",
                "Update the medical license or supporting documents if anything is missing or unclear.",
                "After backend integration, this screen can show the real rejection reason directly from the API."
            ],
            reasonTitle: "Reason",
            reasonText: rejectionReason ?? "The submitted verification documents need correction before approval.",
            primaryActionTitle: "Update Documents",
            primaryAction: onResubmitTap,
            secondaryActionTitle: "Not Now",
            secondaryAction: onCloseTap
        )
    }
}

#Preview {
    NavigationStack {
        DoctorVerificationRejectedView(
            rejectionReason: "The uploaded medical license file was unclear. Please upload a clearer document."
        )
    }
}