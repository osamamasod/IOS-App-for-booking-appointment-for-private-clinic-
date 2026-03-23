
import SwiftUI

struct ProfileView: View {
    var body: some View {
        PlaceholderSectionView(
            title: "Profile",
            subtitle: "This screen will contain user profile data, settings, and account information.",
            systemImage: "person.circle.fill"
        )
        .navigationTitle("Profile")
    }
}
