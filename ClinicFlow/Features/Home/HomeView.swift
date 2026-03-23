
import SwiftUI

struct HomeView: View {
    var body: some View {
        PlaceholderSectionView(
            title: "Home",
            subtitle: "This is the main home screen placeholder for the ClinicFlow app.",
            systemImage: "house.fill"
        )
        .navigationTitle("Home")
    }
}
