//
//  MapViewController.swift
//  ScooterFinder
//
//  Created by Samuel Kebis on 07/05/2022.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var helmetImageView: UIImageView!
    @IBOutlet weak var bottomImageView: UIImageView!
    @IBOutlet weak var bottomTitle: UILabel!
    @IBOutlet weak var bottomDescription: UILabel!
    @IBOutlet weak var bottomDistanceLabel: UILabel!
    @IBOutlet weak var bottomButton: UIButton!
    @IBOutlet weak var bottomViewOffset: NSLayoutConstraint!
    
    var vehicles: [Vehicle] = []
    var locationManager = CLLocationManager()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Berlin region because it is a location of vehicles.
        mapView.setRegion(berlinRegion, animated: false)
        mapView.delegate = self
        registerAnnotationViewClasses()
        hightlight(selectedVehicle: nil, animated: false)
        vehicles = Storage.vehicles() ?? []
        reloadAnnotations()
        fetchAndDisplayData()
        
        locationManager.delegate = self
        if #available(iOS 14.0, *) {
            locationAuthorizationChanged(status: locationManager.authorizationStatus)
        } else {
            locationAuthorizationChanged(status: CLLocationManager.authorizationStatus())
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shouldHighlightNearestVehicle = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mapToVehicle", let vc = segue.destination as? VehicleViewController, let vehicle = sender as? Vehicle {
            vc.vehicle = vehicle
        }
    }
    
    
    // MARK: - Action
    
    @IBAction func locationClick(_ sender: UIButton) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            if let locationCoordinates = locationManager.location?.coordinate {
                mapView.setCenter(locationCoordinates, animated: true)
            }
        case .denied: Location.openLocationSettings()
        case .notDetermined: locationManager.requestWhenInUseAuthorization()
        case .restricted: Location.showLocationRestrictionAlert(in: self)
        @unknown default: break
        }
    }
    
    @IBAction func bottomButtonClick(_ sender: UIButton) {
        if let vehicle = mapView.selectedAnnotations.first as? Vehicle {
            performSegue(withIdentifier: "mapToVehicle", sender: vehicle)
        }
    }
    
    
    // MARK: - UI
    
    /// Shows the bottom banner with information about vehicle.
    /// Use nil to hide the banner.
    func hightlight(selectedVehicle vehicle: Vehicle?, animated: Bool = true) {
        if let vehicle = vehicle {
            helmetImageView.isHidden = !vehicle.hasHelmetBox
            bottomImageView.image = vehicle.type.icon
            bottomTitle.text = vehicle.name
            bottomDescription.text = "Battery \(vehicle.batteryLevel)%, Max speed \(vehicle.maxSpeed)km/h"
            bottomButton.isHidden = false
            let bottomViewHeight = 66.0
            let homeIndicatorHeight = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
            bottomViewOffset.constant = bottomViewHeight + homeIndicatorHeight
        } else {
            helmetImageView.isHidden = true
            bottomImageView.image = nil
            bottomTitle.text = ""
            bottomDescription.text = ""
            bottomButton.isHidden = true
            bottomViewOffset.constant = 0
        }
        updateDistanceTo(selected: vehicle)
        let duration = animated ? 0.2 : 0
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    func updateDistanceTo(selected vehicle: Vehicle?) {
        if let location = locationManager.location, let vehicle = vehicle {
            let distanceInMeters = Int(location.distance(from: vehicle.location))
            bottomDistanceLabel.text = "\(distanceInMeters)m"
        } else {
            bottomDistanceLabel.text = ""
        }
    }
    
    
    // MARK: - Data
    
    func fetchAndDisplayData() {
        Rest.vehiclesData {
            switch $0 {
            case .success(let vehicles):
                self.vehicles = vehicles
                Storage.save(vehicles: vehicles)
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
            let selected = mapView.selectedAnnotations
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotations(vehicles)
            mapView.selectedAnnotations = selected
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
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let vehicle = mapView.selectedAnnotations.first as? Vehicle
        hightlight(selectedVehicle: vehicle)
        shouldHighlightNearestVehicle = false
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        hightlight(selectedVehicle: nil)
    }
    
    
    // MARK: - Location
    
    // iOS 14
    @available(iOS 14.0, *)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationAuthorizationChanged(status: manager.authorizationStatus)
    }
    
    // iOS 13.* and below
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationAuthorizationChanged(status: status)
    }
    
    func locationAuthorizationChanged(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined: locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse: locationManager.startUpdatingLocation()
        case .restricted, .denied: break
        @unknown default: break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    var shouldHighlightNearestVehicle = false
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        if shouldHighlightNearestVehicle, mapView.selectedAnnotations.isEmpty, let nearestVehicle = Location.nearestVehicle(in: vehicles, to: location) {
            mapView.selectAnnotation(nearestVehicle, animated: false)
            shouldHighlightNearestVehicle = false
        }
    }
}
