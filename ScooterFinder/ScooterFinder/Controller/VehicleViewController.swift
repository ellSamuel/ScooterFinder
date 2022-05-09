//
//  VehicleViewController.swift
//  ScooterFinder
//
//  Created by Samuel Kebis on 09/05/2022.
//

import UIKit

class VehicleViewController: UIViewController {
    
    @IBOutlet weak var vehicleImageView: UIImageView!
    @IBOutlet weak var helmetImageView: UIImageView!
    @IBOutlet weak var helmetLabel: UILabel!
    @IBOutlet weak var batteryLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    var vehicle: Vehicle!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard vehicle != nil else { navigationController?.popViewController(animated: true); return }
        
        title = vehicle.name
        helmetImageView.isHidden = !vehicle.hasHelmetBox
        vehicleImageView.image = vehicle.type.icon
        helmetLabel.text = "Helmet: " + (vehicle.hasHelmetBox ? "Yes" : "No")
        batteryLabel.text = "Battery: \(vehicle.batteryLevel)%"
        speedLabel.text = "Max speed: \(vehicle.maxSpeed)km/h"
    }
}
