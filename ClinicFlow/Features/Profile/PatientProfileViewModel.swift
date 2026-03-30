//
//  PatientProfileViewModel.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 31/03/2026.
//


//
//  PatientProfileViewModel.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 31/03/2026.
//

import SwiftUI
import Combine

final class PatientProfileViewModel: ObservableObject {
    @Published var fullName: String = "Osama Masoud"
    @Published var email: String = "osama@gmail.com"
    @Published var phoneNumber: String = "+20 100 123 4567"
    @Published var dateOfBirth: String = "12 Mar 2003"
    @Published var gender: String = "Male"

    @Published var isEditingProfile: Bool = false
    @Published var didSignOut: Bool = false

    func signOut() {
        didSignOut = true
    }
}
