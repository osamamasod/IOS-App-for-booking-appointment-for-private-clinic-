import SwiftUI

struct DoctorVerificationRejectedView: View {
    let rejectionReason: String?
    var onResubmitTap: () -> Void = {}
    var onCloseTap: () -> Void = {}

    var body: some View {
        DoctorVerificationStatusScreen(
            badgeText: "Rejected",
            title: "Your verification needs updates",
            message: "Your submitted documents could not be approved yet. Please review the reason below and correct the required information.",
            iconName: "xmark.seal.fill",
            statusColor: AppColors.error,
            guidanceTitle: "What you should do",
            guidanceItems: [
                "Review the rejection reason carefully before updating your documents.",
                "Replace any unclear, missing, or incorrect verification files.",
                "After you resubmit, your request can return to pending review."
            ],
            reasonTitle: "Rejection Reason",
            reasonText: rejectionReason ?? "The submitted verification documents need correction before approval.",
            primaryActionTitle: "Correct Information",
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
