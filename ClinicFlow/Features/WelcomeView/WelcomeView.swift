import SwiftUI

struct WelcomeView: View {

    var onCreateAccountTap: () -> Void = {}
    var onSignInTap: () -> Void = {}
    var onContinueAsGuestTap: () -> Void = {}
    var onJoinAsDoctorTap: () -> Void = {}
    @State private var backgroundOpacity: Double  = 0
    @State private var logoScale: CGFloat         = 0.5
    @State private var logoOpacity: Double        = 0
    @State private var headlineOffset: CGFloat    = 24
    @State private var headlineOpacity: Double    = 0
    @State private var featuresOpacity: Double    = 0
    @State private var featuresOffset: CGFloat    = 20
    @State private var buttonsOffset: CGFloat     = 30
    @State private var buttonsOpacity: Double     = 0
    @State private var topBadgeOpacity: Double    = 0
    @State private var topBadgeOffset: CGFloat    = -10
    @State private var activeFeature: Int         = 0
    let features: [FeatureItem] = [
        FeatureItem(icon: "calendar.badge.plus",       title: "Smart Booking",  description: "Schedule appointments in seconds"),
        FeatureItem(icon: "stethoscope",               title: "Top Doctors",    description: "Connect with verified specialists"),
        FeatureItem(icon: "chart.line.uptrend.xyaxis", title: "Track Health",   description: "Monitor your clinic visits easily"),
    ]

    var body: some View {
        ZStack(alignment: .top) {

            AppColors.backgroundDark.ignoresSafeArea()

            ZStack {
                Circle()
                    .fill(AppColors.primary.opacity(0.18))
                    .frame(width: 350, height: 350)
                    .blur(radius: 80)
                    .offset(x: -80, y: -200)
                Circle()
                    .fill(AppColors.accent.opacity(0.12))
                    .frame(width: 280, height: 280)
                    .blur(radius: 70)
                    .offset(x: 120, y: 250)
            }
            .opacity(backgroundOpacity)
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer().frame(height: 100)

                ZStack {
                    Circle()
                        .fill(AppColors.primaryGlow)
                        .frame(width: 80, height: 80)
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [AppColors.primary, AppColors.primaryDark],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 64, height: 64)
                        .shadow(color: AppColors.primary.opacity(0.5), radius: 20, x: 0, y: 8)
                    ClinicIconShape()
                        .fill(Color.white)
                        .frame(width: 28, height: 28)
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)

                Spacer().frame(height: 28)

                VStack(spacing: 8) {
                    Text("Welcome to")
                        .font(.system(size: 18, weight: .regular, design: .rounded))
                        .foregroundColor(AppColors.textSecondary)

                    Text("ClinicFlow")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, AppColors.primaryLight],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )

                    Text("Smart care, seamlessly managed")
                        .font(.system(size: 15, weight: .regular, design: .rounded))
                        .foregroundColor(AppColors.textMuted)
                        .multilineTextAlignment(.center)
                }
                .offset(y: headlineOffset)
                .opacity(headlineOpacity)

                Spacer().frame(height: 48)

                VStack(spacing: 20) {
                    HStack(spacing: 8) {
                        ForEach(0..<features.count, id: \.self) { i in
                            Capsule()
                                .fill(i == activeFeature ? AppColors.primary : AppColors.primary.opacity(0.2))
                                .frame(height: 4)
                                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: activeFeature)
                                .onTapGesture {
                                    activeFeature = i
                                }
                        }
                    }
                    .padding(.horizontal, 40)

                    ZStack {
                        ForEach(0..<features.count, id: \.self) { i in
                            FeatureCard(item: features[i])
                                .opacity(i == activeFeature ? 1 : 0)
                                .offset(x: i == activeFeature ? 0 : (i < activeFeature ? -30 : 30))
                                .animation(.spring(response: 0.45, dampingFraction: 0.8), value: activeFeature)
                        }
                    }
                    .frame(height: 130)
                    .padding(.horizontal, 24)
                }
                .opacity(featuresOpacity)
                .offset(y: featuresOffset)

                Spacer()

                VStack(spacing: 14) {
                    Button(action: onCreateAccountTap) {
                        Text("Create an Account")
                    }
                    .buttonStyle(PrimaryButtonStyle())

                    Button(action: onSignInTap) {
                        Text("Sign In")
                    }
                    .buttonStyle(OutlineButtonStyle())

                    Button(action: onContinueAsGuestTap) {
                        Text("Continue as guest")
                            .font(.system(size: 14, weight: .regular, design: .rounded))
                            .foregroundColor(AppColors.textMuted)
                    }
                    .buttonStyle(GhostButtonStyle())
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 48)
                .offset(y: buttonsOffset)
                .opacity(buttonsOpacity)
            }

            HStack {
                Spacer()

                Button(action: onJoinAsDoctorTap) {
                    HStack(spacing: 6) {
                        Image(systemName: "stethoscope")
                            .font(.system(size: 12, weight: .semibold))

                        Text("Join as Doctor")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                    }
                    .foregroundColor(AppColors.primaryLight)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 9)
                    .background(
                        Capsule()
                            .fill(AppColors.primary.opacity(0.15))
                            .overlay(
                                Capsule()
                                    .stroke(AppColors.primaryLight.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
                .padding(.top, 56)
                .padding(.trailing, 20)
                .opacity(topBadgeOpacity)
                .offset(y: topBadgeOffset)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            runAnimations()
            startFeatureAutoScroll()
        }
    }

    private func runAnimations() {
        withAnimation(.easeOut(duration: 0.8)) {
            backgroundOpacity = 1
        }

        withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.2)) {
            topBadgeOpacity = 1
            topBadgeOffset = 0
        }

        withAnimation(.spring(response: 0.7, dampingFraction: 0.65).delay(0.2)) {
            logoScale = 1
            logoOpacity = 1
        }

        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.4)) {
            headlineOffset = 0
            headlineOpacity = 1
        }

        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.55)) {
            featuresOpacity = 1
            featuresOffset = 0
        }

        withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.7)) {
            buttonsOffset = 0
            buttonsOpacity = 1
        }
    }

    private func startFeatureAutoScroll() {
        Timer.scheduledTimer(withTimeInterval: 2.8, repeats: true) { _ in
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                activeFeature = (activeFeature + 1) % features.count
            }
        }
    }
}

struct FeatureItem {
    let icon: String
    let title: String
    let description: String
}

struct FeatureCard: View {
    let item: FeatureItem

    var body: some View {
        HStack(spacing: 20) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(AppColors.primaryGlow)
                    .frame(width: 64, height: 64)

                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(AppColors.primaryLight.opacity(0.2), lineWidth: 1)
                    .frame(width: 64, height: 64)

                Image(systemName: item.icon)
                    .font(.system(size: 26, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [AppColors.primaryLight, AppColors.accent],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(item.title)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)

                Text(item.description)
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(AppColors.textSecondary)
                    .lineLimit(2)
            }

            Spacer()
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(AppColors.backgroundCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(AppColors.primaryLight.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

#Preview {
    NavigationStack {
        WelcomeView()
    }
}
