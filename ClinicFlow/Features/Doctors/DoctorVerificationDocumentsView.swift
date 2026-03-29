import SwiftUI

struct DoctorVerificationDocumentsView: View {
    @StateObject private var vm = DoctorVerificationDocumentsViewModel()
    @Environment(\.dismiss) private var dismiss

    let flowMode: DoctorVerificationDocumentsFlowMode
    let rejectionReason: String?

    var onContinueTap: () -> Void = {}

    private var isResubmission: Bool {
        flowMode == .resubmission
    }

    var body: some View {
        ZStack {
            AppColors.backgroundDark.ignoresSafeArea()

            ZStack {
                Circle()
                    .fill(AppColors.primary.opacity(0.15))
                    .frame(width: 300, height: 300)
                    .blur(radius: 70)
                    .offset(x: -80, y: -180)

                Circle()
                    .fill(AppColors.accent.opacity(0.1))
                    .frame(width: 240, height: 240)
                    .blur(radius: 60)
                    .offset(x: 120, y: 300)
            }
            .ignoresSafeArea()

            VStack(spacing: 0) {
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

                    Text("Verification")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(AppColors.textSecondary)

                    Spacer()

                    Circle()
                        .fill(Color.clear)
                        .frame(width: 40, height: 40)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        VStack(spacing: 8) {
                            Text(isResubmission ? "Update Verification Documents" : "Verification Documents")
                                .font(.system(size: 30, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.white, AppColors.primaryLight],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )

                            Text(
                                isResubmission
                                ? "Review the rejection reason, correct your files, and resubmit your verification request."
                                : "Upload your medical license and any supporting documents to prepare your verification request."
                            )
                            .font(.system(size: 15, weight: .regular, design: .rounded))
                            .foregroundColor(AppColors.textMuted)
                            .multilineTextAlignment(.leading)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.top, 28)
                        .padding(.bottom, 24)

                        if isResubmission {
                            resubmissionReasonCard
                                .padding(.horizontal, 24)
                                .padding(.bottom, 18)
                        }

                        guidanceCard
                            .padding(.horizontal, 24)
                            .padding(.bottom, 18)

                        VStack(spacing: 16) {
                            documentCard(
                                title: "Medical License",
                                subtitle: "Required for doctor verification",
                                icon: "doc.text.fill",
                                fileName: vm.medicalLicenseFileName,
                                error: vm.medicalLicenseError,
                                attachAction: vm.attachMedicalLicensePlaceholder,
                                removeAction: vm.removeMedicalLicense,
                                actionTitle: vm.hasMedicalLicense ? "Replace File" : "Attach License"
                            )

                            documentCard(
                                title: "Supporting Documents",
                                subtitle: "Optional documents such as certificates or additional proof",
                                icon: "folder.fill.badge.plus",
                                fileName: vm.supportingDocumentFileName,
                                error: nil,
                                attachAction: vm.attachSupportingDocumentPlaceholder,
                                removeAction: vm.removeSupportingDocument,
                                actionTitle: vm.hasSupportingDocument ? "Replace File" : "Attach Document"
                            )
                        }
                        .padding(.horizontal, 24)

                        if let generalError = vm.generalError {
                            HStack(spacing: 6) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 12))

                                Text(generalError)
                                    .font(.system(size: 13, design: .rounded))
                            }
                            .foregroundColor(AppColors.error)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                            .padding(.top, 14)
                        }

                        Spacer().frame(height: 120)
                    }
                }

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

                            Text(
                                vm.isLoading
                                ? (isResubmission ? "Resubmitting..." : "Preparing...")
                                : (isResubmission ? "Resubmit for Review" : "Continue")
                            )
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(vm.isLoading)

                    Text(
                        isResubmission
                        ? "Your updated files will be sent again for review after resubmission."
                        : "Files are currently local placeholders and will be connected to real upload handling later."
                    )
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
        }
        .navigationBarHidden(true)
    }

    private var resubmissionReasonCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(AppColors.error.opacity(0.14))
                        .frame(width: 36, height: 36)

                    Image(systemName: "exclamationmark.bubble.fill")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(AppColors.error)
                }

                Text("Rejection Reason")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
            }

            Text(rejectionReason ?? "Your previous submission needs correction before it can be approved.")
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundColor(AppColors.textSecondary)
        }
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
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(AppColors.primary.opacity(0.15))
                        .frame(width: 36, height: 36)

                    Image(systemName: "shield.checkerboard")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(AppColors.primaryLight)
                }

                Text(isResubmission ? "Resubmission Guidance" : "Verification Guidance")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
            }

            VStack(alignment: .leading, spacing: 8) {
                if isResubmission {
                    guidanceRow("Review the rejection reason and update the required files before submitting again.")
                    guidanceRow("Replace any unclear, incomplete, or incorrect documents.")
                    guidanceRow("Your updated submission is prepared for future backend-connected verification review.")
                } else {
                    guidanceRow("Your medical license is required before your doctor account can be reviewed.")
                    guidanceRow("Supporting documents can strengthen the verification request.")
                    guidanceRow("This step currently prepares the frontend flow for future upload integration.")
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(AppColors.backgroundCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(AppColors.primaryLight.opacity(0.12), lineWidth: 1)
                )
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

    private func documentCard(
        title: String,
        subtitle: String,
        icon: String,
        fileName: String?,
        error: String?,
        attachAction: @escaping () -> Void,
        removeAction: @escaping () -> Void,
        actionTitle: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(AppColors.primary.opacity(0.15))
                        .frame(width: 42, height: 42)

                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(AppColors.primaryLight)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)

                    Text(subtitle)
                        .font(.system(size: 13, weight: .regular, design: .rounded))
                        .foregroundColor(AppColors.textSecondary)
                }

                Spacer()
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("Attachment")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(AppColors.textSecondary)

                HStack(spacing: 10) {
                    Image(systemName: fileName == nil ? "paperclip" : "doc.fill")
                        .foregroundColor(fileName == nil ? AppColors.textMuted : AppColors.success)

                    Text(fileName ?? "No file attached yet")
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(fileName == nil ? AppColors.textMuted : .white)

                    Spacer()
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(AppColors.backgroundDark.opacity(0.35))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(
                                    error != nil ? AppColors.error.opacity(0.6) : AppColors.primaryLight.opacity(0.12),
                                    lineWidth: 1
                                )
                        )
                )
            }

            HStack(spacing: 12) {
                Button(action: attachAction) {
                    Text(actionTitle)
                }
                .buttonStyle(PrimaryButtonStyle(isFullWidth: true))

                if fileName != nil {
                    Button(action: removeAction) {
                        Text("Remove")
                    }
                    .buttonStyle(OutlineButtonStyle(isFullWidth: false))
                }
            }

            if let error = error {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 11))

                    Text(error)
                        .font(.system(size: 12, design: .rounded))
                }
                .foregroundColor(AppColors.error)
            }
        }
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
}

#Preview("Initial") {
    NavigationStack {
        DoctorVerificationDocumentsView(
            flowMode: .initialSubmission,
            rejectionReason: nil
        )
    }
}

#Preview("Resubmission") {
    NavigationStack {
        DoctorVerificationDocumentsView(
            flowMode: .resubmission,
            rejectionReason: "The uploaded medical license was unclear. Please upload a clearer file."
        )
    }
}
