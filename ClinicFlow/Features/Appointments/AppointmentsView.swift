import SwiftUI

struct AppointmentsView: View {
    var body: some View {
        PatientAppointmentsView()
    }
}

#Preview {
    NavigationStack {
        AppointmentsView()
    }
}
