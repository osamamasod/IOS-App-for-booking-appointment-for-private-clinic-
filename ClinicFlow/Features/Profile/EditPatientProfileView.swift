//
//  EditPatientProfileView.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 31/03/2026.
//


//
//  EditPatientProfileView.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 31/03/2026.
//

import SwiftUI

struct EditPatientProfileView: View {
    @ObservedObject var vm: PatientProfileViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showAvatarPlaceholderAlert = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.backgroundDark.ignoresSafeArea()

                ZStack {
                    Circle()
                        .fill(AppColors.primary.opacity(0.10))
                        .frame(width: 300, height: 300)
                        .blur(radius: 80)
                        .offset(x: 130, y: -220)

                    Circle()
                        .fill(AppColors.accent.opacity(0.08))
                        .frame(width: 240, height: 240)
                        .blur(radius: 70)
                        .offset(x: -120, y: 360)
                }
                .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        avatarSection
                            .padding(.horizontal, 24)
                            .padding(.top, 24)

                        formSection
                            .padding(.horizontal, 24)
                            .padding(.top, 24)

                        actionButtons
                            .padding(.horizontal, 24)
                            .padding(.top, 24)

                        Spacer().frame(height: 60)
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        vm.cancelEditing()
                        dismiss()
                    }
                    .foregroundColor(AppColors.textMuted)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        vm.saveChanges()
                        dismiss()
                    }
                    .foregroundColor(AppColors.primaryLight)
                }
            }
            .alert("Change Avatar", isPresented: $showAvatarPlaceholderAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Avatar change will be connected later in the backend-supported profile flow.")
            }
        }
    }

    private var avatarSection: some View {
        VStack(spacing: 14) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(AppColors.primaryGlow)
                    .frame(width: 104, height: 104)

                Image(systemName: "person.fill")
                    .font(.system(size: 36))
                    .foregroundColor(AppColors.primaryLight)

                Button(action: {
                    showAvatarPlaceholderAlert = true
                }) {
                    ZStack {
                        Circle()
                            .fill(AppColors.primary)
                            .frame(width: 34, height: 34)

                        Image(systemName: "camera.fill")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                    }
                }
                .offset(x: 2, y: 2)
            }

            Button(action: {
                showAvatarPlaceholderAlert = true
            }) {
                Text("Change Avatar")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(AppColors.primaryLight)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(AppColors.backgroundCard)
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(AppColors.primaryLight.opacity(0.12), lineWidth: 1)
                )
        )
    }

    private var formSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Personal Information")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.white)

            VStack(spacing: 14) {
                ProfileTextField(
                    title: "Full Name",
                    placeholder: "Enter your full name",
                    text: $vm.editName,
                    keyboardType: .default
                )

                ProfileTextField(
                    title: "Phone",
                    placeholder: "Enter your phone number",
                    text: $vm.editPhoneNumber,
                    keyboardType: .phonePad
                )

                ProfileDatePickerField(
                    title: "Date of Birth",
                    date: $vm.editDateOfBirth
                )

                ProfileGenderPickerField(
                    title: "Gender",
                    selection: $vm.editGender,
                    options: vm.genderOptions
                )
            }
        }
    }

    private var actionButtons: some View {
        VStack(spacing: 14) {
            Button(action: {
                vm.saveChanges()
                dismiss()
            }) {
                Text("Save Changes")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(
                        LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryDark],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }

            Button(action: {
                vm.cancelEditing()
                dismiss()
            }) {
                Text("Cancel")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundColor(AppColors.textSecondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(AppColors.backgroundCard)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(AppColors.primaryLight.opacity(0.12), lineWidth: 1)
                            )
                    )
            }
        }
    }
}

// MARK: - Reusable Fields
struct ProfileTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let keyboardType: UIKeyboardType

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(AppColors.textMuted)

            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(AppColors.backgroundCard)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(AppColors.primaryLight.opacity(0.12), lineWidth: 1)
                        )
                )
        }
    }
}

struct ProfileDatePickerField: View {
    let title: String
    @Binding var date: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(AppColors.textMuted)

            DatePicker(
                "",
                selection: $date,
                in: ...Date(),
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
            .labelsHidden()
            .tint(AppColors.primaryLight)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(AppColors.backgroundCard)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(AppColors.primaryLight.opacity(0.12), lineWidth: 1)
                    )
            )
        }
    }
}

struct ProfileGenderPickerField: View {
    let title: String
    @Binding var selection: String
    let options: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(AppColors.textMuted)

            Menu {
                ForEach(options, id: \.self) { option in
                    Button(option) {
                        selection = option
                    }
                }
            } label: {
                HStack {
                    Text(selection)
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .foregroundColor(.white)

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(AppColors.textMuted)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(AppColors.backgroundCard)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(AppColors.primaryLight.opacity(0.12), lineWidth: 1)
                        )
                )
            }
        }
    }
}

#Preview {
    EditPatientProfileView(vm: PatientProfileViewModel())
}