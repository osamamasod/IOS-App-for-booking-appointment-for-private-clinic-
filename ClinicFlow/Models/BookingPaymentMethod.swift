//
//  BookingPaymentMethod.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 31/03/2026.
//


import Foundation

enum BookingPaymentMethod: String, CaseIterable, Identifiable {
    case cashOnArrival
    case card
    case onlinePayment

    var id: String { rawValue }

    var title: String {
        switch self {
        case .cashOnArrival:
            return "Cash on Arrival"
        case .card:
            return "Credit / Debit Card"
        case .onlinePayment:
            return "Online Payment"
        }
    }

    var subtitle: String {
        switch self {
        case .cashOnArrival:
            return "Pay at the clinic before the appointment starts."
        case .card:
            return "Pay using a bank card at the next confirmation step."
        case .onlinePayment:
            return "Pay online using the available payment gateway."
        }
    }

    var icon: String {
        switch self {
        case .cashOnArrival:
            return "banknote.fill"
        case .card:
            return "creditcard.fill"
        case .onlinePayment:
            return "globe.europe.africa.fill"
        }
    }

    var badgeText: String {
        switch self {
        case .cashOnArrival:
            return "At Clinic"
        case .card:
            return "Card"
        case .onlinePayment:
            return "Online"
        }
    }
}