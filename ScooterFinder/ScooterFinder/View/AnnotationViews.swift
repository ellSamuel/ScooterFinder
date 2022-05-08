//
//  AnnotationViews.swift
//  ScooterFinder
//
//  Created by Samuel Kebis on 08/05/2022.
//

import Foundation
import MapKit


// MARK: - Bicycle

class BicycleAnnotationView: MKMarkerAnnotationView {

    static let ReuseID = "bicycleAnnotation"

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "bicycle"
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        markerTintColor = UIColor.orange
        glyphImage = UIImage(systemName: "bicycle")
    }
}


// MARK: - Moped

class MopedAnnotationView: MKMarkerAnnotationView {

    static let ReuseID = "mopedAnnotation"

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "moped"
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        markerTintColor = UIColor.purple
        glyphImage = UIImage(named: "moped")
    }
}


// MARK: - Scooter

class ScooterAnnotationView: MKMarkerAnnotationView {

    static let ReuseID = "scooterAnnotation"

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = "scooter"
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        markerTintColor = UIColor.blue
        glyphImage = UIImage(systemName: "scooter")
    }
}
