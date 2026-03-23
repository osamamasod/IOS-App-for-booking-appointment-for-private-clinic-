
import SwiftUI

struct DoctorsView: View {
    var body: some View {
        PlaceholderSectionView(
            title: "Doctors",
            subtitle: "This screen will display doctors, clinic details, and search results.",
            systemImage: "stethoscope"
        )
        .navigationTitle("Doctors")
    }
}
