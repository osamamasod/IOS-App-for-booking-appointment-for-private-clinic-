//
//  DoctorVerificationStatus.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 30/03/2026.
//


import SwiftUI
import Combine

enum DoctorVerificationStatus: String, Hashable, CaseIterable {
    case pendingReview
    case approved
    case rejected
}

final class DoctorVerificationStatusViewModel: ObservableObject {
    @Published var status: DoctorVerificationStatus
    @Published var rejectionReason: String?

    init(
        status: DoctorVerificationStatus = .pendingReview,
        rejectionReason: String? = nil
    ) {
        self.status = status
        self.rejectionReason = rejectionReason
    }

    func updateStatus(
        _ newStatus: DoctorVerificationStatus,
        rejectionReason: String? = nil
    ) {
        status = newStatus
        self.rejectionReason = rejectionReason
    }
}
