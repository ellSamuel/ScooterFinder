//
//  Location.swift
//  ScooterFinder
//
//  Created by Samuel Kebis on 09/05/2022.
//

import UIKit
import CoreLocation

class Location {
    static func nearestVehicle(in vehicles: [Vehicle], to location: CLLocation) -> Vehicle? {
        var minimalDistance: Double = .infinity
        var nearest: Vehicle? = nil
        
        for vehicle in vehicles {
            let distance = location.distance(from: vehicle.location)
            if distance < minimalDistance {
                minimalDistance = distance
                nearest = vehicle
            }
        }
        return nearest
    }
    
    static func showLocationRestrictionAlert(in vc: UIViewController) {
        let alert = UIAlertController(title: "Device Location", message: "There is a restriction to access your location.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func openLocationSettings() {
        let appLocationSettingsUrl = URL(string: UIApplication.openSettingsURLString + "root=LOCATION_SERVICES")!
        UIApplication.shared.open(appLocationSettingsUrl)
    }
}
