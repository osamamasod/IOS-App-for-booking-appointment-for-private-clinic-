//
//  BookingConfirmationViewModel.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 31/03/2026.
//

import SwiftUI
import Combine
final class BookingConfirmationViewModel: ObservableObject {
    let doctor: Doctor
    let clinic: DoctorClinic
    let service: DoctorService
    let slot: ScheduleSlot
    let appointmentDateText: String
    let paymentMethod: BookingPaymentMethod

    init(
        doctor: Doctor,
        clinic: DoctorClinic,
        service: DoctorService,
        slot: ScheduleSlot,
        appointmentDateText: String,
        paymentMethod: BookingPaymentMethod
    ) {
        self.doctor = doctor
        self.clinic = clinic
        self.service = service
        self.slot = slot
        self.appointmentDateText = appointmentDateText
        self.paymentMethod = paymentMethod
    }

    var totalPriceText: String {
        "$\(service.price)"
    }

    var appointmentDateTimeText: String {
        "\(appointmentDateText) • \(slot.time)"
    }

    var clinicLocationText: String {
        clinic.address
    }

    var paymentMethodTitle: String {
        paymentMethod.title
    }

    var paymentMethodSubtitle: String {
        paymentMethod.subtitle
    }
}
