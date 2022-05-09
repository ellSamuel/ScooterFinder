//
//  Extensions.swift
//  ScooterFinder
//
//  Created by Samuel Kebis on 09/05/2022.
//

import Foundation

extension URL {
    /// Same as *appendingPathComponent(fileName, isDirectory: false)* but shorter.
    func subFile(_ fileName: String) -> URL {
        appendingPathComponent(fileName, isDirectory: false)
    }
}
