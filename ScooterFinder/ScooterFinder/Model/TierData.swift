//
//  TierData.swift
//  ScooterFinder
//
//  Created by Samuel Kebis on 07/05/2022.
//

import Foundation

struct TierData: Decodable {
    let data: [TierDataElement]
}

struct TierDataElement: Decodable {
    let type: TierTypeEnum
    let id: String
    let attributes: TierAttributes
}

struct TierAttributes: Decodable {
    let batteryLevel: Int
    let lat, lng: Double
    let maxSpeed: Int
    let vehicleType: TierVehicleType
    let hasHelmetBox: Bool
}

enum TierVehicleType: String, Decodable {
    case eBicycle = "ebicycle"
    case eMoped = "emoped"
    case eScooter = "escooter"
}

enum TierTypeEnum: String, Decodable {
    case vehicle = "vehicle"
}
