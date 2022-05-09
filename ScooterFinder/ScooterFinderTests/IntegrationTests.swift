//
//  IntegrationTests.swift
//
//  Created by Samuel Kebis on 09/05/2022.
//

import XCTest
@testable import ScooterFinder

class IntegrationTests: XCTestCase {
    
    /// Seconds to wait for each response
    let waitingTime: TimeInterval = 30
    
    func testGetVehicles() {
        let expectation = XCTestExpectation(description: "response")
        Rest.vehiclesData { restlt in
            switch restlt {
            case .success(let vehicles):
                for vehicle in vehicles {
                    XCTAssertGreaterThanOrEqual(vehicle.batteryLevel, 0)
                    XCTAssertLessThanOrEqual(vehicle.batteryLevel, 100)
                    XCTAssertGreaterThanOrEqual(vehicle.lat, -90)
                    XCTAssertLessThanOrEqual(vehicle.lat, 90)
                    XCTAssertGreaterThanOrEqual(vehicle.lng, -180)
                    XCTAssertLessThanOrEqual(vehicle.lng, 180)
                    XCTAssertGreaterThanOrEqual(vehicle.maxSpeed, 0)
                }
                XCTAssertGreaterThan(vehicles.count, 0)
            case .error: XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: waitingTime)
    }
    
    func testTierDataDecoding() {
        guard let path = Bundle(for: IntegrationTests.self).path(forResource: "exampleResponse", ofType: "json") else {
            XCTFail()
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let tierData = try JSONDecoder().decode(TierData.self, from: data)
            XCTAssertEqual(tierData.data.count, 278)
            let vehicles: [Vehicle] = tierData.data.compactMap{ Vehicle(tierDataElement: $0) }
            XCTAssertEqual(vehicles.count, 278)
            guard let firstVehicle = vehicles.first else { XCTFail(); return }
            XCTAssertEqual(firstVehicle.id, "064396c0")
            XCTAssertEqual(firstVehicle.type, .eScooter)
            XCTAssertEqual(firstVehicle.lat, 52.475785)
            XCTAssertEqual(firstVehicle.lng, 13.326359)
            XCTAssertEqual(firstVehicle.batteryLevel, 27)
            XCTAssertEqual(firstVehicle.maxSpeed, 20)
            XCTAssertEqual(firstVehicle.hasHelmetBox, false)
          } catch let error {
              XCTFail(error.localizedDescription)
          }
    }
}
