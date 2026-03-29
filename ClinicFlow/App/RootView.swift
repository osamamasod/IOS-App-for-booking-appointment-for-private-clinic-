import SwiftUI

struct RootView: View {
    @State private var showSplash = true
    @State private var path = NavigationPath()

    enum Route: Hashable {
        case signUp
        case signIn
        case doctorOnboarding
        case doctorRegistration
        case doctorVerificationDocuments
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
                            path.append(Route.doctorVerificationDocuments)
                        }
                    )

                case .doctorVerificationDocuments:
                    DoctorVerificationDocumentsView()
                }
            }
        }
    }
}

#Preview {
    RootView()
}
