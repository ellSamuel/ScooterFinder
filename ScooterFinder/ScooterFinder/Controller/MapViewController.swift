//
//  MapViewController.swift
//  ScooterFinder
//
//  Created by Samuel Kebis on 07/05/2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var vehicles: [Vehicle] = []
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Berlin region because it is a location of vehicles.
        mapView.setRegion(berlinRegion, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    
    // MARK: - Data
    
    func loadData() {
        Rest.vehiclesData {
            switch $0 {
            case .success(let vehicles):
                self.vehicles = vehicles
                self.reloadAnnotations()
                print("Vehicle data loaded. \(vehicles.count) vehicles initialised.")
            case .error: print("Error loading vehicle data.")
            }
        }
    }
    
    
    // MARK: - Map
    
    let berlinRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 52.5137875, longitude: 13.4048485), latitudinalMeters: 16000, longitudinalMeters: 16000)
    
    func reloadAnnotations() {
        DispatchQueue.main.async { [self] in
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotations(vehicles)
        }
    }
}
