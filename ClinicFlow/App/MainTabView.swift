//
//  MainTabView.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 23/03/2026.
//


import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label(AppTab.home.title, systemImage: AppTab.home.systemImage)
            }
            
            NavigationStack {
                DoctorsView()
            }
            .tabItem {
                Label(AppTab.doctors.title, systemImage: AppTab.doctors.systemImage)
            }
            
            NavigationStack {
                AppointmentsView()
            }
            .tabItem {
                Label(AppTab.appointments.title, systemImage: AppTab.appointments.systemImage)
            }
            
            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label(AppTab.profile.title, systemImage: AppTab.profile.systemImage)
            }
        }
    }
}