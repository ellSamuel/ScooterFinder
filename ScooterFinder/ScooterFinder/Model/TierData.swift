//
//  TierData.swift
//  ScooterFinder
//
//  Created by Samuel Kebis on 07/05/2022.
//

import UIKit

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

enum TierVehicleType: String, Codable {
    case eBicycle = "ebicycle"
    case eMoped = "emoped"
    case eScooter = "escooter"
    
    var name: String {
        switch self {
        case .eBicycle: return "Moped"
        case .eMoped: return "Bicycle"
        case .eScooter: return "Scooter"
        }
    }
    
    var annotationColor: UIColor {
        switch self {
        case .eBicycle: return .orange
        case .eMoped: return . purple
        case .eScooter: return .blue
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .eBicycle: return UIImage(named: "moped")?.withRenderingMode(.alwaysTemplate)
        case .eMoped: return UIImage(systemName: "bicycle")?.withRenderingMode(.alwaysTemplate)
        case .eScooter: return UIImage(systemName: "scooter")?.withRenderingMode(.alwaysTemplate)
        }
    }
}

enum TierTypeEnum: String, Decodable {
    case vehicle = "vehicle"
}
