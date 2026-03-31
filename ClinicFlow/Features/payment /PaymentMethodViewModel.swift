//
//  PaymentMethodViewModel.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 31/03/2026.
//


import SwiftUI
import Combine

final class PaymentMethodViewModel: ObservableObject {
    let doctor: Doctor
    let clinic: DoctorClinic
    let service: DoctorService
    let slot: ScheduleSlot
    let appointmentDateText: String

    @Published var selectedPaymentMethod: BookingPaymentMethod?

    let methods = BookingPaymentMethod.allCases

    init(
        doctor: Doctor,
        clinic: DoctorClinic,
        service: DoctorService,
        slot: ScheduleSlot,
        appointmentDateText: String
    ) {
        self.doctor = doctor
        self.clinic = clinic
        self.service = service
        self.slot = slot
        self.appointmentDateText = appointmentDateText
    }

    var canContinue: Bool {
        selectedPaymentMethod != nil
    }

    var totalPriceText: String {
        "$\(service.price)"
    }

    var slotText: String {
        slot.time
    }

    func select(_ method: BookingPaymentMethod) {
        selectedPaymentMethod = method
    }
}
