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
    
    init?(tierDataElement element: TierDataElement) {
        guard element.type == .vehicle else { return nil }
        
        self.id = element.id
        self.type = element.attributes.vehicleType
        self.lat = element.attributes.lat
        self.lng = element.attributes.lng
        self.batteryLevel = element.attributes.batteryLevel
        self.maxSpeed = element.attributes.maxSpeed
        self.hasHelmetBox = element.attributes.hasHelmetBox
    }
}
