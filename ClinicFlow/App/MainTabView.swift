import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: AppTab = .home

    var body: some View {
        TabView(selection: $selectedTab) {

            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label(AppTab.home.title, systemImage: AppTab.home.systemImage)
            }
            .tag(AppTab.home)

            NavigationStack {
                AppointmentsView()
            }
            .tabItem {
                Label(AppTab.appointments.title, systemImage: AppTab.appointments.systemImage)
            }
            .tag(AppTab.appointments)

            NavigationStack {
                FavouritesView()
            }
            .tabItem {
                Label(AppTab.favourites.title, systemImage: AppTab.favourites.systemImage)
            }
            .tag(AppTab.favourites)

            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label(AppTab.profile.title, systemImage: AppTab.profile.systemImage)
            }
            .tag(AppTab.profile)
        }
        .tint(AppColors.primaryLight)
        .onAppear { applyTabBarAppearance() }
    }

    private func applyTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()

        appearance.backgroundColor = UIColor(AppColors.backgroundCard)
        appearance.shadowColor = UIColor(AppColors.primaryLight.opacity(0.15))

        let normalAttrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(AppColors.textMuted)
        ]
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttrs
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor(AppColors.textMuted)

        let selectedAttrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(AppColors.primaryLight)
        ]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttrs
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor(AppColors.primaryLight)

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview { MainTabView() }
