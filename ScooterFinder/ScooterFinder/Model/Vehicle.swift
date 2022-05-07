//
//  Vehicle.swift
//  ScooterFinder
//
//  Created by Samuel Kebis on 07/05/2022.
//

import Foundation

struct Vehicle {
    let id: String
    let type: TierVehicleType
    let lat, lng: Double
    let batteryLevel: Int
    let maxSpeed: Int
    let hasHelmetBox: Bool
}
