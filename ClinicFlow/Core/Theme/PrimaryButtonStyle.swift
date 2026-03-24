import SwiftUI

// MARK: - Primary Button Style
struct PrimaryButtonStyle: ButtonStyle {
    var isFullWidth: Bool = true

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold, design: .rounded))
            .foregroundColor(.white)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .frame(height: 54)
            .padding(.horizontal, isFullWidth ? 0 : 32)
            .background(
                ZStack {
                    LinearGradient(
                        colors: [AppColors.primary, Color(hex: "#A855F7")],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                    if configuration.isPressed {
                        Color.black.opacity(0.1)
                    }
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(
                color: AppColors.primary.opacity(configuration.isPressed ? 0.2 : 0.45),
                radius: configuration.isPressed ? 6 : 16,
                x: 0,
                y: configuration.isPressed ? 2 : 8
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Secondary (Outline) Button Style
struct OutlineButtonStyle: ButtonStyle {
    var isFullWidth: Bool = true

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold, design: .rounded))
            .foregroundColor(AppColors.primaryLight)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .frame(height: 54)
            .padding(.horizontal, isFullWidth ? 0 : 32)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(AppColors.primary.opacity(0.08))
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(AppColors.primaryLight.opacity(0.35), lineWidth: 1.5)
                    if configuration.isPressed {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(AppColors.primary.opacity(0.1))
                    }
                }
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Ghost Button Style 
struct GhostButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 15, weight: .medium, design: .rounded))
            .foregroundColor(AppColors.textSecondary)
            .opacity(configuration.isPressed ? 0.6 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

// MARK: - Icon Button Style
struct IconButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 48, height: 48)
            .background(AppColors.primaryGlow)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(AppColors.primaryLight.opacity(0.2), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.93 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Convenience Extensions
extension View {
    func primaryButton(fullWidth: Bool = true) -> some View {
        self.buttonStyle(PrimaryButtonStyle(isFullWidth: fullWidth))
    }

    func outlineButton(fullWidth: Bool = true) -> some View {
        self.buttonStyle(OutlineButtonStyle(isFullWidth: fullWidth))
    }

    func ghostButton() -> some View {
        self.buttonStyle(GhostButtonStyle())
    }

    func iconButton() -> some View {
        self.buttonStyle(IconButtonStyle())
    }
}
