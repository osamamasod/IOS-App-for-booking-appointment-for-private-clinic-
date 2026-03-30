import Foundation

struct Doctor: Identifiable, Hashable {
    let id: UUID
    let name: String
    let specialty: String
    let clinic: String
    let rating: Double
    let reviewCount: Int
    let distanceKm: Double
    let imageName: String        // SF Symbol name for placeholder
    let isAvailableToday: Bool
    let consultationFee: Int

    static let placeholders: [Doctor] = [
        Doctor(id: UUID(), name: "Dr. Sarah Mitchell",  specialty: "Cardiologist",    clinic: "Heart Care Center",      rating: 4.9, reviewCount: 312, distanceKm: 0.8, imageName: "person.crop.circle.fill", isAvailableToday: true,  consultationFee: 120),
        Doctor(id: UUID(), name: "Dr. James Okafor",    specialty: "Dermatologist",   clinic: "SkinHealth Clinic",      rating: 4.7, reviewCount: 198, distanceKm: 1.2, imageName: "person.crop.circle.fill", isAvailableToday: true,  consultationFee: 95),
        Doctor(id: UUID(), name: "Dr. Lena Hoffmann",   specialty: "Pediatrician",    clinic: "Little Stars Medical",   rating: 4.8, reviewCount: 245, distanceKm: 2.1, imageName: "person.crop.circle.fill", isAvailableToday: false, consultationFee: 85),
        Doctor(id: UUID(), name: "Dr. Ahmed Al-Rashid", specialty: "Orthopedic",      clinic: "BoneJoint Specialists",  rating: 4.6, reviewCount: 167, distanceKm: 3.4, imageName: "person.crop.circle.fill", isAvailableToday: true,  consultationFee: 150),
        Doctor(id: UUID(), name: "Dr. Priya Nair",      specialty: "Neurologist",     clinic: "NeuroWell Center",       rating: 4.9, reviewCount: 289, distanceKm: 4.0, imageName: "person.crop.circle.fill", isAvailableToday: false, consultationFee: 180),
        Doctor(id: UUID(), name: "Dr. Tom Reynolds",    specialty: "General",         clinic: "City Health Clinic",     rating: 4.5, reviewCount: 421, distanceKm: 0.5, imageName: "person.crop.circle.fill", isAvailableToday: true,  consultationFee: 60),
        Doctor(id: UUID(), name: "Dr. Yuki Tanaka",     specialty: "Ophthalmologist", clinic: "ClearVision Eye Care",   rating: 4.7, reviewCount: 134, distanceKm: 1.8, imageName: "person.crop.circle.fill", isAvailableToday: true,  consultationFee: 110),
        Doctor(id: UUID(), name: "Dr. Fatima Zahra",    specialty: "Gynecologist",    clinic: "Women's Wellness Hub",   rating: 4.8, reviewCount: 276, distanceKm: 2.6, imageName: "person.crop.circle.fill", isAvailableToday: false, consultationFee: 130),
    ]
}
