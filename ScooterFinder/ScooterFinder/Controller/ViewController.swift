//
//  ViewController.swift
//  ScooterFinder
//
//  Created by Samuel Kebis on 05/05/2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Rest.vehiclesData {
            switch $0 {
            case .success(let vehicles): print("Vehicle data loaded. \(vehicles.count) vehicles initialised.")
            case .error: print("Error loading vehicle data.")
            }
        }
    }
}
