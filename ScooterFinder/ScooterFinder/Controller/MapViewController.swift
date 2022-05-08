//
//  MapViewController.swift
//  ScooterFinder
//
//  Created by Samuel Kebis on 07/05/2022.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var vehicles: [Vehicle] = []
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Berlin region because it is a location of vehicles.
        mapView.setRegion(berlinRegion, animated: false)
        mapView.delegate = self
        registerAnnotationViewClasses()
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
    
    func registerAnnotationViewClasses() {
        mapView.register(BicycleAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(ScooterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(MopedAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        mapView.register(ClusterAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? Vehicle else { return nil }
        
        switch annotation.type {
        case .eBicycle: return BicycleAnnotationView(annotation: annotation, reuseIdentifier: BicycleAnnotationView.ReuseID)
        case .eMoped: return MopedAnnotationView(annotation: annotation, reuseIdentifier: MopedAnnotationView.ReuseID)
        case .eScooter: return ScooterAnnotationView(annotation: annotation, reuseIdentifier: ScooterAnnotationView.ReuseID)
        }
    }
}
