
import Foundation

struct Appointment: Identifiable {
    let id: UUID
    let patientName: String
    let doctorName: String
    let date: Date
    let status: String
}
