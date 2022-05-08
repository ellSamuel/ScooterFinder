//
//  ClusterAnnotationView.swift
//  ScooterFinder
//
//  Created by Samuel Kebis on 08/05/2022.
//

import Foundation
import MapKit

class ClusterAnnotationView: MKAnnotationView {
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .required
        
        if let cluster = annotation as? MKClusterAnnotation,
           let firstVehicle = cluster.memberAnnotations.first as? Vehicle {
            image = clusterImage(
                color: firstVehicle.type.annotationColor,
                count: cluster.memberAnnotations.count
            )
        }
    }
    
    private func clusterImage(color: UIColor, count: Int) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 32, height: 32))
        return renderer.image { _ in
            // Fill full circle with color
            color.setFill()
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 32, height: 32)).fill()
            
            // Fill inner circle with white color
            UIColor.white.setFill()
            UIBezierPath(ovalIn: CGRect(x: 4, y: 4, width: 24, height: 24)).fill()
            
            // Draw count text vertically and horizontally centered
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                              NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
            let text = "\(count)"
            let size = text.size(withAttributes: attributes)
            let rect = CGRect(x: 16 - size.width / 2, y: 16 - size.height / 2, width: size.width, height: size.height)
            text.draw(in: rect, withAttributes: attributes)
        }
    }
}
