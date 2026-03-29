//
//  ClinicServiceDraft.swift
//  ClinicFlow
//
//  Created by Osama Masoud on 30/03/2026.
//


import Foundation

struct ClinicServiceDraft: Identifiable, Hashable {
    let id: UUID
    var serviceName: String
    var priceText: String
    var durationMinutes: Int

    init(
        id: UUID = UUID(),
        serviceName: String = "",
        priceText: String = "",
        durationMinutes: Int = 30
    ) {
        self.id = id
        self.serviceName = serviceName
        self.priceText = priceText
        self.durationMinutes = durationMinutes
    }
}