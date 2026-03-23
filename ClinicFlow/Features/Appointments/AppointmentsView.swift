
import SwiftUI

struct AppointmentsView: View {
    var body: some View {
        PlaceholderSectionView(
            title: "Appointments",
            subtitle: "This screen will manage booked appointments and scheduling information.",
            systemImage: "calendar"
        )
        .navigationTitle("Appointments")
    }
}
