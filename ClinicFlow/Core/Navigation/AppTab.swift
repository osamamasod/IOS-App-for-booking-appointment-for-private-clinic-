import Foundation

enum AppTab: String, CaseIterable, Identifiable {
    case home
    case appointments
    case favourites
    case profile

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home:         return "Home"
        case .appointments: return "Appointments"
        case .favourites:   return "Favourites"
        case .profile:      return "Profile"
        }
    }

    var systemImage: String {
        switch self {
        case .home:         return "house.fill"
        case .appointments: return "calendar"
        case .favourites:   return "heart.fill"
        case .profile:      return "person.fill"
        }
    }
}
