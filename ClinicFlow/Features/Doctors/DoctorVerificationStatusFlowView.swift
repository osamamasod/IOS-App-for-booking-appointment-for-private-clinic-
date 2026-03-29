//
//  DoctorVerificationStatusFlowView.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 30/03/2026.
//


import SwiftUI

struct DoctorVerificationStatusFlowView: View {
    @StateObject private var vm: DoctorVerificationStatusViewModel

    var onCloseTap: () -> Void = {}
    var onContinueAfterApprovalTap: () -> Void = {}
    var onResubmitTap: () -> Void = {}

    init(
        initialStatus: DoctorVerificationStatus = .pendingReview,
        rejectionReason: String? = nil,
        onCloseTap: @escaping () -> Void = {},
        onContinueAfterApprovalTap: @escaping () -> Void = {},
        onResubmitTap: @escaping () -> Void = {}
    ) {
        _vm = StateObject(
            wrappedValue: DoctorVerificationStatusViewModel(
                status: initialStatus,
                rejectionReason: rejectionReason
            )
        )
        self.onCloseTap = onCloseTap
        self.onContinueAfterApprovalTap = onContinueAfterApprovalTap
        self.onResubmitTap = onResubmitTap
    }

    var body: some View {
        Group {
            switch vm.status {
            case .pendingReview:
                DoctorVerificationPendingReviewView(
                    onDoneTap: onCloseTap
                )

            case .approved:
                DoctorVerificationApprovedView(
                    onContinueTap: onContinueAfterApprovalTap,
                    onBackHomeTap: onCloseTap
                )

            case .rejected:
                DoctorVerificationRejectedView(
                    rejectionReason: vm.rejectionReason,
                    onResubmitTap: onResubmitTap,
                    onCloseTap: onCloseTap
                )
            }
        }
    }
}

#Preview("Pending") {
    NavigationStack {
        DoctorVerificationStatusFlowView(initialStatus: .pendingReview)
    }
}

#Preview("Approved") {
    NavigationStack {
        DoctorVerificationStatusFlowView(initialStatus: .approved)
    }
}

#Preview("Rejected") {
    NavigationStack {
        DoctorVerificationStatusFlowView(
            initialStatus: .rejected,
            rejectionReason: "The uploaded medical license file was incomplete."
        )
    }
}