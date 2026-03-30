import SwiftUI

struct PatientAppointmentsView: View {
    @StateObject private var viewModel = PatientAppointmentsViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                headerSection
                upcomingSection
                completedSection
            }
            .padding(20)
        }
        .background(AppColors.backgroundDark.ignoresSafeArea())
        .navigationTitle("Appointments")
        .navigationBarTitleDisplayMode(.large)
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Your Appointments")
                .font(.title2.bold())
                .foregroundStyle(.white)

            Text("Track your upcoming visit and review your completed appointments.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.75))
        }
    }

    private var upcomingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Upcoming Appointments")

            if let nextAppointment = viewModel.upcomingAppointments.first {
                AppointmentCardView(
                    appointment: nextAppointment,
                    isUpcoming: true
                )
            } else {
                EmptyStateCardView(
                    title: "No upcoming appointments yet",
                    message: "Your next scheduled appointment will appear here."
                )
            }
        }
    }

    private var completedSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("Completed Appointments")

            if viewModel.completedAppointments.isEmpty {
                EmptyStateCardView(
                    title: "No completed appointments yet",
                    message: "Your past appointments will appear here after they are completed."
                )
            } else {
                ForEach(viewModel.completedAppointments) { appointment in
                    AppointmentCardView(
                        appointment: appointment,
                        isUpcoming: false
                    )
                }
            }
        }
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(.white)
    }
}

private struct AppointmentCardView: View {
    let appointment: PatientAppointmentItem
    let isUpcoming: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(appointment.doctorName)
                        .font(.headline)
                        .foregroundStyle(.white)

                    Text(appointment.specialty)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.7))
                }

                Spacer()

                Text(appointment.status)
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        isUpcoming
                        ? AppColors.primary.opacity(0.18)
                        : AppColors.accent.opacity(0.18)
                    )
                    .foregroundStyle(
                        isUpcoming
                        ? AppColors.primaryLight
                        : AppColors.accent
                    )
                    .clipShape(Capsule())
            }

            Divider()
                .overlay(.white.opacity(0.08))

            InfoRow(icon: "building.2", text: appointment.clinicName)
            InfoRow(icon: "calendar", text: appointment.dateText)
            InfoRow(icon: "clock", text: appointment.timeText)
        }
        .padding(16)
        .background(
            LinearGradient(
                colors: [
                    AppColors.primaryDark.opacity(0.35),
                    AppColors.backgroundDark.opacity(0.95)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(AppColors.primary.opacity(0.18), lineWidth: 1)
        )
        .shadow(color: AppColors.primary.opacity(0.12), radius: 10, x: 0, y: 6)
    }
}

private struct InfoRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .frame(width: 18)
                .foregroundStyle(AppColors.primaryLight)

            Text(text)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.88))
        }
    }
}

private struct EmptyStateCardView: View {
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 28))
                .foregroundStyle(AppColors.primaryLight)

            Text(title)
                .font(.headline)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.72))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(
            LinearGradient(
                colors: [
                    AppColors.primaryDark.opacity(0.3),
                    AppColors.backgroundDark.opacity(0.95)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(AppColors.primary.opacity(0.18), lineWidth: 1)
        )
    }
}

#Preview {
    NavigationStack {
        PatientAppointmentsView()
    }
}
