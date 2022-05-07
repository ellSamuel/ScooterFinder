//
//  Rest.swift
//  ScooterFinder
//
//  Created by Samuel Kebis on 07/05/2022.
//

import Foundation

class Rest {
    
    static func vehiclesData(completion: @escaping (ResultEnum<[Vehicle]>) -> Void) {
        makeRequest(.vehiclesData) { (result: ResultEnum<TierData>) in
            switch result {
            case .success(let tierData):
                let vehicles: [Vehicle] = tierData.data.compactMap{ Vehicle(tierDataElement: $0) }
                completion(.success(value: vehicles))
            case .error: completion(.error)
            }
        }
    }
    
    
    // MARK: - Private
    
    private enum Endpoint {
        case vehiclesData
        
        var url: URL { URL(string: baseUrl + path)! }
        
        private var path: String {
            switch self {
            case .vehiclesData: return "take_home_test_data.json"
            }
        }
        
        var method: String {
            switch self {
            case .vehiclesData: return "GET"
            }
        }
    }
    
    private static let baseUrl = "https://takehometest-production-takehometest.s3.eu-central-1.amazonaws.com/public/"
    
    private static let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        configuration.httpAdditionalHeaders = ["Accept": "application/json"]
        return URLSession(configuration: configuration)
    }()
    
    
    // MARK: - Utilities
    
    enum ResultEnum<T> {
        case success(value: T)
        case error
    }
    
    private static func makeRequest<T: Decodable>(_ requestEnum: Endpoint, completion: @escaping (ResultEnum<T>) -> Void) {
        var request = URLRequest(url: requestEnum.url)
        request.httpMethod = requestEnum.method
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.error)
                return
            }
            
            guard let data = data else {
                print("Data nil while decoding response")
                completion(.error)
                return
            }
            
            do {
                let value = try JSONDecoder().decode(T.self, from: data)
                print("Successfully decode")
                completion(.success(value: value))
            } catch let error {
                print(error.localizedDescription)
                completion(.error)
            }
        }
        
        print("Make request")
        task.resume()
    }
}
