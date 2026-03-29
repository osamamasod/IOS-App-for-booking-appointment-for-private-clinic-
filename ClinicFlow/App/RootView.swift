import SwiftUI

struct RootView: View {
    @State private var showSplash = true
    @State private var path = NavigationPath()

    @State private var verificationDocumentsFlowMode: DoctorVerificationDocumentsFlowMode = .initialSubmission
    @State private var currentRejectionReason: String? = nil

    enum Route: Hashable {
        case signUp
        case signIn
        case doctorOnboarding
        case doctorRegistration
        case doctorVerificationDocuments
        case doctorVerificationStatus(DoctorVerificationStatus)
        case clinicDetails
        case servicesAndPricing
    }

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if showSplash {
                    SplashView(onFinished: {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            showSplash = false
                        }
                    })
                } else {
                    WelcomeView(
                        onCreateAccountTap: {
                            path.append(Route.signUp)
                        },
                        onSignInTap: {
                            path.append(Route.signIn)
                        },
                        onContinueAsGuestTap: {
                            // Future guest flow
                        },
                        onJoinAsDoctorTap: {
                            path.append(Route.doctorOnboarding)
                        }
                    )
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .signUp:
                    PatientSignUpView()

                case .signIn:
                    PatientLogInView()

                case .doctorOnboarding:
                    DoctorOnboardingEntryView(
                        onContinueTap: {
                            path.append(Route.doctorRegistration)
                        }
                    )

                case .doctorRegistration:
                    DoctorRegistrationView(
                        onContinueTap: {
                            verificationDocumentsFlowMode = .initialSubmission
                            currentRejectionReason = nil
                            path.append(Route.doctorVerificationDocuments)
                        }
                    )

                case .doctorVerificationDocuments:
                    DoctorVerificationDocumentsView(
                        flowMode: verificationDocumentsFlowMode,
                        rejectionReason: currentRejectionReason,
                        onContinueTap: {
                            currentRejectionReason = nil
                            path.append(Route.doctorVerificationStatus(.approved))
                        }
                    )

                case .doctorVerificationStatus(let status):
                    DoctorVerificationStatusFlowView(
                        initialStatus: status,
                        rejectionReason: currentRejectionReason,
                        onCloseTap: {
                            path = NavigationPath()
                        },
                        onContinueAfterApprovalTap: {
                            path.append(Route.clinicDetails)
                        },
                        onResubmitTap: {
                            verificationDocumentsFlowMode = .resubmission

                            if currentRejectionReason == nil {
                                currentRejectionReason = "The uploaded medical license file was unclear. Please upload a clearer document."
                            }

                            if !path.isEmpty {
                                path.removeLast()
                            }
                        }
                    )

                case .clinicDetails:
                    ClinicDetailsView(
                        onContinueTap: {
                            path.append(Route.servicesAndPricing)
                        }
                    )

                case .servicesAndPricing:
                    ServicesAndPricingView(
                        onContinueTap: {
                            // Future: navigate to next clinic setup step
                        }
                    )
                }
            }
        }
    }
}

#Preview {
    RootView()
}
