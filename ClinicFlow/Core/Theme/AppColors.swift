import SwiftUI

struct AppColors {

    // MARK:  Primary Purple Palette
    static let primary        = Color(hex: "#7C3AED")
    static let primaryLight   = Color(hex: "#A78BFA")
    static let primaryDark    = Color(hex: "#4C1D95")
    static let primaryGlow    = Color(hex: "#7C3AED").opacity(0.18)

    // MARK:  Accent
    static let accent         = Color(hex: "#C084FC")
    static let accentSoft     = Color(hex: "#EDE9FE")

    // MARK:  Backgrounds
    static let backgroundDark  = Color(hex: "#0D0520")
    static let backgroundCard  = Color(hex: "#1A0A35")
    static let backgroundLight = Color(hex: "#F5F3FF")

    // MARK:  Text
    static let textPrimary    = Color(hex: "#FFFFFF")
    static let textSecondary  = Color(hex: "#C4B5FD")
    static let textMuted      = Color(hex: "#7C6BA0")
    static let textDark       = Color(hex: "#1E1030")

    // MARK: Status
    static let success        = Color(hex: "#10B981")
    static let warning        = Color(hex: "#F59E0B")
    static let error          = Color(hex: "#EF4444")
    static let info           = Color(hex: "#60A5FA")

    // MARK:  Gradients
    static let splashGradient = LinearGradient(
        colors: [
            Color(hex: "#0D0520"),
            Color(hex: "#1E0A45"),
            Color(hex: "#2D1063")
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let primaryGradient = LinearGradient(
        colors: [Color(hex: "#7C3AED"), Color(hex: "#A855F7")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let cardGradient = LinearGradient(
        colors: [Color(hex: "#1A0A35"), Color(hex: "#2D1063")],
        startPoint: .top,
        endPoint: .bottom
    )
}

// MARK: - Hex Color Initializer
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
            case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            
case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
    case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
    default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
           self.init(
            .sRGB,
    red: Double(r) / 255,
green: Double(g) / 255,
    blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
