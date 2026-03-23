
import Foundation

enum AppTab: String, CaseIterable, Identifiable {
    case home
    case doctors
    case appointments
    case profile
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .doctors:
            return "Doctors"
        case .appointments:
            return "Appointments"
        case .profile:
            return "Profile"
        }
    }
    
    var systemImage: String {
        switch self {
        case .home:
            return "house"
        case .doctors:
            return "stethoscope"
        case .appointments:
            return "calendar"
        case .profile:
            return "person"
        }
    }
}
