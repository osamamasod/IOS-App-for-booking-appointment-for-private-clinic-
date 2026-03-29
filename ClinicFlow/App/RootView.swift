import SwiftUI

struct RootView: View {
    @State private var showSplash = true
    @State private var path = NavigationPath()

    enum Route: Hashable {
        case signUp
        case signIn
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
                        },
                        onJoinAsDoctorTap: {
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
                }
            }
        }
    }
}

#Preview {
    RootView()
}
