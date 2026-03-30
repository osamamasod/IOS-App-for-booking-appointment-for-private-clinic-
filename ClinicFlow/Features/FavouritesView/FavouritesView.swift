//
//  FavouritesView.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 31/03/2026.
//


import SwiftUI

struct FavouritesView: View {
    var body: some View {
        ZStack {
            AppColors.backgroundDark.ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 48))
                    .foregroundColor(AppColors.primaryLight)

                Text("Favourites")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(AppColors.textPrimary)

                Text("Your saved doctors will appear here")
                    .font(.system(size: 15, design: .rounded))
                    .foregroundColor(AppColors.textMuted)
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview { FavouritesView() }